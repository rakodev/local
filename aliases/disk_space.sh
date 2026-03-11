# !/bin/bash

# Function to show meaningful disk space on macOS APFS:
# - Container space (actual free/total at APFS level)
# - Data volume usage (where user/application data lives)
unalias ds_disk_space 2>/dev/null
ds_disk_space() {
    echo "APFS container space (diskutil):"
    /usr/sbin/diskutil info / 2>/dev/null | /usr/bin/grep -E 'Container Total Space|Container Free Space|Purgeable Space'

    echo
    echo "Data volume usage (df):"
    /bin/df -h /System/Volumes/Data 2>/dev/null || /bin/df -h /
}

# # Alias to check largest directories in the given path, don't display Operation not permitted errors
# alias largest_dirs='du -sh ~/Library/* 2>/dev/null | sort -h -r | head -n 10'
# alias largest_dirs='du -sh ~/work/* 2>/dev/null | sort -h -r | head -n 10'
# alias largest_dirs='du -sh ~/aram/* 2>/dev/null | sort -h -r | head -n 10'

#  18G	/Users/ramazan.korkmaz/work
#  28G	/Users/ramazan.korkmaz/aram
# 187G	/Users/ramazan.korkmaz/Library


# # Alias to check largest files in the given path, don't display Operation not permitted errors
# alias largest_files='find ~/Library -type f -exec du -h {} + 2>/dev/null | sort -h -r | head -n 10'

