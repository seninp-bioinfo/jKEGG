require(VennDiagram)
require(RMySQL)
require(ggplot2)
require(Cairo)
require(grid)
library(gridExtra)


session <- dbConnect(MySQL(), host="localhost", 
                     db="funnymat",user="funnymat", password="XXX")
blast_hits = dbGetQuery(session, "select identity from aligners_tops_score where tag=\"BD\"")
last_hits = dbGetQuery(session, "select identity from aligners_tops_score where tag=\"LAD\"")
diamond_hits = dbGetQuery(session, "select identity from aligners_tops_score where tag=\"DSD\"")
lambda_hits = dbGetQuery(session, "select identity from aligners_tops_score where tag=\"LSD\"")
pauda_hits = dbGetQuery(session, "select identity from aligners_tops_score where tag=\"PSD\"")

p1=ggplot(blast_hits,aes(x=identity))+geom_histogram(identity=T,binwidth=10)+theme_classic()+
  ggtitle("Score for best BLAST hits") + scale_x_continuous(limits = c(0, 100))
p2=ggplot(last_hits,aes(x=identity))+geom_histogram(identity=T,binwidth=10)+theme_classic()+
  ggtitle("Score for best LAST hits")+ scale_x_continuous(limits = c(0, 100))
p3=ggplot(diamond_hits,aes(x=identity))+geom_histogram(identity=T,binwidth=10)+theme_classic()+
  ggtitle("Score for best DIAMOND hits")+ scale_x_continuous(limits = c(0, 100))
p4=ggplot(lambda_hits,aes(x=identity))+geom_histogram(identity=T,binwidth=10)+theme_classic()+
  ggtitle("Score for best LAMBDA hits")+ scale_x_continuous(limits = c(0, 100))
p5=ggplot(pauda_hits,aes(x=identity))+geom_histogram(identity=T,binwidth=10)+theme_classic()+
  ggtitle("Score for best PAUDA hits")+ scale_x_continuous(limits = c(0, 100))

grid.arrange(p1, p2, p3, p4, p5, ncol=1)
