.PHONY: check include
.DEFAULT_GOAL := all

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; cyan = "\033[36m"; white = "\033[0m"; printf "\nUsage:\n  make %s<target>%s\n\nTargets:\n", cyan, white} /^[a-zA-Z_-]+:.*?##/ {printf "  %s%-10s%s %s\n", cyan, $$1, white, $$2}' $(MAKEFILE_LIST)

include:  ## Include the framework in ./include
	[ ! -d include ] && git clone git@github.aus.thenational.com:MLC-DevOps/framework.git include ; true

pull:  ## Pull in updates in ./include
	[ -d include ] && cd include && git pull origin master && cd .. ; true

# shellcheck tests
#
scripts := $(shell find data* -type f)

#check:  ## Run the shellcheck tests
#	for i in $(scripts) ; do \
#		shellcheck --exclude=SC2034,SC2140,SC2154 $$i ; \
#		done
check:  ## Run the shellcheck tests
	for i in $(scripts) ; do \
                shellcheck --exclude=SC1090,SC1091,SC2034,SC2046,SC2140,SC2154,SC2196 $$i ; \
                done

# unit tests
#
asset := $(shell git remote -v | awk 'NR==1{print tolower(gensub(/.*:(.*)\/.*/, "\\1", "g", $$2))}')

tests = include/shunit2/_shared/repo_structure.sh \
				include/shunit2/_shared/whitespace.sh \
				include/shunit2/_shared/sorting.sh \
				include/shunit2/_shared/jenkinsfiles.sh \
				include/shunit2/_shared/validate_templates.sh \
				include/shunit2/_shared/usage.sh \
				include/shunit2/_shared/misc.sh \
				include/shunit2/_shared/usage.sh \
                                include/shunit2/_shared/bake.sh \
                                include/shunit2/_shared/deploy_stack.sh
				#include/shunit2/_shared/tdm/scripts/cleanup.sh \
				#include/shunit2/_shared/tdm/scripts/create_tdm_user_ec2.sh \
				#include/shunit2/_shared/tdm/scripts/generatemapping.sh \
				#include/shunit2/_shared/tdm/scripts/mask_phase1.sh \
				#include/shunit2/_shared/tdm/scripts/mask_phase2.sh \
				#include/shunit2/_shared/tdm/scripts/mask_phase3.sh \
				#include/shunit2/_shared/tdm/scripts/mask_phase4.sh \
				#include/shunit2/_shared/tdm/scripts/re-encrypt.sh \
				#include/shunit2/_shared/tdm/scripts/run_packer.sh \
				#include/shunit2/_shared/tdm/scripts/tdmdeploy.sh \
				#include/shunit2/_shared/tdm/scripts/create_tdm_user_rds.sh \
				#include/shunit2/_shared/bake.sh \
				#include/shunit2/_shared/deploy_stack.sh

unit:  ## Run the shunit2 tests
	for i in $(tests) ; do \
		printf "\n%s:\n" $$i ; \
		bootstrap=$(asset)-jenkins-bootstrap bash $$i || exit ; \
		done

all: check unit  ## Run all the tests
