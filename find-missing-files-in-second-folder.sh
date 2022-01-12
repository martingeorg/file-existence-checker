#!/bin/bash

echo -e "*** File existence checker ***\n"

folder1="$1"
folder2="$2"


# Some sanity checks

if ! [ -r ./find-missing-files-in-second-folder.sh ]; then
    echo "Please run the script from within the script folder."
    echo -e "This will prevent unexpected behavior.\n"
    exit
fi

if [ -z $folder1 ] || [ -z $folder2 ] || ! [ -r $folder1 ] || ! [ -r $folder2 ]; then
    echo -e "Please provide two different, existing and readable folders for comparison!\n"
    exit
fi

if [ $folder1 == $folder2 ]; then
    echo -e "WAKE UP! You've given the same folder twice!\n"
    exit
fi


# Compare files

echo -n "Found "; find $folder1 -type f | wc -l | tr -d '\n'; echo " files in '$folder1'"
echo -n "Found "; find $folder2 -type f | wc -l | tr -d '\n'; echo " files in '$folder2'"
echo -ne "\nComparing contents of '$folder1' with '$folder2', this may take a while..."

# find $folder1 -type f -exec md5sum {} \; > folder1-hashes 2> errors-folder1
# find $folder2 -type f -exec md5sum {} \; > folder2-hashes 2> errors-folder2
find $folder1 -type f -exec sha1sum {} \; > folder1-hashes 2> errors-folder1
find $folder2 -type f -exec sha1sum {} \; > folder2-hashes 2> errors-folder2

awk '{ print $1 }' ./folder1-hashes > folder1-hashes-only
awk '{ print $1 }' ./folder2-hashes > folder2-hashes-only

grep -F -x -v -f folder2-hashes-only folder1-hashes-only > folder2-missing-files-hashes-only
echo -e " done.\n"

echo "List of missing files in \"$folder2\"";
grep -F -f ./folder2-missing-files-hashes-only ./folder1-hashes \
    | awk '{for (i=2; i<=NF; i++) {printf("%s", ((i>2) ? OFS : "") $i)}; print ""}'\
    | sort > ./missing-files-list.txt
echo
cat ./missing-files-list.txt

echo -ne "\nFound "; wc -l < ./folder2-missing-files-hashes-only | tr -d '\n';\
    echo -e " files which are missing in $folder2, see list above or the 'missing-files-list.txt' file\n"


# Cleanup

rm folder1-hashes
rm folder2-hashes
rm folder1-hashes-only
rm folder2-hashes-only
rm folder2-missing-files-hashes-only
