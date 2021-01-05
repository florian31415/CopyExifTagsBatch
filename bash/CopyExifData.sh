#!/bin/bash
#use exif tool to copy all exif tags from mpo files to jpg files with the same name

VAR1=$(dpkg -s libimage-exiftool-perl | grep Status)
VAR2="Status: install ok installed"

if [ "$VAR1" = "$VAR2" ]; then
    jpgFilePrefix=$1 # jpg File prefix

    mpoFilesInDirectory=($(find -type f -name "*.MPO"))
    jpgFilesInDirectory=($(find -type f -name $jpgFilePrefix"*.jpg"))

    OIFS=$IFS

    for mpoIndex in ${!mpoFilesInDirectory[*]}; 
    do
        mpoFile="${mpoFilesInDirectory[mpoIndex]}"
        IFS='.' # hyphen (.) is set as delimiter
        read -ra ADDR <<< "$mpoFile" 
        IFS=$OIFS
        fileName=${ADDR[1]:1}
        
        for jpgIndex in ${!jpgFilesInDirectory[*]};
        do
            jpgFile="${jpgFilesInDirectory[jpgIndex]}"
            if [[ $jpgFile == *$fileName* ]]; then
                exiftool -TagsFromFile $mpoFile --Orientation $jpgFile
            fi
        done
    done

    IFS=$OIFS
else
    echo "You need to install the libimage-exiftool-perl package"
fi
