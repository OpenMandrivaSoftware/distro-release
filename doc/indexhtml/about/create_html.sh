#!/bin/sh

BASEDIR=".."
XMLFILE="index.html.in"
PODIR='./po'
HTMLDIR='./html'

if [ ! -d $HTMLDIR ]; then
    mkdir $HTMLDIR
fi

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
