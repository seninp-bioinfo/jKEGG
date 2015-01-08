require("VennDiagram")
require(RMySQL)
require(reshape)
require(ggplot2)
library(scales)
require(Cairo)
require(grid)
library(gridExtra)

session <- dbConnect(MySQL(), host="localhost", 
                     db="funnymat",user="funnymat", password="MathIsFunny")

#select MAX(score) INTO @var_max_id from aligners_score where tag="BD";
#update aligners_score set normalized_score=score/@var_max_id where tag="BD";
#
#select MAX(score) INTO @var_max_id from aligners_score where tag="BM";
#update aligners_score set normalized_score=score/@var_max_id where tag="BM";
#
#select MAX(score) INTO @var_max_id from aligners_score where tag="LAD";
#update aligners_score set normalized_score=score/@var_max_id where tag="LAD";
#
#select MAX(score) INTO @var_max_id from aligners_score where tag="LAM";
#update aligners_score set normalized_score=score/@var_max_id where tag="LAM";
#
#select MAX(score) INTO @var_max_id from aligners_score where tag="DSD";
#update aligners_score set normalized_score=score/@var_max_id where tag="DSD";
#
#select MAX(score) INTO @var_max_id from aligners_score where tag="DSM";
#update aligners_score set normalized_score=score/@var_max_id where tag="DSM";
#
#select MAX(score) INTO @var_max_id from aligners_score where tag="LSM";
#update aligners_score set normalized_score=score/@var_max_id where tag="LSM";
#
#select MAX(score) INTO @var_max_id from aligners_score where tag="LSD";
#update aligners_score set normalized_score=score/@var_max_id where tag="LSD";
#
#select MAX(score) INTO @var_max_id from aligners_score where tag="PSD";
#update aligners_score set normalized_score=score/@var_max_id where tag="PSD";
#
#select MAX(score) INTO @var_max_id from aligners_score where tag="PSM";
#update aligners_score set normalized_score=score/@var_max_id where tag="PSM";

mtable = function(t){
  r=dbGetQuery(session, paste("select tag, count(*) from aligners_score where tag 
        in (\"BD\", \"DSD\", \"LAD\", \"LSD\", \"PSD\") and normalized_score>=",t," group by tag",sep=''))
  names(r)=c("tag","count")
  r
}  
mtable(0.99)

rr=mtable(1/100)
names(rr)=c("tag","t1")
for(i in 2:100){
  tt=mtable(i/100)
  rr=merge(rr,tt,all=T)
  names(rr)=c(names(rr)[1:(length(names(rr))-1)],paste("t",i,sep=''))
}
labels=rr$tag
rr=t(rr)[-1,]
class(rr)<-"numeric"
row.names(rr)<-NULL
dd=as.data.frame(rr)
names(dd)=c("Blast","Dimond Sensitive","Last","Lambda Sensitive","Pauda sensitive")
str(dd)

dm=melt(dd)
dm=cbind(dm,rep(1:100,5))
names(dm)=c("variable","count","threshold")
p=ggplot(dm,aes(x=threshold,y=count,color=variable))+theme_bw()+geom_line(size=1)+
  ggtitle("Number of best hits by normalized score, DNA")+scale_x_continuous("Normalized score")+
  scale_y_continuous("Count")
p


mtable = function(t){
  r=dbGetQuery(session, paste("select tag, count(*) from aligners_score where tag 
        in (\"BM\", \"DSM\", \"LAM\", \"LSM\", \"PSM\") and normalized_score>=",t," group by tag",sep=''))
  names(r)=c("tag","count")
  r
}  
mtable(20/100)

rr=mtable(1/100)
names(rr)=c("tag","t1")
for(i in 2:100){
  tt=mtable(i/100)
  rr=merge(rr,tt,all=T)
  names(rr)=c(names(rr)[1:(length(names(rr))-1)],paste("t",i,sep=''))
}
labels=rr$tag
rr=t(rr)[-1,]
class(rr)<-"numeric"
row.names(rr)<-NULL
dd=as.data.frame(rr)
names(dd)=c("Blast","Dimond Sensitive","Last","Lambda Sensitive","Pauda sensitive")
str(dd)

dm=melt(dd)
dm=cbind(dm,rep(1:100,5))
names(dm)=c("variable","count","threshold")
p1=ggplot(dm,aes(x=threshold,y=count,color=variable))+theme_bw()+geom_line(size=1)+
  ggtitle("Number of best hits by normalized score, mRNA")+scale_x_continuous("Normalized score")+
  scale_y_continuous("Count")
p1

ggsave(arrangeGrob(p, p1, ncol=1), width=160, height=160, units="mm",
       file="count_by_score.png", dpi=120)

