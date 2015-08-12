use strict;
use warnings;
use Getopt::Long;

my $maxn       = "0.1";
my $maxstretch = 4;

my $result = GetOptions(
 "maxn=f"       => \$maxn,
 "maxstretch=i" => \$maxstretch
);

foreach my $line (<STDIN>) {
 chomp($line);
 my $num_n = $line =~ tr/N//;
 my $percentage = $num_n / length($line);
 ( my $alt_str = $line ) =~ s/((N)+)/$2 . length($1)/ge;
 my @all_nums = $alt_str =~ /(\d+)/g;
 @all_nums = sort { $b <=> $a } @all_nums;
 print "total Ns " 
   . $num_n
   . " percentage "
   . $percentage
   . ", longest stretch "
   . $all_nums[0] . "\n";
 if ( $percentage > $maxn ) {
  print "   percentage of Ns is above the threshold!\n";
 }
 if ( $all_nums[0] > $maxstretch ) {
  print "   max stretch is above threshold!\n";
 }
}
