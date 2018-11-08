#!/bin/sh
while [ "$1" != "" ]; do
    f=$1
    ./xrefRuby.rb $f >xref-$f.txt
    echo "xref-$f.txt made"
    shift
done
      
