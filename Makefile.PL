use ExtUtils::MakeMaker;
use Config;

$perlpath=$Config{'perlpath'};

$Version = '1.0';

# Check for non-standard modules that are used by this library.
$| = 1;
my $missing_modules = 0;

print "Checking for Net::FTP...";
eval {
    require Net::FTP;
    Net::FTP->require_version('2.00');
};
if ($@) {
    print " failed\n";
    $missing_modules++;
    print <<EOT;
$@
The Mirror program requires the Net::FTP module.
You will have to get and install at least libnet-1.01.

EOT
    sleep(2);  # Don't hurry too much
    exit 1;
} else {
    print " ok\n";
}

print "Checking for File::Recurse...";
eval {
    require File::Recurse;
};
if ($@) {
    print " failed\n";
    $missing_modules++;
    print <<EOT;
$@
The Mirror program requires the File::Recurse module.
You will have to get and install at least File-Tools-2.0.

EOT
    sleep(2);  # Don't hurry too much
    exit 1;
} else {
    print " ok\n";
}

WriteMakefile(
    'NAME'     => 'Mirror',
    'EXE_FILES' => ['mirror'],
    'clean' => {FILES => "*% *.bak Make/*%"},
    'linkext' => { LINKTYPE => ''},
    'dist'     => { COMPRESS => 'gzip -f', SUFFIX => 'gz' },
    'VERSION'  => $Version
);

open FILE,"mirror" || die;
@temp = <FILE>;
close FILE;
shift @temp;
open FILE,">mirror" || die;
print FILE "#! $perlpath\n";
print FILE @temp;
close FILE;
chmod 0755,"mirror";
