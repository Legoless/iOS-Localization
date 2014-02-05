#/bin/sh

counter=0

find $1 -name '*.strings.json' |
while read f; do
    extension=".strings.json"

    filename=$(basename "$f")
    dirname=$(dirname "$f")

    directoryWithoutLanguage="${dirname%/*}"

    directory=${directoryWithoutLanguage#*/}
    directory=${directory#*/}

    separator="/"

    resourceArray=(${directory//./ })
    resource=$resourceArray
    resource=${resource//$separator/--}

    resource=${resource//./__}

#echo $directoryWithoutLanguage

#resource="${directoryWithoutLanguage##*/}"

#resourceArray=(${resource//./ })
#resource=$resourceArray

#resource="${resource/.app/}"
#resource="${resource/.axbundle/}"
#resource="${resource/.bundle/}"
#resource="${resource/.plugin/}"

    file="${filename/$extension/}"
#file="${filename//.app/}"
    file="${file//[[:space:]]/}"
#file="${file//~i/i}"
    separator="~"
    file="${file//$separator/---}"
    file="${file//./__}"
    file="${file//&/__AND__}"

    absolute="$( cd "$( dirname "${f}" )" && pwd )"

#echo 'Transifex Setting Resource:' $resource"."$file;
#echo "$directoryWithoutLanguage/<lang>.lproj/$filename"

#tx set --auto-local -r 'Apple-iOS'.$resource-$file '<lang>.lproj' --source-lang en --source-file "$absolute/$filename" --execute -t KEYVALUEJSON
tx set --source -r 'apple-ios'.$resource'-'$file -l en "$absolute/$filename" -t KEYVALUEJSON >> source.log

counter=$(($counter+1));
echo 'Resource: "'$resource"-"$file'" - Count: '$counter
#echo "Done: $counter files"

#plutil -convert json -o "$f.json" "$f";
done