require(VennDiagram)
require(RMySQL)
require(ggplot2)
library(scales)
require(Cairo)
require(grid)
library(gridExtra)


session <- dbConnect(MySQL(), host="localhost", 
                     db="funnymat",user="funnymat", password="XXX")

blast_hits = dbGetQuery(session, "select tag, evalue from aligners_score where tag=\"BD\" and evalue<0.01")
last_hits = dbGetQuery(session, "select tag, evalue from aligners_score where tag=\"LAD\"")
diamond_hits = dbGetQuery(session, "select tag, evalue from aligners_score where tag=\"DSD\"")
lambda_hits = dbGetQuery(session, "select tag, evalue from aligners_score where tag=\"LSD\"")
pauda_hits = dbGetQuery(session, "select tag, evalue from aligners_score where tag=\"PSD\"")

df=rbind(blast_hits,last_hits,diamond_hits,lambda_hits,pauda_hits)

ggplot(df, aes(x=evalue, fill=tag)) +
  stat_density() + scale_y_continuous(labels = percent_format())

p1=ggplot(blast_hits,aes(x=evalue))+geom_histogram(identity=T,binwidth=0.005)+theme_classic()+
  ggtitle("Alignment length for best BLAST hits")
p1
p2=ggplot(last_hits,aes(x=evalue))+geom_histogram(identity=T,binwidth=0.005)+theme_classic()+
  ggtitle("Alignment length for best LAST hits")

p3=ggplot(diamond_hits,aes(x=evalue))+geom_histogram(identity=T,binwidth=0.0000001)+theme_classic()+
  ggtitle("Alignment length for best DIAMOND hits")

p4=ggplot(lambda_hits,aes(x=evalue))+geom_histogram(identity=T,binwidth=0.0000001)+theme_classic()+
  ggtitle("Alignment length for best LAMBDA hits")

p5=ggplot(pauda_hits,aes(x=evalue))+geom_histogram(identity=T,binwidth=0.0000001)+theme_classic()+
  ggtitle("Alignment length for best PAUDA hits")

grid.arrange(p1, p2, p3, p4, p5, ncol=1)

ggsave(arrangeGrob(p1, p2, p3, p4, p5, ncol=1), width=130, height=220, units="mm",
       file="length-tops.png", dpi=120)

