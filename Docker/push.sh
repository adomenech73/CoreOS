#!/bin/bash

path=$(pwd)
for dir in `ls ./`;
do
  cd $path/$dir
  docker push adomenech73/$dir .
done

exit 0