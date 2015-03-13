# library load
#
# this is how we roll with SRA data
require(SRAdb)
require(RSQLite)
require(rentrez)
# data transformation and strings
require(plyr)
require(stringr)
# this is how we plot
require(ggplot2)
require(grid)
require(gridExtra)

# get connected to local DB copy
sqlfile <- "/media/Stock/SRAmetadb.sqlite"
sra_con <- dbConnect(SQLite(),sqlfile)

# info
dbListTables(sra_con)
dbListFields(sra_con,"sample")
dbListFields(sra_con,"run")
dbListFields(sra_con,"study")
dbListFields(sra_con,"experiment")
dbListFields(sra_con,"submission")
dbListFields(sra_con,"fastq")
dbListFields(sra_con,"sra_ft_content")

rs <- getSRA( search_terms = "breast cancer",out_types = c("run"), sra_con )

# find Gallus taxon
dbGetQuery(sra_con,"select taxon_id, scientific_name from sample 
           where UPPER(scientific_name) like \"%GALLUS%\" group by taxon_id")
#  taxon_id      scientific_name
#1     9031        Gallus gallus
#2   208526 Gallus gallus gallus

# how many samples collected from chicken?
rs <- dbGetQuery(sra_con, "SELECT s.* FROM sample s WHERE s.taxon_id=9031")
# 917 samples

# get all SRAs that associated with the taxon
rs <- dbGetQuery(sra_con, "SELECT sra.*, e.* FROM sra 
                 join experiment e on e.experiment_accession =sra.experiment_accession 
                 WHERE sra.taxon_id=9031")
# 1163 meta-records

pie1 <- ggplot(rs, aes(x = factor(1), fill=platform))+geom_bar(width = 1)+
  guides(fill = guide_legend(reverse=T)) + ggtitle("Instruments used in Gallus Gallus studies") + theme_bw()
pie1 = pie1 + coord_polar(theta="y")
pie1

pie2 <- ggplot(rs, aes(x = factor(1), fill=library_strategy))+geom_bar(width = 1)+
  guides(fill = guide_legend(reverse=T)) + ggtitle("Library strategy used in Gallus Gallus studies") + theme_bw()
pie2 = pie2 + coord_polar(theta="y")
pie2

pie3 <- ggplot(rs, aes(x = factor(1), fill=library_source))+geom_bar(width = 1)+
  guides(fill = guide_legend(reverse=T)) + ggtitle("Library source used in Gallus Gallus studies") + theme_bw()
pie3 = pie3 + coord_polar(theta="y")
pie3

# select only transcriptomic and the spot length
rs <- dbGetQuery(sra_con, 
          "select ROUND((bases/spots)) AS SpotLength, sra.* 
          from sra WHERE (taxon_id=9031 OR taxon_id=208526)
          AND library_source=\"TRANSCRIPTOMIC\" 
          AND UPPER(library_layout) LIKE \"%PAIRED%\" 
          AND UPPER(instrument_model) LIKE \"%HISEQ%\" order by SpotLength DESC;")

pie4 <- ggplot(rs, aes(x = factor(1), fill=factor(SpotLength)))+geom_bar(width = 1)+
  guides(fill = guide_legend(reverse=T)) + labs(title = "Spot length found in Gallus Gallus \n TRANSCRIPTOMIC runs with PAIRED strategy") + 
  theme(plot.title = element_text(hjust = 0.5))
pie4 = pie4 + coord_polar(theta="y")
pie4

pie5 <- ggplot(rs, aes(x = factor(1), fill=factor(library_name)))+geom_bar(width = 1)+
  guides(fill = guide_legend(reverse=T)) + labs(title = "Libraries found in Gallus Gallus \n TRANSCRIPTOMIC runs") + 
  theme(plot.title = element_text(hjust = 0.5))
pie5 = pie5 + coord_polar(theta="y")
pie5

# select only transcriptomi and the spot length
ids200=rs[rs$SpotLength==200.0,]$run_accession
listSRAfile(ids200,sra_con=sra_con,fileType="sra",srcType="fasp")
