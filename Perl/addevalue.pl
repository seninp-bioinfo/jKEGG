use strict;
use warnings;

while (<STDIN>) {
 if (m/Score = \d+/) {
  $_ =~ s/(Score = \d+)/$1 \(100 bits\), Expect = 5.0e-47, Sum P(3) = 5.0e-47/g;
 }
 print $_;
}