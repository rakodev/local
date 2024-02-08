#!/bin/sh

images-convert-hiec-to-jpg () {
    for i in *.heic *.HEIC; do 
        if [[ "$i" == *.heic ]]; then
            sips -s format jpeg "$i" --out "${i%.heic}.jpg"
        else
            sips -s format jpeg "$i" --out "${i%.HEIC}.jpg"
        fi
    done
}