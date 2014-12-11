#source("http://bioconductor.org/biocLite.R")
#biocLite("ShortRead")
library(reshape)
library(stringr)
library(plyr)
library(ShortRead)
require(RMySQL)
session <- dbConnect(MySQL(), host="XXX", db="YYY",user="ZZZ", password="QQQ")

reads=readFastq("reads.out.fq")

filenames=list.files(".",pattern="*.table")
samples=str_extract(filenames, "^(.*?)\\.")
samples=str_replace_all(samples,"R\\d|_|_\\d|\\.","")
classes_files=cbind(samples,filenames)

get_reads = function(row){
  sample = row[1]
  filename = row[2]
  if( file.info(filename)$size < 10 ){
    print(paste("! Skipping",sample, filename))
    NA
  }else{
    print(paste(sample, filename))    
    dat=read.table(filename,as.is=T)
    dat=cbind(rep(sample,length(dat$V1)),dat)
    names(dat) = c("sample","read_id","reference","identity","score")
    dat=data.frame(lapply(dat, as.character), stringsAsFactors=FALSE)
    dat$identity=as.numeric(dat$identity)
    dat$score=as.numeric(dat$score)
    dat
  }
}

dd=get_reads(classes_files[1,])
for(i in c(2:(length(classes_files[,1])))){
  row=classes_files[i,]
  tmp=get_reads(row)
  if(is.data.frame(tmp)){
    dd=rbind(dd,get_reads(row))
  }  
}

ids=as.vector(reads@id)
ids=str_replace_all(str_extract(ids, "^(.*?)\\t"), "\\t","")
seqs=as.vector(as.character(reads@sread))
rr=data.frame(read_id=ids,sequence=seqs, stringsAsFactors=FALSE)

res=merge(dd,rr,by=c("read_id"),all=T)

write.table(res,file="merA.csv", quote=T, col.names=T, row.names=F, sep="\t")

# saving the table
#
session <- dbConnect(MySQL(), host="test-mysql.toulouse.inra.fr", db="funnymat",user="funnymat", password="MathIsFunny")
#
sql_load_table2=cbind(dd$sample,dd$read_id,dd$reference,dd$identity,dd$score)
write.table(sql_load_table2,file="merA.load2.txt", quote=F, col.names=F, row.names=F, sep="\t")
#LOAD DATA LOCAL INFILE '/work/psenin/fm/KEGG_works/marisol/merB/merB.load2.txt' INTO table merB_hits FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n';
#
#
sql_load_table1=unique(cbind(dd$reference))
sql_load_table1=cbind(seq(1:length(sql_load_table1)),sql_load_table1)
write.table(sql_load_table1,file="merB.load1.txt", quote=F, col.names=F, row.names=F, sep="\t")
#LOAD DATA LOCAL INFILE '/work/psenin/fm/KEGG_works/marisol/merB/merB.load1.txt' INTO table merB FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n';

references <- dbGetQuery(session, "select distinct(name) from merA")
samples <- dbGetQuery(session, "select distinct(tag) from merA_hits")
grid <- expand.grid(sample=as.character(unlist(samples)), reference=as.character(unlist(references)))
grid <- cbind(as.character(grid$sample), as.character(grid$reference))

sample_summary = function(X) {
  sample = X[1]
  reference = X[2]
  res = dbGetQuery(session, 
    paste("select count(*) from merA_hits where tag=",shQuote(sample),
         " AND subject_id=",shQuote(reference),";",sep=""))
  as.numeric(res)
}

dd=apply(grid,1,sample_summary)
res=data.frame(sample=grid[,1],col=grid[,2],value=as.numeric(dd),stringsAsFactors=F)
ft=cast(res,col~sample)
names(ft)=c("reference",as.character(unlist(samples)))
write.table(ft,file="merA_table.csv", quote=F, col.names=T, row.names=F, sep="\t")
