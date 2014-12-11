# for file in *.blastx.gz; do echo $file; b=$(zcat $file | grep -c "Query= "); echo $b; done;
# grep 'blastx' stat.txt >1.txt
# grep -v 'blastx' stat.txt >2.txt
# paste 1.txt 2.txt | sed 's/.blastx.gz//g' | sed 's/_R2.kegg/R2/g' | sed 's/_R1.kegg/R1/g' >final_stat.txt
require(stringr)
require(RMySQL)

session <- dbConnect(MySQL(), host="XXX", db="YYY",user="ZZZ", password="QQQ")


data=read.table(file='final_stat.txt',header=F,as.is=T)
names(data)=c("sample","count")
data$rpos=apply(data,1,function(x){max(unlist(str_locate_all(pattern ='R',x[1])))})
data$key=apply(data,1,function(x){unlist(str_sub(x[1],end=as.numeric(x[3])-1))})
data[data$key=="DNA1702",]$key="DNA170"
data[data$key=="DNA3042",]$key="DNA304"
data[data$key=="DNA3052",]$key="DNA305"
reduced_data=aggregate(count~key,data,FUN=sum)
reduced_data$dpos=apply(reduced_data,1,function(x){min(unlist(str_locate(pattern ='\\d',x[1])))})
reduced_data$db_key=apply(reduced_data,1,function(x){paste(str_sub(x[1],end=as.numeric(x[3])-1),"_",str_sub(x[1],start=as.numeric(x[3])),sep="")})

sample_reads = function(tag_description) {
  res = dbGetQuery(session, paste("
  select raw_reads as aligned from hit_tags
  where tag_description=",shQuote(tag_description),";",sep=""))
  res
}
reduced_data$aligned_reads=apply(reduced_data,1,function(x){unlist(sample_reads(x[4]))})

res=reduced_data[,c(4,5,2)]
names(res)=c("sample","total_reads","aligned_reads")

write.table(res,file="hcgA_alignment_summary.csv", quote=T, col.names=T, row.names=F, sep="\t")
