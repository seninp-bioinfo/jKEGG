require(VennDiagram)
require(RMySQL)
require(ggplot2)
library(scales)
require(Cairo)
require(grid)
library(gridExtra)


session <- dbConnect(MySQL(), host="localhost", 
                     db="funnymat",user="funnymat", password="XXX")

nmr=function(dd){
  dd$aln_length=dd$aln_length/(dim(dd)[1])
  dd
}

blast_hits = nmr(dbGetQuery(session, "select tag, aln_length from aligners_similarity where tag=\"BD\""))
last_hits = nmr(dbGetQuery(session, "select tag, aln_length from aligners_similarity where tag=\"LAD\""))
diamond_hits = nmr(dbGetQuery(session, "select tag, aln_length from aligners_similarity where tag=\"DSD\""))
lambda_hits = nmr(dbGetQuery(session, "select tag, aln_length from aligners_similarity where tag=\"LSD\""))
pauda_hits = nmr(dbGetQuery(session, "select tag, aln_length from aligners_similarity where tag=\"PSD\""))

df=rbind(blast_hits,last_hits,diamond_hits,lambda_hits,pauda_hits)

ggplot(df, aes(x=aln_length, fill=tag)) +
  stat_density() + scale_y_continuous(labels = percent_format())

p1=ggplot(blast_hits,aes(x=aln_length))+geom_histogram(identity=T,binwidth=10)+theme_classic()+
  ggtitle("Alignment length for best BLAST hits") + scale_x_continuous(limits = c(0, 100))
p2=ggplot(last_hits,aes(x=aln_length))+geom_histogram(identity=T,binwidth=10)+theme_classic()+
  ggtitle("Alignment length for best LAST hits")+ scale_x_continuous(limits = c(0, 100))
p3=ggplot(diamond_hits,aes(x=aln_length))+geom_histogram(identity=T,binwidth=10)+theme_classic()+
  ggtitle("Alignment length for best DIAMOND hits")+ scale_x_continuous(limits = c(0, 100))
p4=ggplot(lambda_hits,aes(x=aln_length))+geom_histogram(identity=T,binwidth=10)+theme_classic()+
  ggtitle("Alignment length for best LAMBDA hits")+ scale_x_continuous(limits = c(0, 100))
p5=ggplot(pauda_hits,aes(x=aln_length))+geom_histogram(identity=T,binwidth=10)+theme_classic()+
  ggtitle("Alignment length for best PAUDA hits")+ scale_x_continuous(limits = c(0, 100))

grid.arrange(p1, p2, p3, p4, p5, ncol=1)

ggsave(arrangeGrob(p1, p2, p3, p4, p5, ncol=1), width=130, height=220, units="mm",
       file="length-tops.png", dpi=120)

