#!/bin/sh


# Parameters:
# $1 - source URL.
# $2 - base revision from where changes considered, lower border
# $3 - target revision, upper border
# $4 - root of target directory to where files will be exported
#

if [ $# -eq 0 ]; then
    echo "svn_export.sh: No parameters provided! Parameters needed: SRC_URL lowRevision highRevision targetRootDirectory"
    exit 1
fi


# For each entry take url.
for file in `svn diff -r $2:$3 --summarize $1 | grep '^[ADMR]' | cut -b 8-`
do
        echo "$file"
        dir=`echo "$file" | cut -s -f 7- -d / | rev | cut -d / -f 2- | rev`
        file_name=`echo "$file" | cut -s -f 7- -d / | rev | cut -d / -f 1 | rev`
        target_dir="$4/$dir"
        echo "export to"
        #check if directory exists, if not create.
        if [ -d "$target_dir" ]
            then
                 svn export -r $3 $file $target_dir/$file_name --force
            else
                mkdir -p "$target_dir"
                svn export -r $3 $file $target_dir/$file_name --force
        fi


done
