#!/bin/bash

pids=`ps aux |fgrep "rails server -b 0.0.0.0"|sed 's/  */,/g'|awk -F "," '{print $2}'`
for pid in $pids; do
	kill $pid
done
cp /var/lib/go-agent/pipelines/zips/danglay.zip /tmp/
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
rails server -b 0.0.0.0 &
