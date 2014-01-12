#/bin/sh

find . -name '*.strings' |
while read f; do
    echo 'Converting:' $f;

    plutil -convert json -o "$f.json" "$f";
    plutil -convert xml1 -o "$f.xml" "$f";
done