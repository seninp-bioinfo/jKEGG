#!/usr/bin/perl
use strict;
use warnings;

#open( my $handle, '<', 'test_sort.txt' )    # always use a variable here containing filename
# or die "Unable to open file, $!";

my $lastname = "";
my @records;

# Read the file line per line (or otherwise, it's configurable).
#while (<$handle>) {
while (<STDIN>) {
 chomp;

 # we expect four columns here
 #
 my @columns = split( '\t', $_ );

 if ( length($lastname) == 0 ) {

  #we entered the loop
  #print "processing " . $columns[0] . "\n";
  $lastname = $columns[0];

 }
 else {

  # where the first is the read name. obviously at the start its length is zero
  #
  if ( $lastname eq $columns[0] ) {

   # the name is the same, push stuff into the array
   #
   push @records, [@columns];

   #print "    .. skipping $_";
  }
  else {

   # if name is not the same
   #
   # sorting an array
   my @sorted = sort { $b->[2] <=> $a->[2] || $b->[3] <=> $a->[3] } @records;

   #print " * sorted top: " . "$sorted[0][0] $sorted[0][1] $sorted[0][2] $sorted[0][3]\n";
   print "$sorted[0][0]\t$sorted[0][1]\t$sorted[0][2]\t$sorted[0][3]\n";

   # and re-init the array
   #
   @records = [@columns];

   #print "processing " . $columns[0] . "\n";
   $lastname = $columns[0];
  }
 }
}
my @sorted = sort { $b->[2] <=> $a->[2] || $b->[3] <=> $a->[3] } @records;

#print " * sorted top: " . "$sorted[0][0] $sorted[0][1] $sorted[0][2] $sorted[0][3]\n";
print "$sorted[0][0]\t$sorted[0][1]\t$sorted[0][2]\t$sorted[0][3]\n";
