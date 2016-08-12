
.PHONY: all build clean release

VERSION=latest

default: fluentd.zip

fluentd.zip: index.js main
	zip -r fluentd.zip main index.js

main: *.go
	GOOS=linux go build -o main

release: fluentd.zip
	aws s3 cp fluentd.zip s3://reverb-deploy/fluentd.zip  --acl public-read
	aws lambda update-function-code --function-name reverb-staging-fluentd-staging --s3-bucket reverb-deploy --s3-key fluentd.zip --publish
