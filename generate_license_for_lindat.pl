#!/usr/bin/env perl
# Takes a list of UD treebanks (repository names) to be released. Scans their
# folders for the license lines in README files. Generates the joint license
# files (HTML and XML) in the form required by Lindat.
# Copyright © 2020 Dan Zeman <zeman@ufal.mff.cuni.cz>
# License: GNU GPL

use utf8;
use open ':utf8';
binmode(STDIN, ':utf8');
binmode(STDOUT, ':utf8');
binmode(STDERR, ':utf8');
use Getopt::Long;

sub usage
{
    print STDERR ("Usage: LICENSE/generate_license_for_lindat.pl --release 2.6 --date 2020/05/15 \$(cat released_treebanks.txt)\n");
}

my $release; # = 2.6;
my $date; # = '2020/05/15';
GetOptions
(
    'release=s' => \$release,
    'date=s'    => \$date
);
if($release !~ m/^\d+\.\d+$/)
{
    usage();
    die("Unknown release '$release'");
}
if($date !~ m:^\d\d\d\d/\d\d/\d\d$:)
{
    usage();
    die("Unexpected date format '$date'");
}

my @treebanks = sort(@ARGV);
my $n = scalar(@treebanks);
print STDERR ("Collecting licenses from $n treebanks...\n");
my %licurl =
(
    'GNU GPL 2.0'     => 'http://opensource.org/licenses/GPL-2.0',
    'GNU GPL 3.0'     => 'http://opensource.org/licenses/GPL-3.0',
    'LGPL-LR'         => 'http://www.ida.liu.se/~sarst/bitse/lgpllr.html',
    'CC BY 4.0'       => 'http://creativecommons.org/licenses/by/4.0/',
    'CC BY-SA 3.0'    => 'http://creativecommons.org/licenses/by-sa/3.0/',
    'CC BY-SA 4.0'    => 'http://creativecommons.org/licenses/by-sa/4.0/',
    'CC BY-NC-ND 3.0' => 'http://creativecommons.org/licenses/by-nc-nd/3.0/',
    'CC BY-NC-SA 2.5' => 'http://creativecommons.org/licenses/by-nc-sa/2.5/',
    'CC BY-NC-SA 3.0' => 'http://creativecommons.org/licenses/by-nc-sa/3.0/',
    'CC BY-NC-SA 4.0' => 'http://creativecommons.org/licenses/by-nc-sa/4.0/',
    'PD'              => 'public domain'
);
my %tbklic;
foreach my $treebank (@treebanks)
{
    my $license;
    my $readme = "$treebank/README.md";
    if(!-f $readme)
    {
        $readme =~ s/\.md$/.txt/;
    }
    open(README, $readme) or die("Cannot read '$readme': $!");
    while(<README>)
    {
        chomp();
        if(m/^License:\s*(.+)$/)
        {
            $license = $1;
            last;
        }
    }
    close(README);
    if(!defined($license))
    {
        die("Cannot figure out the license of '$treebank'");
    }
    if(!exists($licurl{$license}))
    {
        die("Unknown license '$license' for treebank '$treebank'");
    }
    $tbklic{$treebank} = $license;
}
# Print the license in HTML. Modeled after
# https://github.com/ufal/clarin-dspace/blob/clarin-dev/dspace-xmlui/src/main/webapp/themes/UFAL/lib/html/licence-UD-2.5.html
print STDERR ("XML and HTML of the license will be generated in the LICENSE folder.\n");
print STDERR ("Send them to the Lindat staff and/or create a pull request against\n");
print STDERR ("https://github.com/ufal/clarin-dspace/blob/clarin-dev/dspace-xmlui/src/main/webapp/themes/UFAL/lib/html/");
print STDERR ("(branch clarin-dev of ufal/clarin-dspace)\n");
my $licpath = "LICENSE/license-ud-$release";
open(XML, ">$licpath.xml") or die("Cannot write '$licpath.xml': $!");
print XML <<EOF
<?xml version="1.0"?>
<page>
  <title>Universal Dependencies v$release License Agreement</title>
  <title-menu>Universal Dependencies v$release License Agreement</title-menu>
</page>
EOF
;
close(XML);
open(HTML, ">$licpath.html") or die("Cannot write '$licpath.html': $!");
print HTML <<EOF
<div id="faq-like">
  <h2 id="ufal-point-faq">Universal Dependencies v$release License Agreement</h2>
  <div>
    ($date)
  </div>
  <hr />
  <div class="well">
  <h3>Universal Dependencies v$release License Terms</h3>
  <p>Universal Dependencies v$release (referred to as &#x201C;UD&#x201D; in the rest of this document)
     is a collection of linguistic data and tools. Each of the treebanks has its own license terms
     and you (the &#x201C;User&#x201D;) are responsible for complying with the license terms
     applicable to those parts of UD which you use. If you do not agree with the license terms,
     you must stop using UD and destroy all copies of UD data that you have obtained.</p>
  <br />
  <p class="alert alert-danger">You are specifically reminded that some of the treebanks
     permit only non-commercial usage.</p>
  <br />
  <p>The additional software tools are provided as-is (without any warranty) and are redistributed
     under GNU GPL Version 2.</p>
  <br />
  <p>The license for every treebank included in the release is specified in the appropriate
     treebank directory.</p>
  <br />

  <h3>Overview of the treebanks and their license terms</h3>
  <table class="table table-striped">
    <thead>
      <tr><th>Treebank</th><th>License</th></tr>
    </thead>
    <tbody>
EOF
;
foreach my $treebank (@treebanks)
{
    my $tbknoud = $treebank;
    $tbknoud =~ s/^UD_//;
    print HTML ("      <tr>\n");
    print HTML ("        <td>$tbknoud</td>\n");
    print HTML ("        <td>$tbklic{$treebank}</td>\n");
    print HTML ("      </tr>\n");
}
print HTML <<EOF
    </tbody>
  </table>

  <h3>Licenses</h3>
  <table class="table">
    <thead>
      <tr><th>License</th><th>URL</th></tr>
    </thead>
    <tbody>
EOF
;
my @licenses = sort(keys(%licurl));
foreach my $license (@licenses)
{
    my $reference = $licurl{$license};
    if($reference =~ m/^http/)
    {
        $reference = "<a href=\"$reference\">$reference</a>";
    }
    print HTML ("      <tr><td>$license</td><td>$reference</td></tr>\n");
}
print HTML <<EOF
    </tbody>
  </table>
  </div>
</div>
EOF
;
close(HTML);
