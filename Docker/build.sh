#!/bin/bash

for dir in `ls -d */`;
do
  cd ./$dir
  docker build -t adomenech73/${dir%%/} .
  cd ../
done

exit 0
