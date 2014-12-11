# get connected
#
require(RMySQL)
session <- dbConnect(MySQL(), host="XXX", db="YYY",user="ZZZ", password="QQQ")

# get all samples
#
tags <- dbGetQuery(session, "select * from hit_tags")

# define KO of interest
#
kos=c("ko:K02470")

# this is how we get abundance of KO per sample, three joins
#
ko_summary = function(tag,ko_id) {
  res = dbGetQuery(session, paste("
         select org.code, org.tnum, org.name, org.lineage, count(kh.hit_id) from kegg_hits kh
         join organisms org on org.id=kh.organism_idx
         join genes_ko gk on gk.gene_idx=kh.gene_idx
         where gk.ko_id=",shQuote(ko_id)," and kh.tag=",tag," group by org.code;",sep=""))
  # take care about an empty record set
  #
  if(length(res)==0){
    res=matrix(rep(NA,5),ncol=5)
  }
  colnames(res)=c("code","tnum","name","lineage","count")
  res
}

# loop over KOs
#
for(ko_id in kos){
  
  # instantiate the result table 
  #
  print(paste("processing set ", ko_id, tags[1,1],tags[1,2]))
  res <- ko_summary(tags[1,1], ko_id)
  names(res)[length(names(res))] = paste(tags[1,2])
  
  # iterate over samples merging abundance counts as a column
  #
  for(i in c(2:(length(tags$id))) ){
    tag=tags[i,] 
    print(paste("processing set ", ko_id, tag[1],tag[2]))
    summary=ko_summary(tag[1],ko_id)
    # merge it here
    res=merge(res, summary, by.x=c("code","tnum","name","lineage"), by.y=c("code","tnum","name","lineage"), all=T)
    names(res)[length(names(res))] = paste(tag[2])
    # save the progress
    fname=paste(gsub(":","_",ko_id),"_progress_2.csv",sep="")
    write.table(res,file=fname, quote=T, col.names=T, row.names=F, sep="\t")
  }
  # save the final results per KO
  fname=paste(gsub(":","_",ko_id),"_2.csv",sep="")
  write.table(res,file=fname, quote=T, col.names=T, row.names=F, sep="\t")
}
