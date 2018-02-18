# A simple makefile to make things simpler

.PHONY: deploy test
name=mylambda_boilerplate
fullname=${name}_handler

ZIPFILE=$(shell pwd)/target/$(fullname).zip

help:
	@echo "AWS Lambda. Python Boilerplate";
	@echo "";
	@echo "help           - This text.";
	@echo "todo           - Will print all the TODO's in the code.";
	@echo "bump           - Bump the version file, commit and tag";
	@echo "deploy      - put this in AWS"
	@echo "virtualev   - prepare the env"
	@echo "clean       - clean the env"
	@echo "test        - run nose test"
	@echo "";


todo:
	grep  -r "TODO:" * --exclude-dir ENV --exclude Makefile

bump:
	#TODO: after bumping the version number, it should git commit and git tag
	python -c '\
		  fh=open(".release");\
			c=fh.readline();\
			n=map(lambda x: int(x),c.split("."));\
			print ".".join(map(str, [n[0],n[1],n[2]+1]));'
	mv new_release .release 
	git add .release
	git commit -m "Bumping to version $(shell cat .release)"
	git tag $(shell cat .release)

target/$(fullname).zip: virtualenv src/$(fullname).py
	rm -rf target && mkdir -p target
	find src -type d | xargs  chmod ugo+rx 
	find src -type f | xargs  chmod ugo+r 
	cd src && zip -9r $(ZIPFILE) *
	cd $(shell find virtualenv -name site-packages -type d) && zip -9r $(ZIPFILE) *

virtualenv: requirements.txt
	umask 0002 && \
	virtualenv virtualenv  && \
	. ./virtualenv/bin/activate && \
	pip install -r requirements.txt
	
deploy: target/$(fullname).zip
	./deploy -p quby 

clean:
	rm -rf virtualenv target

test:
	cd src ; nosetests ../test/*.py
	python-lambda-local -f handler  src/$(fullname).py  test/fixtures/event.json
	export LAMBDA_VARS="{SLACK_BOT_TOKEN=false-no-post}"
	python-lambda-local -f handler  src/$(fullname).py  test/fixtures/no_invocation.json

