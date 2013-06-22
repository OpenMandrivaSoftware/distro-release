.PHONY: release-notes.txt release-notes.html
VERSION=2012
RN_URL=http://wiki.mandriva.com/en/$(VERSION)_Notes

check:
	iconv -t utf-32 -f utf-8 <CREDITS>/dev/null

release-notes.txt:
	LANG=C lynx --dump -nolist $(RN_URL) > release-notes.txt
	perl -pi -e 'undef $$_ if /#Mandriva/../Jump to:/; s!Image:\S*.png !!; s!\[edit\]!!; $$a ||= m!^   Retrieved from "$(RN_URL)"$$!; undef $$_ if $$a;' release-notes.txt

release-notes.html:
	curl $(RN_URL) > release-notes.html
	perl -pi -e 'undef $$_ if /"siteSub"\>From Mandriva Community Wiki/; s/(h1 class="firstHeading"\>)Releases.*\</\1Mandriva Linux $(VERSION) Release Notes\</ ; undef $$_ if /id="jump-to-nav">Jump to|id="breadcrumbs"/; s!<span class="editsection">.*?</span>!!; s!<a href="[^#h].*?">(.*?)</a>!\1! if $$a; $$a = 1 if /"mw-headline"/; undef $$_ if /Retrieved from/../<\/body/;' release-notes.html
