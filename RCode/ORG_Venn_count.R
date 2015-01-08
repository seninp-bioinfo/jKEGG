require(VennDiagram)
require(RMySQL)
require(ggplot2)
library(scales)
require(Cairo)
require(grid)
library(gridExtra)
library(gridBase)

session <- dbConnect(MySQL(), host="localhost", 
                     db="funnymat",user="funnymat", password="MathIsFunny")
threshold=0.00
blast_hits = as.vector(unlist(dbGetQuery(session, paste("select distinct(org_id) from aligners_score where tag=\"BM\" and normalized_score>",threshold," and evalue<0.01 order by org_id ASC",sep=""))))
last_hits = as.vector(unlist(dbGetQuery(session, paste("select distinct(org_id) from aligners_score where tag=\"LAM\" and normalized_score>",threshold," order by org_id ASC",sep=""))))
diamond_hits = as.vector(unlist(dbGetQuery(session, paste("select distinct(org_id) from aligners_score where tag=\"DSM\" and normalized_score>",threshold," order by org_id ASC",sep=""))))
lambda_hits = as.vector(unlist(dbGetQuery(session, paste("select distinct(org_id) from aligners_score where tag=\"LSM\" and normalized_score>",threshold," order by org_id ASC",sep=""))))
pauda_hits = as.vector(unlist(dbGetQuery(session, paste("select distinct(org_id) from aligners_score where tag=\"PSM\" and normalized_score>",threshold," order by org_id ASC",sep=""))))
write.table(blast_hits,file="blast.txt",quote=F,col.names=F,row.names=F)
write.table(last_hits,file="last.txt",quote=F,col.names=F,row.names=F)
write.table(diamond_hits,file="diamond.txt",quote=F,col.names=F,row.names=F)
write.table(lambda_hits,file="lambda.txt",quote=F,col.names=F,row.names=F)
write.table(pauda_hits,file="pauda.txt",quote=F,col.names=F,row.names=F)

area1 = length(blast_hits)
area2 = length(last_hits)
area3 = length(diamond_hits)
area4 = length(lambda_hits)
area5 = length(pauda_hits)

n12 = length(intersect(blast_hits, last_hits))
n13 = length(intersect(blast_hits, diamond_hits))
n14 = length(intersect(blast_hits, lambda_hits))
n15 = length(intersect(blast_hits, pauda_hits))

n23 = length(intersect(last_hits, diamond_hits))
n24 = length(intersect(last_hits, lambda_hits))
n25 = length(intersect(last_hits, pauda_hits))

n34 = length(intersect(diamond_hits, lambda_hits))
n35 = length(intersect(diamond_hits, pauda_hits))

n45 = length(intersect(lambda_hits, pauda_hits))

n123 = length(intersect(intersect(blast_hits, last_hits), diamond_hits))
n124 = length(intersect(intersect(blast_hits, last_hits), lambda_hits))
n125 = length(intersect(intersect(blast_hits, last_hits), pauda_hits))

n134 = length(intersect(intersect(blast_hits, diamond_hits), lambda_hits))
n135 = length(intersect(intersect(blast_hits, diamond_hits), pauda_hits))

n145 = length(intersect(intersect(blast_hits, lambda_hits), pauda_hits))

n234 = length(intersect(intersect(last_hits, diamond_hits), lambda_hits))
n235 = length(intersect(intersect(last_hits, diamond_hits), pauda_hits))

n245 = length(intersect(intersect(last_hits, lambda_hits), pauda_hits))

n345 = length(intersect(intersect(diamond_hits, lambda_hits), pauda_hits))

n1234 = length(intersect(intersect(blast_hits, last_hits), intersect(diamond_hits, lambda_hits)))
n1235 = length(intersect(intersect(blast_hits, last_hits), intersect(diamond_hits, pauda_hits)))

n1245 = length(intersect(intersect(blast_hits, last_hits), intersect(lambda_hits, pauda_hits)))

n1345 = length(intersect(intersect(blast_hits, diamond_hits), intersect(lambda_hits, pauda_hits)))

n2345 = length(intersect(intersect(last_hits, diamond_hits), intersect(lambda_hits, pauda_hits)))

n12345 = length(intersect(blast_hits, intersect(intersect(last_hits, diamond_hits), intersect(lambda_hits, pauda_hits))))


# Reference five-set diagram
venn.plot <- draw.quintuple.venn(
  area1 = area1,
  area2 = area2,
  area3 = area3,
  area4 = area4,
  area5 = area5,
  n12 = n12,
  n13 = n13,
  n14 = n14,
  n15 = n15,
  n23 = n23,
  n24 = n24,
  n25 = n25,
  n34 = n34,
  n35 = n35,
  n45 = n45,
  n123 = n123,
  n124 = n124,
  n125 = n125,
  n134 = n134,
  n135 = n135,
  n145 = n145,
  n234 = n234,
  n235 = n235,
  n245 = n245,
  n345 = n345,
  n1234 = n1234,
  n1235 = n1235,
  n1245 = n1245,
  n1345 = n1345,
  n2345 = n2345,
  n12345 = n12345,
  category = c("BLAST", "LAST", "DIAMOND", "LAMBDA", "PAUDA"),
  fill = c("dodgerblue", "goldenrod1", "darkorange1", "seagreen3", "orchid3"),
  cat.col = c("dodgerblue", "goldenrod1", "darkorange1", "seagreen3", "orchid3"),
  cat.cex = 2,
  margin = 0.05,
  cex = c(1.5, 1.5, 1.5, 1.5, 1.5, 1, 0.8, 1, 0.8, 1, 0.8, 1, 0.8, 1, 0.8,
          1, 0.55, 1, 0.55, 1, 0.55, 1, 0.55, 1, 0.55, 1, 1, 1, 1, 1, 1.5),
  ind = TRUE
);

