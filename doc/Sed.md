# Sed

## Replace a string with another one in a folder and subfolders

find . -type f -name "*.tf" -exec sed -i '' '/^[[:space:]]*#/! s@goede_doelen_loterijen/modules@plg-tech/gdl/infra/modules@g' "{}" +

replace_in_files() {
    search="$1"
    replacement="$2"
    file_extension="${3:-*}"
    replace_commented_lines="${4:-false}"

    if [ "$replace_commented_lines" = true ]; then
        find . -type f -name "*.$file_extension" -exec sed -i '' 's@'"$search"'@'"$replacement"'@g' "{}" +
    else
        find . -type f -name "*.$file_extension" -exec sed -i '' '/^[[:space:]]*#/! s@'"$search"'@'"$replacement"'@g' "{}" +
    fi
}

### Replace in any files, including commented lines

replace_in_files "goede_doelen_loterijen/modules" "plg-tech/gdl/infra/modules" "*" true

### Replace in .tf files, including commented lines

replace_in_files "goede_doelen_loterijen/modules" "plg-tech/gdl/infra/modules" "tf" true

### Replace in .tf files, excluding commented lines

replace_in_files "goede_doelen_loterijen/modules" "plg-tech/gdl/infra/modules" "tf" false
