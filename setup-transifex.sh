#/bin/sh

counter=0

find . -name '*.strings.json' |
while read f; do
    extension=".strings.json"

    filename=$(basename "$f")
    dirname=$(dirname "$f")

    directoryWithoutLanguage="${dirname%/*}"

#echo $directoryWithoutLanguage

    resource="${directoryWithoutLanguage##*/}"

    file="${filename/$extension/}"
    file="${file//[[:space:]]/}"
    file="${file//~i/i}"

    absolute="$( cd "$( dirname "${f}" )" && pwd )"

#echo 'Transifex Setting Resource:' $resource"."$file;
#echo "$directoryWithoutLanguage/<lang>.lproj/$filename"

#tx set --auto-local -r 'Apple-iOS'.$resource-$file '<lang>.lproj' --source-lang en --source-file "$absolute/$filename" --execute -t KEYVALUEJSON
tx set --source -r 'apple-ios'.$resource-$file -l en "$absolute/$filename" -t KEYVALUEJSON

counter=$(($counter+1));
echo "Done: $counter files"

#plutil -convert json -o "$f.json" "$f";
done