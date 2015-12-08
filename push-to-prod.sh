#!/bin/bash
cp /var/lib/go-agent/pipelines/danglay/zips/danglay.zip /tmp/
echo "Unziping Files..............."
unzip /tmp/danglay.zip -d /tmp/folder 1>/dev/null
rm -rf /var/lib/go-agent/pipelines/danglay-prod
cp -R /tmp/folder/danglay /var/lib/go-agent/pipelines/danglay-prod
rm -rf /tmp/danglay.zip /tmp/folder
cd /var/lib/go-agent/pipelines/danglay-prod/
echo "Runnig Bundle Update..........."
bundle update
echo "Running git push now..........."
git remote add prod  git@heroku.com:danglay.git
git push prod master
heroku run bundle exec rake db:migrate -r prod
heroku logs -r prod > prod.log
cp prod.log ../danglay/
