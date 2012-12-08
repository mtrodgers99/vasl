SHELL:=/bin/bash

SRCDIR:=src
LIBDIR:=lib
CLASSDIR:=classes
TMPDIR:=tmp
JDOCDIR:=javadoc
DOCDIR:=doc
DISTDIR:=dist

VNUM:=5.9.0
VERSION:=5.9-beta3

CLASSPATH:=$(CLASSDIR):$(shell echo $(LIBDIR)/*.jar | tr ' ' ':'):$(shell echo $(LIBDIRND)/*.jar | tr ' ' ':')
JAVAPATH:=/usr/bin

JC:=$(JAVAPATH)/javac
JCFLAGS:=-d $(CLASSDIR) -source 5 -target 5 -Xlint -classpath $(CLASSPATH) -sourcepath $(SRCDIR)

JAR:=$(JAVAPATH)/jar
JDOC:=$(JAVAPATH)/javadoc

vpath %.class $(shell find $(CLASSDIR) -type d)
vpath %.java  $(shell find $(SRCDIR) -type d -name .svn -prune -o -print)
vpath %.jar $(LIBDIR)

all: $(CLASSDIR) fast-compile module

$(CLASSDIR):
	mkdir -p $(CLASSDIR)

%.class: %.java
	$(JC) $(JCFLAGS) $<

module: $(CLASSES) $(TMPDIR)/VASL.mod

$(TMPDIR)/VASL.mod: dist/VASL.mod $(TMPDIR)
	cp dist/VASL.mod $(TMPDIR)
	cd classes && zip -0 ../$(TMPDIR)/VASL.mod -r VASL
	cd dist/moduleData && zip -0 ../../$(TMPDIR)/VASL.mod -r * -x \*.svn/\* 
	cd $(TMPDIR) && unzip -p VASL.mod buildFile | sed -e 's/\(<VASSAL.launch.BasicModule.*version="\)[^"]*\(".*\)/\1$(VERSION)\2/g' > buildFile && zip -m -0 VASL.mod buildFile

fast-compile:
	$(JC) $(JCFLAGS) $(shell find $(SRCDIR) -name '*.java')

$(TMPDIR):
	mkdir -p $(TMPDIR)

clean-release:
	$(RM) -r $(TMPDIR) 

clean: clean-release
	$(RM) -r $(CLASSDIR)

.PHONY: all fast-compile clean release release-macosx release-windows release-generic clean-release i18n images help javadoc clean-javadoc version
