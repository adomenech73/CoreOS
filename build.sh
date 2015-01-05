#!/bin/bash

cd Docker/base
docker build -t adomenech73/base .
docker push adomenech73/base .

cd ../basejava
docker build -t adomenech73/basejava .
docker push adomenech73/basejava .

cd ../diamond
docker build -t adomenech73/diamond .
docker push adomenech73/diamond .

cd ../elasticsearch
docker build -t adomenech73/elasticsearch .
docker push adomenech73/elasticsearch .

cd ../grafana
docker build -t adomenech73/grafana .
docker push adomenech73/grafana .

cd ../graphite
docker build -t adomenech73/graphite .
docker push adomenech73/graphite .

cd ../mysql
docker build -t adomenech73/mysql .
docker push adomenech73/mysql .

cd ../wordpress
docker build -t adomenech73/wordpress .
docker push adomenech73/wordpress .
cd ../..

exit 0
