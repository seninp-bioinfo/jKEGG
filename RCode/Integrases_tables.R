#source("http://bioconductor.org/biocLite.R")
#biocLite("ShortRead")

library(stringr)
library(plyr)
library(ShortRead)

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

write.table(res,file="integrases.csv", quote=T, col.names=T, row.names=F, sep="\t")





