SHELL := /bin/bash
DEPLOYED := .mk-deploy
FUNCTION := main

.PHONY: spec aws-spec

spec: vendor
	source ./.env && sls invoke local --function $(FUNCTION)

aws-spec: $(DEPLOYED)
	source ./.env && sls invoke --function $(FUNCTION)

$(DEPLOYED): vendor
	source ./.env && sls deploy --verbose
	touch $(DEPLOYED)

vendor:
	mkdir -p vendor
	pip install requests -t `pwd`/vendor

clean:
	$(RM) $(DEPLOYED)

