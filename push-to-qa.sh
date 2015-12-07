#!/bin/bash

pids=` lsof -f -i|grep 3000|sed 's/  */,/g'|awk -F "," '{print $2}'`
for pid in $pids; do
	kill $pid 2>/dev/null
done
pids=`ps aux |fgrep "bundle exec rails server -e qa -b 0.0.0.0"`
echo "Hello Pids - $pids"
cp /var/lib/go-agent/pipelines/danglay/zips/danglay.zip /tmp/
cd /tmp
unzip danglay.zip -d folder
cd folder/danglay
rm -rf /var/lib/go-agent/pipelines/danglay-qa/*
files=`ls -A`
for file in $files; do
	mv $file /var/lib/go-agent/pipelines/danglay-qa/ 2>/dev/null
done
rm -rf /tmp/danglay.zip /tmp/folder
cd /var/lib/go-agent/pipelines/danglay-qa/
bundle update
bundle exec rake db:migrate RAILS_ENV=qa
bundle exec rails server -e qa -b 0.0.0.0 -d
