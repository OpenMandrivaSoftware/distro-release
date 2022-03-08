# Useful macros for building *.rpm perl packages.
# (from Artur Frysiak <wiget@t17.ds.pwr.wroc.pl>)

%perl_vendorarch %(eval "`perl -V:installvendorarch`"; echo $installvendorarch)
%perl_vendorlib %(eval "`perl -V:installvendorlib`"; echo $installvendorlib)
%perl_version %(eval "`perl -V:version`"; echo $version)
