%perl_convert_version() %(perl -Mversion -le '
	$x = "%{1}";
	$y = $x;
	$x =~ s/[[:alpha:]]*$//;
	$y =~ s/^$x//;
	$x =~ s/\D*$//;
	$v = version->new($x)->normal;
	$v =~ s/^v//;
	print "$v$y";
')

#==============================================================================
# Useful macros for building *.rpm perl packages.
# (from Artur Frysiak <wiget@t17.ds.pwr.wroc.pl>)

%perl_vendorarch %(eval "`perl -V:installvendorarch`"; echo $installvendorarch)
%perl_vendorlib %(eval "`perl -V:installvendorlib`"; echo $installvendorlib)
%perl_version %(eval "`perl -V:version`"; echo $version)
