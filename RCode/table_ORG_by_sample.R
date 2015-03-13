# get connected
require(RMySQL)
session <- dbConnect(MySQL(), host="test-mysql.toulouse.inra.fr", 
                     db="funnymat",user="funnymat", password="MathIsFunny")

# get all samples
tags <- dbGetQuery(session, "select * from hit_tags")

org_summary = function(sample_tag) {
  res = dbGetQuery(session, paste("
  select o.code, count(kh.hit_id) from noeu_hits kh join 
  organisms o on kh.organism_idx=o.id
  where kh.tag=",sample_tag," group by kh.organism_idx;",sep=""))
  colnames(res)=c("org_code","count")
  res
}

#init the table
res <- org_summary(tags[1,1])

#in the loop extract all others, saves the progress
for(i in c(2:(length(tags$id))) ){
  tag=tags[i,] 
  sprintf("processing set %s\n", paste(tag[1],tag[2]))
  summary=org_summary(as.numeric(tag[1]))
  res=merge(res, summary, by.x=c("org_code"), by.y=c("org_code"), all=T)
  names(res)[length(names(res))] = paste(tag[2])
  write.table(res,file="table_progress.csv", quote=T, col.names=T, row.names=F, sep="\t")
}

write.table(res,file="table_all_org_noeuc.csv", quote=T, col.names=T, row.names=F, sep="\t")

# get the ORG table
orgs = res[,1]
qq=function(orgcode) {
  res = dbGetQuery(session, paste("
  select code, name, lineage from organisms 
  where code=",shQuote(orgcode),";",sep=""))
  res
}
org_lineage=matrix(unlist(apply(t(t(orgs)),1,qq)),by.row=T,ncol=3)
colnames(org_lineage)=c("org_code","name","lineage")

res2=merge(org_lineage, res, by.x=c("org_code"), by.y=c("org_code"), all=T)

write.table(res2,file="table_all_ORG_noeuc_FINAL.csv", quote=T, col.names=T, row.names=F, sep="\t")