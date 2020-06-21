NAME := seabios
SPECFILE := seabios.spec

WORKDIR := $(shell pwd)
SPECDIR ?= $(WORKDIR)
SRCRPMDIR ?= $(WORKDIR)/srpm
BUILDDIR ?= $(WORKDIR)
RPMDIR ?= $(WORKDIR)/rpm
SOURCEDIR := $(WORKDIR)

RPM_DEFINES := --define "_sourcedir $(SOURCEDIR)" \
        --define "_specdir $(SPECDIR)" \
        --define "_builddir $(BUILDDIR)" \
        --define "_srcrpmdir $(SRCRPMDIR)" \
        --define "_rpmdir $(RPMDIR)"

URL := $(shell spectool $(RPM_DEFINES) --list-files --source 0 $(SPECFILE) 2> /dev/null| cut -d ' ' -f 2- )

ifndef SRC_FILE
ifdef URL
SRC_FILE := $(notdir $(URL))
endif
endif

DISTFILES_MIRROR ?= https://ftp.qubes-os.org/distfiles/
UNTRUSTED_SUFF := .UNTRUSTED
FETCH_CMD := wget --no-use-server-timestamps -q -O

SHELL := /bin/bash

%: %.sha512
	@$(FETCH_CMD) $@$(UNTRUSTED_SUFF) $(URL)
	@sha512sum --status -c <(printf "$$(cat $<)  -\n") <$@$(UNTRUSTED_SUFF) || \
		{ echo "Wrong SHA512 checksum on $@$(UNTRUSTED_SUFF)!"; exit 1; }
	@mv $@$(UNTRUSTED_SUFF) $@

.PHONY: get-sources
get-sources: $(SRC_FILE)

.PHONY: verify-sources
verify-sources:
	@true
