# !/bin/bash

# Alias to check disk space usage of the root directory in a human-readable format
alias ds_disk_space='df -h /'

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
    local path="${1:-.}"
    local tmp i size dir human selected_line selected_size selected_dir parent choice

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
    trap 'rm -f "$tmp"' RETURN

    while true; do
        echo
        echo "Top 10 directories by size in: $path"
        echo "------------------------------------------------------------"

        # collect sizes for immediate subdirectories (handles spaces)
        /usr/bin/find "$path" -maxdepth 1 -mindepth 1 -type d -print0 2>/dev/null | \
            /usr/bin/xargs -0 /usr/bin/du -sk 2>/dev/null | /usr/bin/sort -nr > "$tmp"

        if [ ! -s "$tmp" ]; then
            echo "No subdirectories found under: $path"
            break
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
}