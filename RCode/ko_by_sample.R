#
# Produces the table for taxonomic affiliation of a KO
#
# =============================================================================
#
options(echo=TRUE) # we want see commands in output file

# [0.0] get connected
#
require(RMySQL)
session <- dbConnect(MySQL(), host="test-mysql.toulouse.inra.fr", 
                     db="funnymat",user="funnymat", password="XXX")

# [0.1] check that KO is given in a command line and exists in DB
#
args <- commandArgs(trailingOnly = TRUE)
print(paste("CLI arguments: ",args))
if(length(args) != 1){
  # no arguments provided
  stop(paste("Please provide a ko id"))
}

ko_id <- as.character(args[1])
ko_check <- dbGetQuery(session, 
              paste("select * from ko_description where ko_id=",shQuote(ko_id),sep=''))
if(dim(ko_check)[1] == 0 || dim(ko_check)[1] > 1){
  # empty record set or ambiguous is retrieved
  stop(paste("Something wrong with ko id", shQuote(ko_id)))
}


# [1.0]
# get all samples
#
tags <- dbGetQuery(session, "select * from hit_tags")

# this is how we get abundance of KO per sample, three joins
#
ko_summary = function(tag, ko_id) {
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

# instantiate the result table 
#
print(paste("processing set ", ko_id, tags[1,1],tags[1,2]))
res <- ko_summary(tags[1,1], ko_id)
names(res)[length(names(res))] = paste(tags[1,2])
  
# iterate over samples merging abundance counts as a column
#
for(i in c(2:(length(tags$id))) ){
  tag=tags[i,] 
  print(paste(format(Sys.time(), "%a %b %d %X %Y"), ", processing set ", ko_id, tag[1],tag[2]))
  summary=ko_summary(tag[1],ko_id)
  # merge it here
  res=merge(res, summary, by.x=c("code","tnum","name","lineage"), 
            by.y=c("code","tnum","name","lineage"), all=T)
  names(res)[length(names(res))] = paste(tag[2])
  # save the progress
  fname=paste(gsub(":","_",ko_id),"_progress_2.csv",sep="")
  write.table(res,file=fname, quote=T, col.names=T, row.names=F, sep="\t")
}

# save the final results per KO
fname=paste(gsub(":","_",ko_id),"_2.csv",sep="")
write.table(res,file=fname, quote=T, col.names=T, row.names=F, sep="\t")
