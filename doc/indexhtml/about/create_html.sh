#!/bin/sh

BASEDIR=".."
XMLFILE="index.html.in"
PODIR='./po'
HTMLDIR='./html'

rm -rf $HTMLDIR
mkdir $HTMLDIR

intltool-extract --type=gettext/xml ${XMLFILE}
xgettext -o po/index.pot -kN_ --debug index.html.in.h
for i in po/*.po; do
	[ -e "$i" ] || continue
	msgmerge $i po/index.pot
done

cd $HTMLDIR
intltool-merge --xml-style -m ../${PODIR} ../${XMLFILE} index.html

for indexdir in $(ls); do
    mv $indexdir/index.html index-$indexdir.html
    rm -rf $indexdir
done

if [ -e "index-C.html" ]; then
    mv index-C.html index.html
fi

cd ..
intltool-merge --desktop-style -m po about-openmandriva-lx.desktop.in about-openmandriva-lx.desktop
