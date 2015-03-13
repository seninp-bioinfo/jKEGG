require(reshape)
require(scales)
require(Cairo)
require(ggplot2)
require(grid)
require(gridExtra)

forward=read.table("data/R1.stats",header=T)
reverse=read.table("data/R2.stats",header=T)

dm=melt(forward,id.var=c("Len"))
p = ggplot(dm, aes(x=Len,y=value,color=variable)) + geom_line() + 
  ggtitle("Percentage of FORWARD reads retained by selecting cutoff Q and Len, TOTAL 2828656 reads")
p

forward=read.table("data/R1.stats",header=T)
reverse=read.table("data/R2.stats",header=T)

dm=melt(forward[,c(1,3)],id.var=c("L"))
str(dm)
p = ggplot(dm, aes(x=L,y=value,color=variable)) + geom_line() + 
  ggtitle("Average read Quality after filtering by E value")
p


dm=melt(reverse,id.var=c("Len"))
p1 = ggplot(dm, aes(x=Len,y=value,color=variable)) + geom_line() + 
  ggtitle("Percentage of REVERSE retained by selecting cutoff Q and Len")
p1

print(arrangeGrob(p,p1,ncol=1))
