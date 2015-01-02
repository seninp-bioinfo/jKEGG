require("VennDiagram")
require(RMySQL)
require(reshape)
session <- dbConnect(MySQL(), host="localhost", 
                     db="funnymat",user="funnymat", password="XXX")

mtable = function(t){
  r=dbGetQuery(session, paste("select tag, count(*) from aligners_similarity where tag like \'%D\' and aln_length>=",t," group by tag",sep=''))
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
names(dd)=labels
str(dd)

dm=melt(dd)
dm=cbind(dm,rep(1:40,16))
names(dm)=c("variable","count","threshold")
p=ggplot(dm,aes(x=threshold,y=count,color=variable))+theme_bw()+geom_line(size=2)+
  ggtitle("Number of alignments by length threshold")+scale_x_continuous("Alignment length")+
  scale_y_continuous("Count")
p