plot.new() 
grid.draw(venn.plot)

# Writing to file
png(filename = "score_hits.png",width = 700, height = 650, pointsize = 12, type = "cairo");
grid.draw(venn.plot);
dev.off();


#============
a31 <- n12345
a30 <- n1234 - a31
a29 <- n1235 - a31
a28 <- n1245 - a31
a27 <- n1345 - a31
a26 <- n2345 - a31
a25 <- n245 - a26 - a28 - a31
a24 <- n234 - a26 - a30 - a31
a23 <- n134 - a27 - a30 - a31
a22 <- n123 - a29 - a30 - a31
a21 <- n235 - a26 - a29 - a31
a20 <- n125 - a28 - a29 - a31
a19 <- n124 - a28 - a30 - a31
a18 <- n145 - a27 - a28 - a31
a17 <- n135 - a27 - a29 - a31
a16 <- n345 - a26 - a27 - a31
a15 <- n45 - a18 - a25 - a16 - a28 - a27 - a26 - a31
a14 <- n24 - a19 - a24 - a25 - a30 - a28 - a26 - a31
a13 <- n34 - a16 - a23 - a24 - a26 - a27 - a30 - a31
a12 <- n13 - a17 - a22 - a23 - a27 - a29 - a30 - a31
a11 <- n23 - a21 - a22 - a24 - a26 - a29 - a30 - a31
a10 <- n25 - a20 - a21 - a25 - a26 - a28 - a29 - a31
a9 <- n12 - a19 - a20 - a22 - a28 - a29 - a30 - a31
a8 <- n14 - a18 - a19 - a23 - a27 - a28 - a30 - a31
a7 <- n15 - a17 - a18 - a20 - a27 - a28 - a29 - a31
a6 <- n35 - a16 - a17 - a21 - a26 - a27 - a29 - a31
a5 <- area5 - a6 - a7 - a15 - a16 - a17 - a18 - a25 - a26 - 
  a27 - a28 - a31 - a20 - a29 - a21 - a10
a4 <- area4 - a13 - a14 - a15 - a16 - a23 - a24 - a25 - a26 - 
  a27 - a28 - a31 - a18 - a19 - a8 - a30
a3 <- area3 - a21 - a11 - a12 - a13 - a29 - a22 - a23 - a24 - 
  a30 - a31 - a26 - a27 - a16 - a6 - a17
a2 <- area2 - a9 - a10 - a19 - a20 - a21 - a11 - a28 - a29 - 
  a31 - a22 - a30 - a26 - a25 - a24 - a14
a1 <- area1 - a7 - a8 - a18 - a17 - a19 - a9 - a27 - a28 - 
  a31 - a20 - a30 - a29 - a22 - a23 - a12

#==========
counts=c(a1+a2+a3+a4+a5, a6+a7+a8+a9+a10+a11+a12+a13+a14+a15, a16+a17+a18+a19+a20+a21+a22+a23+a24+a25, a26+a27+a28+a29+a30, a31)
dfbars = data.frame(t(counts))
names(dfbars)=paste(c(1:5))
str(dfbars)

area1+area2+area3+area4+area5
sum(dfbars[1,])
dm=melt(dfbars)

p=ggplot(dm, aes(x=variable, y=value, fill=variable)) + geom_bar(position="fill")
p
  geom_bar(stat='identity') +
  coord_flip() + theme_bw()
p


#==========
totals=c(area1, area2, area3, area4, area5)
dftotals = data.frame(t(totals))
names(dftotals)=c("BLAST","LAST","DIAMOND","LAMBDA","PAUDA")
dm=melt(dftotals)
p=ggplot(dm, aes(x=variable, y=value, fill=variable)) +
  geom_bar(stat='identity') + theme_bw()
p


png(filename = "venn_hit_score_00.png",width = 800, height = 480);
# start new page
plot.new() 

# setup layout
gl <- grid.layout(nrow=1, ncol=2,width=1)
# grid.show.layout(gl)

# setup viewports
vp.1 <- viewport(layout.pos.col=1, layout.pos.row=1) 
vp.2 <- viewport(layout.pos.col=2, layout.pos.row=1) 

pushViewport(viewport(layout=gl))

# access the first position
pushViewport(vp.1)

# start new base graphics in first viewport
grid.draw(venn.plot)

# done with the first viewport
popViewport()

# move to the next viewport
pushViewport(vp.2)

# print our ggplot graphics here
print(p, newpage = FALSE)

# done with this viewport
popViewport(1)

#grid.draw(venn.plot);
dev.off();
