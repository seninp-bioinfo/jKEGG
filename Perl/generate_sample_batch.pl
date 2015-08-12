use strict;
use warnings;
use Getopt::Long;

my $sample_path = "";

my $result = GetOptions( "sample=s" => \$sample_path );

# /home/psenin/work/fm/Project_FUNHYMAT.206/Run_DNApool2.4241/RawData/D130_CGATGT_L001_R1.fastq.gz
my ($fname) = $sample_path =~ /.*\/([^\/]*)$/;
my ($base)  = $fname       =~ /([^.]*)/;
my $trimmedfname = $base . ".trimmed.fastq.gz";
my $alignedfname = $base . ".last.blastx.out.gz";
my $tablefname   = $base . ".table.gz";

# trimming
print "zcat "
  . $sample_path
  . " | cutadapt -q 15 -a AGATCGGAAGAGC --trim-n --max-n 0.1 --minimum-length 50 -"
  . " | fastq_quality_filter -q 20 -p 50 | gzip -9 >"
  . $trimmedfname . "\n";

# alignment
print "zcat "
  . $trimmedfname
  . " | seqtk seq -a -"
  . " | lastal -F15 ../genes.pep -"
  . " | maf-sort.sh -n2 -"
  . " | maf-convert.py blast"
  . " | gzip -9 > "
  . $alignedfname . "\n";

# table for MySQL
print "zcat "
  . $alignedfname
  . " | addevalue.pl"
  . " | parse_last_alignment.pl"
  . " | last_hit_sorter.pl"
  . " | gzip -9 >"
  . $tablefname . "\n";
