require("VennDiagram")
require(RMySQL)
require(reshape)
session <- dbConnect(MySQL(), host="localhost", 
                     db="funnymat",user="funnymat", password="XXX")

mtable = function(t){
  r=dbGetQuery(session, paste("select tag, count(*) from aligners_length where tag 
        in (\"BD\", \"DSD\", \"LAD\", \"LSD\", \"PSD\") and aln_length>=",t," group by tag",sep=''))
  names(r)=c("tag","count")
  r
}  
mtable(20)

rr=mtable(1)
names(rr)=c("tag","t1")
for(i in 2:40){
  tt=mtable(i)
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
dm=cbind(dm,rep(1:40,5))
names(dm)=c("variable","count","threshold")
p=ggplot(dm,aes(x=threshold,y=count,color=variable))+theme_bw()+geom_line(size=1)+
  ggtitle("Number of alignments by length threshold, DNA")+scale_x_continuous("Alignment length")+
  scale_y_continuous("Count")
p


mtable = function(t){
  r=dbGetQuery(session, paste("select tag, count(*) from aligners_length where tag 
        in (\"BM\", \"DSM\", \"LAM\", \"LSM\", \"PSM\") and aln_length>=",t," group by tag",sep=''))
  names(r)=c("tag","count")
  r
}  
mtable(20)

rr=mtable(1)
names(rr)=c("tag","t1")
for(i in 2:40){
  tt=mtable(i)
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
dm=cbind(dm,rep(1:40,5))
names(dm)=c("variable","count","threshold")
p1=ggplot(dm,aes(x=threshold,y=count,color=variable))+theme_bw()+geom_line(size=1)+
  ggtitle("Number of alignments by length threshold, mRNA")+scale_x_continuous("Alignment length")+
  scale_y_continuous("Count")
p1

ggsave(arrangeGrob(p, p1, ncol=1), width=160, height=160, units="mm",
       file="length-alignments-length.png", dpi=120)

