#!/bin/bash

find opt/myapp -print | while read filename
do
  stat -c "%%attr (%a,%U,%G) /%n" "$filename"
done
