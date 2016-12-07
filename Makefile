R=R
# -> you can do    R=R-devel  make ....

PACKAGE=coastMDT
VERSION := $(shell sed -n '/^Version: /s///p' coastMDT/DESCRIPTION)

TARBALL := $(PACKAGE)_$(VERSION).tar.gz
ZIPFILE := =$(PACKAGE)_$(VERSION).zip

#CPP_SRC := $(PACKAGE)/src/*.cpp

#SUBDIRS := $(wildcard tests/*/.)

#.PHONY: test all $(SUBDIRS)
.PHONY: all 

all:
	make doc-update
	make build-package
	make install
	make pdf

doc-update: $(PACKAGE)/R/*.R
	echo "library(roxygen2);roxygenize(\"$(PACKAGE)\",roclets = c(\"collate\", \"rd\"))" | $(R) --slave
	@touch doc-update

vignette-update: $(PACKAGE)/vignettes/*.Rnw
	cd $(PACKAGE)/vignettes; echo "library(knitr);knit2pdf('coastMDT.Rnw')" | $(R) --slave
	 mv $(PACKAGE)/vignettes/coastMDT.pdf $(PACKAGE)/doc/coastMDT_tutorial.pdf
	@touch vignette-update

namespace-update :: $(PACKAGE)/NAMESPACE
$(PACKAGE)/NAMESPACE: $(PACKAGE)/R/*.R
	echo "library(roxygen2);roxygenize(\"$(PACKAGE)\",roclets = c(\"namespace\"))" | $(R) --slave

build-package: $(TARBALL)
$(TARBALL): $(PACKAGE)/NAMESPACE $(PACKAGE)/R/*.R
	$(R) CMD build --resave-data=no $(PACKAGE)

install: $(TARBALL)
	$(R) CMD INSTALL --preclean $<
	@touch $@

quick-install: $(PACKAGE)/src/coastMDT.so
	$(R) CMD INSTALL $(PACKAGE)

unexport TEXINPUTS
pdf: $(PACKAGE).pdf
$(PACKAGE).pdf: $(PACKAGE)/man/*.Rd
	rm -f $(PACKAGE).pdf
	$(R) CMD Rd2pdf --no-preview $(PACKAGE)

build:
	$(R) CMD build $(PACKAGE)

check: $(TARBALL)
	$(R) CMD check $(TARBALL)

check-cran: $(TARBALL)
	$(R) CMD check --as-cran $(TARBALL)

quick-check: quick-install ex-test

ex-test:
	echo "library(coastMDT); example(myfun)" | $(R) --slave

clean:
	\rm -f install doc-update $(TARBALL) $(PACKAGE).pdf

