.libPaths( c( .libPaths(), "~/save/RuserLibrary") )
install.packages("RMySQL")
require(RMySQL)

session <- dbConnect(MySQL(), host="test-mysql.toulouse.inra.fr", db="funnymat",user="funnymat", password="XXX")

tags <- dbGetQuery(session, "select * from hit_tags")

ko_summary = function(sample_tag) {
  res = dbGetQuery(session, paste("
  select gk.ko_id, count(kh.hit_id) from noeu_hits kh
  join genes_ko gk on gk.gene_idx=kh.gene_idx
  where kh.tag=",sample_tag," group by gk.ko_id;",sep=""))
  colnames(res)=c("ko_id","count")
  res
}

res <- ko_summary(tags[1,1])

for(i in c(2:(length(tags$id))) ){
  tag=tags[i,] 
  sprintf("processing set %s\n", paste(tag[1],tag[2]))
  summary=ko_summary(tag[1])
  res=merge(res, ko_summary, by.x=c("ko_id"), by.y=c("ko_id"), all=T)
  names(res)[length(names(res))] = paste(tag[2])
  write.table(res,file="table_progress.csv", quote=T, col.names=T, row.names=F, sep="\t")
}