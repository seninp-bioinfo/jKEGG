require(RMySQL)
session <- dbConnect(MySQL(), host="XXX", db="YYY",user="ZZZ", password="QQQ")


tags <- dbGetQuery(session, "select * from hit_tags")
current_set_tag <- "sulfur_cycle_SO"

# define the KO summary function
#
#
ko_summary = function(sample_tag,set_tag) {
  res = dbGetQuery(session, paste("
  select gk.ko_id, count(kh.hit_id) from kegg_hits kh
  join genes_ko gk on gk.gene_idx=kh.gene_idx
  join organisms_of_interest oi on oi.organism_idx=kh.organism_idx
  where kh.tag=",sample_tag," and oi.tag=",shQuote(set_tag),"
  group by gk.ko_id;",sep=""))
  colnames(res)=c("ko_id","count")
  res
}

res <- ko_summary(tags[1,1],current_set_tag)
names(res)[length(names(res))] <- paste(tags[1,2])

tag_koso_summary = function(tag) {
 res = dbGetQuery(session, paste("
  select o.code, o.tnum, o.name, o.lineage, count(kh.hit_id) as abundance from kegg_hits kh
  join organisms o on o.id=kh.organism_idx
  join organisms_of_interest oi on oi.organism_idx=o.id
  where kh.tag=",tag," and oi.tag='sulfur_cycle_SO' group by kh.organism_idx
  order by abundance;",sep=""))
  colnames(res)=c("code","tnum","name","lineage","count")
  res
}

tags <- dbGetQuery(session, "select * from hit_tags")

res <- tag_so_summary(tags[1,1])

names(res)[length(names(res))] = paste(tags[1,2])

for(i in c(2:(length(tags$id))) ){
 tag=tags[i,] 
 sprintf("processing set %s\n", paste(tag[1],tag[2]))
 summary=tag_so_summary(tag[1])
 res=merge(res, summary, by.x=c("code","tnum","name","lineage"), by.y=c("code","tnum","name","lineage"), all=T)
 names(res)[length(names(res))] = paste(tag[2])
 write.table(res,file="SR_org_table_progress.csv", quote=T, col.names=T, row.names=F, sep="\t")
}

write.table(res,file="SR_org_table_final.csv", quote=T, col.names=T, row.names=F, sep="\t")

################
################
################

map_titles=function(ko_id) {
  sequence=rep("",10)
  res = dbGetQuery(session, paste("
  select mt.title from ko_map km 
   join map_title mt on km.map_id=mt.map_id 
   where ko_id=",
   shQuote(ko_id),";",sep=""))
  res
  if(dim(res)[1]>0){
    res = as.vector(t(res))
    if(length(res)>10){
      sequence = res[1:10]
    } else {
      sequence[1:length(res)] = res
    }
  }
  sequence
}
map_titles("K00006")

kos = res[,1]

tmp_set = matrix( rep("",11), nrow=1)
for(ko_id in kos){
  tmp = map_titles(substring(ko_id,4))
  print(paste(ko_id))
  tmp_set <- rbind( tmp_set, matrix(c(ko_id,tmp),nrow=1) )
}

tmp_set = tmp_set[-1,]
colnames(tmp_set)=c("ko_id",paste("pathway_",1:10,sep=""))
res2=merge(res, tmp_set, by.x=c("ko_id"), by.y=c("ko_id"), all=T)
write.table(res,file="SO_org_table_final2.csv", quote=T, col.names=T, row.names=F, sep="\t")

################
################
################

organisms=function(tag, ko_id) {
  sequence=rep("",1)
  recordset = dbGetQuery(session, paste("
  select o.name, count(kh.hit_id) as cnt from kegg_hits kh 
   join organisms o on o.id=kh.organism_idx 
   join organisms_of_interest oi on oi.organism_idx=o.id
   join genes_ko gk on gk.gene_id=kh.hit_id 
   where kh.tag=(select ht.id from hit_tags ht where ht.tag_description=",
   shQuote(tag),
   ") and gk.ko_id=",
   shQuote(ko_id)," and oi.tag='sulfur_cycle_SR' ",
   "group by kh.organism_idx order by cnt desc limit 1;",sep=""))
  if(dim(recordset)[1]>0){
    res = as.vector(t(recordset))
    if(length(recordset)>1){
      sequence = recordset[1:1]
    }
  }
  sequence
}


organisms("DNA_130","ko:K00001")

dim(res)

sets=colnames(res[,2:49])
kos = res[,1]

for(set in sets){
  ktmp=cbind(as.matrix(kos,ncol=1),rep("",length(kos)))
  org_list=t(apply(ktmp,1,function(x){ c(x[1], as.character(unlist(organisms(set, x[1]))))}))
  colnames(org_list)=c("ko_id",set)
  tmp=merge(tmp,org_list,by.x=c("ko_id"),by.y=c("ko_id"),all=T)
  write.table(tmp,file="SR_org_table_final3_progress.csv", quote=T, col.names=T, row.names=F, sep="\t")
}

res3=merge(res2, tmp, by.x=c("ko_id"), by.y=c("ko_id"), all=T)
write.table(res3,file="ko_desc_org_final.csv", quote=T, col.names=T, row.names=F, sep="\t")

########### KO definitions
data=read.csv(file="SO_org_table_final2.csv", as.is=T, sep="\t")
ko_def = function(ko_id) {
  res = dbGetQuery(session, paste("
  select ko_id, description from ko_description
  where ko_id=",shQuote(ko_id),";",sep=""))
  colnames(res)=c("ko_id","ko_description")
  res
}

ko_defs=t(apply(t(t(kos)),1,function(x){ as.character(unlist(ko_def(x[1])))}))
colnames(ko_defs)=c("ko_id","ko_definition")
res4=merge(res2, ko_defs, by.x=c("ko_id"), by.y=c("ko_id"), all=T)