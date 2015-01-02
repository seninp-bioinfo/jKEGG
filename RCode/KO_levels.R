require("VennDiagram")
require(RMySQL)
require(reshape)
session <- dbConnect(MySQL(), host="localhost", 
                     db="funnymat",user="funnymat", password="XXX")

blast_hits = dbGetQuery(session, "select ko_id, count(*) cnt from aligners_similarity where tag=\"BD\" and ko_id is NOT NULL group by ko_id order by cnt DESC limit 10;")
last_hits = dbGetQuery(session, "select ko_id, count(*) cnt from aligners_similarity where tag=\"LAD\" and ko_id is NOT NULL group by ko_id order by cnt DESC limit 10;")
diamond_hits = dbGetQuery(session, "select ko_id, count(*) cnt from aligners_similarity where tag=\"DSD\" and ko_id is NOT NULL group by ko_id order by cnt DESC limit 10;")
lambda_hits = dbGetQuery(session, "select ko_id, count(*) cnt from aligners_similarity where tag=\"LSD\" and ko_id is NOT NULL group by ko_id order by cnt DESC limit 10;")
pauda_hits = dbGetQuery(session, "select ko_id, count(*) cnt from aligners_similarity where tag=\"PSD\" and ko_id is NOT NULL group by ko_id order by cnt DESC limit 10;")


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
  scale_x_discrete(labels=desc) + theme(axis.text.x = element_text(angle = 70, hjust = 1))
p
