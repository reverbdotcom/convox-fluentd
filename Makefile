
.PHONY: all build clean release

VERSION=latest

default: fluentd.zip

fluentd.zip: index.js main
	zip -r fluentd.zip main index.js

main: *.go
	GOOS=linux go build -o main

release: fluentd.zip
	aws --profile=infra-admin --region=us-east-1 s3 cp fluentd.zip s3://reverb-deploy/fluentd.zip  --acl public-read
	aws --profile=infra-admin --region=us-east-1 lambda update-function-code --function-name convox-production-fluentd --s3-bucket reverb-deploy --s3-key fluentd.zip --publish
	aws --profile=infra-admin --region=us-east-1 lambda update-function-code --function-name reverb-staging-fluentd-1024 --s3-bucket reverb-deploy --s3-key fluentd.zip --publish
