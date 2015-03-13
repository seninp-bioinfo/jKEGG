data=read.csv("/home/psenin/tmp/fm/tblastx_test.overlaps",header=F,as.is=T,sep="\t",
              col.names=c("query","subject","overlap","zeros"))
hist(data$zeros/data$overlap)

plot(data$overlap, data$zeros, type="p")

length(unique(data$subject))
length(unique(data$query))

tmp=data[(data$zeros/data$overlap)>=0.8,]

length(unique(tmp$subject))
length(unique(tmp$query))


llist=read.csv("/home/psenin/tmp/fm/hcga_formatted.llist",header=F,as.is=T,sep=" ",
               col.names=c("query","length"))
tmp=merge(llist,tmp,by.x="query",by.y="query",all.y=T)
head(tmp)

tmp=tmp[(tmp$overlap/tmp$length)>=0.8,]
length(unique(tmp$subject))
length(unique(tmp$query))
plot(tmp$overlap, tmp$zeros, type="p")
plot(tmp$length, tmp$overlap, type="p")

write.table(unique(tmp$subject),file="/home/psenin/tmp/fm/unique_subjects.list", quote=F, col.names=F, row.names=F, sep="\t")
write.table(unique(tmp$query),file="/home/psenin/tmp/fm/unique_queries.list", quote=F, col.names=F, row.names=F, sep="\t")

unique(tmp$subject)
unique(tmp$query)

