picture-transform-heic-to-png-Fromfolder-Tofolder() {
    sips -s format png --setProperty formatOptions 9 --resampleHeightWidthMax 1920  $1/*.{heic,HEIC} --out $2
}