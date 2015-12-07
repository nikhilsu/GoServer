#!/bin/bash
cp /var/lib/go-agent/pipelines/danglay/zips/danglay.zip /tmp/
cd /tmp
unzip danglay.zip -d folder 1>/dev/null
cd folder/danglay
rm -rf /var/lib/go-agent/pipelines/danglay-staging/*
files=`ls -A`
for file in $files; do
	mv  $file  /var/lib/go-agent/pipelines/danglay-staging/  2>/dev/null
done
rm -rf /tmp/danglay.zip /tmp/folder
cd /var/lib/go-agent/pipelines/danglay-staging/

bundle update
git push staging master
heroku run bundle exec rake db:migrate -r staging
heroku logs -r staging > staging.log
cp staging.log ../danglay/