ds_largest_dirs_recursive() {
    local path="."
    local use_cache=1
    local ttl=300
    local tmp i size dir human selected_line selected_size selected_dir parent choice
    local cache_dir cache_key cache_file now cache_mtime cache_age used_cached
    local lock_file refresh_started

    # Usage:
    #   ds_largest_dirs_recursive [path] [--fresh] [--ttl SECONDS]
    # Examples:
    #   ds_largest_dirs_recursive ~/Library
    #   ds_largest_dirs_recursive /System/Volumes/Data --fresh
    #   ds_largest_dirs_recursive ~/work --ttl 300
    # Notes:
    #   - default mode is fast: reuses cache immediately
    #   - if cache is older than --ttl, it is refreshed in background
    #   - --fresh forces a live (synchronous) scan
    while [ $# -gt 0 ]; do
        case "$1" in
            --fresh)
                use_cache=0
                ;;
            --cached)
                use_cache=1
                ;;
            --ttl)
                shift
                ttl="${1:-}"
                if ! printf "%s" "$ttl" | /usr/bin/grep -Eq '^[0-9]+$'; then
                    echo "Invalid --ttl value (must be a non-negative integer)" >&2
                    return 1
                fi
                ;;
            --help|-h)
                echo "Usage: ds_largest_dirs_recursive [path] [--fresh] [--ttl SECONDS]"
                return 0
                ;;
            *)
                path="$1"
                ;;
        esac
        shift
    done

    # helper: convert KB to human readable (K, M, G)
    human_kb() {
        /usr/bin/awk -v k="$1" 'BEGIN{split("K M G T P",U);s=k;i=0;while(s>=1024&&i<4){s=s/1024;i++} if(i==0){printf "%dK",k}else{printf "%.1f%s",s,U[i+1]}}'
    }

    # create a temp file robustly:
    # 1) try /usr/bin/mktemp with TMPDIR pattern
    # 2) try /usr/bin/mktemp -t (mac fallback)
    # 3) fall back to creating file in TMPDIR or /tmp
    if [ -x /usr/bin/mktemp ]; then
        tmp=""
        tmp=$(/usr/bin/mktemp "${TMPDIR:-/tmp}/ds_largest_dirs_XXXXXX" 2>/dev/null) || tmp=$(/usr/bin/mktemp -t ds_largest_dirs 2>/dev/null) || tmp=""
    fi
    if [ -z "$tmp" ]; then
        tmp="${TMPDIR:-/tmp}/ds_largest_dirs_$$.$RANDOM"
        if ! : > "$tmp" 2>/dev/null; then
            tmp="/tmp/ds_largest_dirs_$$.$RANDOM"
            if ! : > "$tmp" 2>/dev/null; then
                echo "Failed to create temp file (tried /usr/bin/mktemp and fallback locations)" >&2
                return 1
            fi
        fi
    fi
    cache_dir="${TMPDIR:-/tmp}/ds_largest_dirs_cache"
    if [ "$use_cache" -eq 1 ]; then
        /bin/mkdir -p "$cache_dir" 2>/dev/null || true
    fi

    # one-pass scanner (faster than running one du process per directory)
    scan_dirs_once() {
        /usr/bin/du -kx -d 1 "$1" 2>/dev/null | \
            /usr/bin/awk -F $'\t' -v p="$1" 'NF>=2 && $2 != p {print $0}' | \
            /usr/bin/sort -nr
    }

    while true; do
        echo
        echo "Top 10 directories by size in: $path"
        echo "------------------------------------------------------------"

        # reset temp file so previous iteration data cannot leak into this path
        : > "$tmp"

        cache_age=""
        used_cached=0
        refresh_started=0
        if [ "$use_cache" -eq 1 ]; then
            cache_key="$(/sbin/md5 -qs "$path" 2>/dev/null || printf "%s" "$path" | /usr/bin/shasum | /usr/bin/awk '{print $1}')"
            cache_file="$cache_dir/$cache_key.txt"
            lock_file="$cache_dir/$cache_key.lock"

            if [ -s "$cache_file" ]; then
                now="$(/bin/date +%s)"
                cache_mtime="$(/usr/bin/stat -f %m "$cache_file" 2>/dev/null || echo 0)"
                cache_age=$((now - cache_mtime))
                /bin/cp "$cache_file" "$tmp" 2>/dev/null || true
                if [ -s "$tmp" ]; then
                    used_cached=1
                fi
            fi

            # keep UI fast: if cache is stale, refresh asynchronously for next use
            if [ "$used_cached" -eq 1 ] && [ -n "$cache_age" ] && [ "$cache_age" -gt "$ttl" ]; then
                if [ ! -e "$lock_file" ]; then
                    : > "$lock_file" 2>/dev/null || true
                    (
                        trap '/bin/rm -f "$lock_file" "$cache_file.tmp"' EXIT
                        scan_dirs_once "$path" > "$cache_file.tmp" && [ -s "$cache_file.tmp" ] && /bin/mv "$cache_file.tmp" "$cache_file"
                    ) >/dev/null 2>&1 &
                    refresh_started=1
                fi
            fi
        fi

        if [ ! -s "$tmp" ]; then
            # no cache available (or --fresh): run a live scan
            scan_dirs_once "$path" > "$tmp"

            # fallback for macOS protected/system paths where depth scan can be sparse
            if [ ! -s "$tmp" ]; then
                /usr/bin/find "$path" -maxdepth 1 -mindepth 1 -type d -print0 2>/dev/null | \
                    /usr/bin/xargs -0 /usr/bin/du -skx 2>/dev/null | /usr/bin/sort -nr > "$tmp"
            fi

            if [ "$use_cache" -eq 1 ] && [ -s "$tmp" ]; then
                /bin/cp "$tmp" "$cache_file" 2>/dev/null || true
                cache_age=0
            fi
        fi

        if [ ! -s "$tmp" ]; then
            echo "No subdirectories found under: $path"
            break
        fi

        if [ "$use_cache" -eq 1 ] && [ "$used_cached" -eq 1 ] && [ -n "$cache_age" ] && [ "$cache_age" -gt 0 ]; then
            if [ "$cache_age" -gt "$ttl" ]; then
                if [ "$refresh_started" -eq 1 ]; then
                    echo "(using cached scan: ${cache_age}s old; refreshing in background, ttl=${ttl}s; use --fresh for live scan)"
                else
                    echo "(using cached scan: ${cache_age}s old, ttl=${ttl}s; use --fresh for live scan)"
                fi
            else
                echo "(using cached scan: ${cache_age}s old, ttl=${ttl}s; use --fresh for live scan)"
            fi
        fi

        # print top 10 with numbers and human sizes
        i=1
        while IFS=$'\t' read -r size dir; do
            human=$(human_kb "$size")
            printf "%2d) %8s  %s\n" "$i" "$human" "$dir"
            i=$((i+1))
            if [ $i -gt 10 ]; then break; fi
        done < <(/usr/bin/head -n 10 "$tmp")

        echo "------------------------------------------------------------"
        printf "Enter number to drill into, '..' to go up, or 'q' to quit: "
        read -r choice

        case "$choice" in
            q|Q)
                break
                ;;
            ..)
                parent="$(cd "$path/.." 2>/dev/null && pwd || printf "%s" "$path")"
                if [ "$parent" = "$path" ] || [ "$path" = "/" ]; then
                    echo "Already at top level: $path"
                else
                    path="$parent"
                fi
                continue
                ;;
            '')
                continue
                ;;
            *)
                if ! printf "%s" "$choice" | /usr/bin/grep -Eq '^[0-9]+$'; then
                    echo "Invalid choice"
                    continue
                fi

                if [ "$choice" -lt 1 ] || [ "$choice" -ge $i ]; then
                    echo "Choice out of range"
                    continue
                fi

                selected_line="$(/usr/bin/sed -n "${choice}p" "$tmp")"
                selected_size=$(printf "%s" "$selected_line" | /usr/bin/awk '{print $1}')
                selected_dir=$(printf "%s" "$selected_line" | /usr/bin/cut -f2- -d$'\t')

                # normalize to absolute path
                if [ "${selected_dir#/}" = "$selected_dir" ]; then
                    selected_dir="$(cd "$path" 2>/dev/null && cd "$selected_dir" 2>/dev/null && pwd || printf "%s" "$selected_dir")"
                fi

                path="$selected_dir"
                ;;
        esac
    done

    /bin/rm -f "$tmp" 2>/dev/null || true
}