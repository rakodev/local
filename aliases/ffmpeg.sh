#!/bin/sh

# convert2_mp4 some_video.avi  # This will create some_video.mp4
alias convert2_mp4="function _convert2mp4() {
    if [[ \${1: -3} != 'mp4' ]]; then
        ffmpeg -i \$1 \${1%.*}.mp4;
    else
        echo 'The file is already in mp4 format.';
    fi
}; _convert2mp4"
