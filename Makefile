SHELL=/bin/bash

.SHELLFLAGS = -o pipefail -c

SRCS=$(shell find src/ -name '*.cr')

######################################################################
### examples

.PHONY: examples
examples:
	@mkdir -p tmp
	@for cr in examples/*.cr; do \
	  crystal build $$cr -o tmp/`basename $$cr .cr`; \
	done

tmp/%: examples/%.cr $(SRCS)
	@mkdir -p tmp
	crystal build "$<" -o "$@"

######################################################################
### testing

.PHONY: ci
ci: check_version_mismatch examples spec

.PHONY : spec
spec:
	crystal spec -v --fail-fast

.PHONY : check_version_mismatch
check_version_mismatch: shard.yml README.md
	diff -w -c <(grep version: README.md) <(grep ^version: shard.yml)

######################################################################
### versioning

VERSION=
CURRENT_VERSION=$(shell git tag -l | sort -V | tail -1 | sed -e 's/^v//')
GUESSED_VERSION=$(shell git tag -l | sort -V | tail -1 | awk 'BEGIN { FS="." } { $$3++; } { printf "%d.%d.%d", $$1, $$2, $$3 }')

.PHONY : version
version:
	@if [ "$(VERSION)" = "" ]; then \
	  echo "ERROR: specify VERSION as bellow. (current: $(CURRENT_VERSION))";\
	  echo "  make version VERSION=$(GUESSED_VERSION)";\
	else \
	  sed -i -e 's/^version: .*/version: $(VERSION)/' shard.yml ;\
	  sed -i -e 's/^    version: [0-9]\+\.[0-9]\+\.[0-9]\+/    version: $(VERSION)/' README.md ;\
	  echo git commit -a -m "'$(COMMIT_MESSAGE)'" ;\
	  git commit -a -m 'version: $(VERSION)' ;\
	  git tag "v$(VERSION)" ;\
	fi

.PHONY : bump
bump:
	make version VERSION=$(GUESSED_VERSION) -s
