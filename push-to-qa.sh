#!/bin/bash
pids=`lsof -f -i|grep 3000|sed 's/  */,/g'|awk -F "," '{print $2}'`
for pid in $pids; do
	kill -15 $pid 2>/dev/null
done
pids=`ps aux |fgrep "bundle exec rails server -e qa -b 0.0.0.0"`
echo "Hello Pids - $pids"

cp /var/lib/go-agent/pipelines/danglay/zips/danglay.zip /tmp/
echo "Unziping Files........."
unzip /tmp/danglay.zip -d /tmp/folder 1>/dev/null
rm -rf /var/lib/go-agent/pipelines/danglay-qa
cp -R /tmp/folder/danglay /var/lib/go-agent/pipelines/danglay-qa
rm -rf /tmp/danglay.zip /tmp/folder
cd /var/lib/go-agent/pipelines/danglay-qa/
echo "Running Bundle Update"
bundle update
bundle exec rake db:migrate RAILS_ENV=qa
echo "Running Server on port 3000........."
bundle exec rails server -e qa -b 0.0.0.0 -d
