#!/bin/sh

ffmpeg_check() {
    if ! command -v ffmpeg >/dev/null 2>&1; then
        echo 'ffmpeg is not installed. Please install it first.';
        echo ""
        echo 'brew install ffmpeg';
        echo ""
        return 1;
    fi
    return 0;
}


# convert2_mp4 some_video.avi  # This will create some_video.mp4
alias convert2mp4="function _convert2mp4() {
    ffmpeg_check || return 1;

    if [[ \${1: -3} != 'mp4' ]]; then
        ffmpeg -i \$1 \${1%.*}.mp4;
    else
        echo 'The file is already in mp4 format.';
    fi
}; _convert2mp4"
