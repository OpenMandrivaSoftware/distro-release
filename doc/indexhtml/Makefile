PACKAGE = indexhtml
VERSION = 2015.0
DATE = `date +%Y%m%d`

all:

clean:
	-find . -name '*~' | xargs rm -f
	rm -f *.bz2

install:
	mkdir -p $(RPM_BUILD_ROOT)/usr/share/doc/HTML
	cp -rp HTML/* $(RPM_BUILD_ROOT)/usr/share/doc/HTML/

version:
	@echo $(VERSION)

# rules to build a test rpm

cleandist:
	rm -rf $(PACKAGE)-$(VERSION) $(PACKAGE)-$(VERSION).tar.xz

localcopy:
	git archive --prefix=$(PACKAGE)-$(VERSION)/ HEAD | xz -c -T0 > $(PACKAGE)-$(VERSION).tar.xz

# rules to build a distributable rpm

dist: cleandist localcopy

log: ChangeLog

#svn2cl is available in our contrib.
ChangeLog:
	@if test -d "$$PWD/.git"; then \
	git --no-pager log --format="%ai %aN %n%n%x09* %s%d%n" > $@.tmp \
	&& mv -f $@.tmp $@ \
	&& git commit ChangeLog -m 'generated changelog' \
	&& if [ -e ".git/svn" ]; then \
	git svn dcommit ; \
	fi \
	|| (rm -f  $@.tmp; \
	echo Failed to generate ChangeLog, your ChangeLog may be outdated >&2; \
	(test -f $@ || echo git-log is required to generate this file >> $@)); \
	else \
	svn2cl --accum --authors ../common/username.xml; \
	rm -f *.bak;  \
	fi;

# Makefile ends here
