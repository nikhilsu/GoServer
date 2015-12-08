#!/bin/bash
cp /var/lib/go-agent/pipelines/danglay/zips/danglay.zip /tmp/
echo "Unziping Files................."
unzip /tmp/danglay.zip -d /tmp/folder 1>/dev/null
rm -rf /var/lib/go-agent/pipelines/danglay-staging
cp -R /tmp/folder/danglay /var/lib/go-agent/pipelines/danglay-staging
rm -rf /tmp/danglay.zip /tmp/folder
cd /var/lib/go-agent/pipelines/danglay-staging/
echo "Running Bundle Update..........."
bundle update
echo "Running git push now............."
git remote add staging	git@heroku.com:staging-danglay.git
git push staging master
heroku run bundle exec rake db:migrate -r staging
heroku logs -r staging > staging.log
cp staging.log ../danglay/
