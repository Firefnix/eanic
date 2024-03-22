#!/bin/bash

if [ -n "$1" ]; then
  base="$1" # should be 2.4
else
  base='base.mp3'
fi

for i in 1.0 1.1 2.3 2.4; do
  rm "$i.mp3" || :
  cp "$base" "$i.mp3"
done

eyeD3 '2.3.mp3' --to-v2.3
eyeD3 '1.1.mp3' --to-v1.1
eyeD3 '1.0.mp3' --to-v1.1

for i in 1.0 1.1 2.3 2.4; do
  eyeD3 "$i.mp3" -t 'Test title' -a 'Test artist' -A 'Test album'
done

for i in 1.1 2.3 2.4; do
  eyeD3 "$i.mp3" -n 3
done

for i in 2.3 2.4; do
  eyeD3 --add-image "artwork.png:FRONT_COVER:Description" "$i.mp3"
done
