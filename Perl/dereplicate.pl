use strict;
use warnings;
use Bio::SeqIO;
use Getopt::Long;
use Pod::Usage;

# global hashes in use
#
my %unique;
my %counts;

my $help;
my $file_in;
my $file_out;
usage()
  if (
 @ARGV < 1
 or !GetOptions(
  "help|?"   => \$help,
  "input=s"  => \$file_in,
  "output=s" => \$file_out
 )
 or defined $help
  );

my $seqio  = Bio::SeqIO->new( -file => $file_in, -format => "fasta" );
my $outseq = Bio::SeqIO->new( -file => ">$file_out", -format => "fasta" );

my $counter = 0;
while ( my $seqs = $seqio->next_seq ) {

 # get the sequence info
 my $id  = $seqs->display_id;
 my $seq = $seqs->seq;

 # check if it exists in the unique
 if ( exists( $unique{$seq} ) ) {
  $counts{ $unique{$seq} } += 1;
 }
 else {
  $unique{$seq} = $id;
  $counts{$id}  = 1;
 }

 $counter++;
 if ( $counter % 100000 == 0 ) {
  print "processed $counter sequences\n";
 }

}

# fake names and write sequences with size of repeats
$counter = 0;
my $key;
my $value;
while ( ( $key, $value ) = each %unique ) {
 my $newseq_record = Bio::PrimarySeq->new(
  -seq        => $key,
  -display_id => $value . ";size=" . $counts{$value} . ";"
 );
 $outseq->write_seq($newseq_record);

 $counter++;
 if ( $counter % 100000 == 0 ) {
  print "saved $counter sequences\n";
 }

}

## usage help
#
sub usage {
 print "Unknown option: @_\n" if (@_);
 print "Dereplicates the fasta file adding annotation: dereplicate.pl [ parameters ] \n"
   . " -input    <FASTA input> \n"
   . " -output   <FASTA output> \n";
 exit;
}
