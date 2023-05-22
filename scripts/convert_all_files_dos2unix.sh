#!/bin/bash

book_dir=/home/scott/ShellScriptingBook/Book_Download

for dir in $book_dir/Chapter*
do
    if [ -d $dir ] && [ ! -z $dir ]
    then
	dos2unix $dir/*.sh
    fi
done

