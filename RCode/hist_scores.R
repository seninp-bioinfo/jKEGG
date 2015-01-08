require(VennDiagram)
require(RMySQL)
require(ggplot2)
require(Cairo)
require(grid)
library(gridExtra)


session <- dbConnect(MySQL(), host="localhost", 
                     db="funnymat",user="funnymat", password="XXX")

blast_hits = dbGetQuery(session, "select score from aligners_score where tag=\"BD\" order by hit_id ASC")
last_hits = dbGetQuery(session, "select score from aligners_score where tag=\"LAD\" order by hit_id ASC")
diamond_hits = dbGetQuery(session, "select score from aligners_score where tag=\"DSD\" order by hit_id ASC")
lambda_hits = dbGetQuery(session, "select score from aligners_score where tag=\"LSD\" order by hit_id ASC")
pauda_hits = dbGetQuery(session, "select score from aligners_score where tag=\"PSD\" order by hit_id ASC")

p1=ggplot(blast_hits,aes(x=score))+geom_histogram(identity=T,binwidth=5)+theme_classic()+
  ggtitle("Score for best BLAST hits") + geom_density()
p2=ggplot(last_hits,aes(x=score))+geom_histogram(identity=T,binwidth=5)+theme_classic()+
  ggtitle("Score for best LAST hits")
p3=ggplot(diamond_hits,aes(x=score))+geom_histogram(identity=T,binwidth=5)+theme_classic()+
  ggtitle("Score for best DIAMOND hits")
p4=ggplot(lambda_hits,aes(x=score))+geom_histogram(identity=T,binwidth=5)+theme_classic()+
  ggtitle("Score for best LAMBDA hits")
p5=ggplot(pauda_hits,aes(x=score))+geom_histogram(identity=T,binwidth=5)+theme_classic()+
  ggtitle("Score for best PAUDA hits")

grid.arrange(p1, p2, p3, p4, p5, ncol=1)

ggsave(arrangeGrob(p1, p2, p3, p4, p5, ncol=1), width=130, height=220, units="mm",
       file="hist-score.png", dpi=120)

blast_hits = dbGetQuery(session, "select normalized_score from aligners_score where tag=\"BD\" order by hit_id ASC")
last_hits = dbGetQuery(session, "select normalized_score from aligners_score where tag=\"LAD\" order by hit_id ASC")
diamond_hits = dbGetQuery(session, "select normalized_score from aligners_score where tag=\"DSD\" order by hit_id ASC")
lambda_hits = dbGetQuery(session, "select normalized_score from aligners_score where tag=\"LSD\" order by hit_id ASC")
pauda_hits = dbGetQuery(session, "select normalized_score from aligners_score where tag=\"PSD\" order by hit_id ASC")

p1=ggplot(blast_hits,aes(x=normalized_score))+geom_histogram(identity=T,binwidth=0.05)+theme_classic()+
  ggtitle("Score for best BLAST hits") + geom_density()
p2=ggplot(last_hits,aes(x=normalized_score))+geom_histogram(identity=T,binwidth=0.05)+theme_classic()+
  ggtitle("Score for best LAST hits")
p3=ggplot(diamond_hits,aes(x=normalized_score))+geom_histogram(identity=T,binwidth=0.05)+theme_classic()+
  ggtitle("Score for best DIAMOND hits")
p4=ggplot(lambda_hits,aes(x=normalized_score))+geom_histogram(identity=T,binwidth=0.05)+theme_classic()+
  ggtitle("Score for best LAMBDA hits")
p5=ggplot(pauda_hits,aes(x=normalized_score))+geom_histogram(identity=T,binwidth=0.05)+theme_classic()+
  ggtitle("Score for best PAUDA hits")

grid.arrange(p1, p2, p3, p4, p5, ncol=1)

ggsave(arrangeGrob(p1, p2, p3, p4, p5, ncol=1), width=130, height=220, units="mm",
       file="hist-score-normalized.png", dpi=120)