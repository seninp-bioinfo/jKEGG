require("VennDiagram")
require(RMySQL)
require(reshape)
session <- dbConnect(MySQL(), host="localhost", 
                     db="funnymat",user="funnymat", password="XXX")

last_hits = dbGetQuery(session, "select ko_id, count(*) cnt from aligners_score where tag=\"LAM\" and ko_id is NOT NULL group by ko_id order by cnt DESC limit 10;")
ko_ids=as.character(last_hits$ko_id)
seq=paste("\"",paste(ko_ids,collapse="\", \""),"\"",sep="")
blast_hits = dbGetQuery(session, paste("select ko_id, count(*) cnt from aligners_score where tag=\"BM\" and evalue<0.01 and ko_id in (",
seq,") group by ko_id;",sep=""))
diamond_hits = dbGetQuery(session, paste("select ko_id, count(*) cnt from aligners_score where tag=\"DSM\" and ko_id in (",
  seq,") group by ko_id;",sep=""))
lambda_hits = dbGetQuery(session, paste("select ko_id, count(*) cnt from aligners_score where tag=\"LSM\" and ko_id in (",
  seq,") group by ko_id;",sep=""))
pauda_hits = dbGetQuery(session, paste("select ko_id, count(*) cnt from aligners_score where tag=\"PSM\" and ko_id in (",
  seq,") group by ko_id;",sep=""))

dd=merge(blast_hits,last_hits, by="ko_id",all=T,suffixes = c(".blast",".last"))
dd=merge(dd,diamond_hits, by="ko_id",all=T)
dd=merge(dd,lambda_hits, by="ko_id",all=T,suffixes = c(".diamond",".lambda"))
dd=merge(dd,pauda_hits, by="ko_id",all=T)
names(dd)=c("ko_id","blast","last","diamond","lambda","pauda")

id2desc = function(ko_id){
  as.character(unlist(dbGetQuery(session, paste("select description from ko_description where ko_id=",shQuote(ko_id),";",sep=''))))
}  
desc=apply(as.matrix(dd$ko_id),1,id2desc)

df=melt(dd)

p=ggplot(df,aes(x=ko_id,y=value,fill=variable)) + geom_bar(position="dodge") + 
  scale_x_discrete(labels=desc) + theme(axis.text.x = element_text(angle = 70, hjust = 1, vjust=1))+
  ggtitle("Top 10 expressed KO of LAST compared by aligner")
p

ggsave(arrangeGrob(p, ncol=1), width=200, height=160, units="mm",
       file="expression-score-blast-last-mRNA.png", dpi=140)

