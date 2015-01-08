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

common5 = intersect(blast_hits, intersect(intersect(last_hits, diamond_hits), intersect(lambda_hits, pauda_hits)))

seq=paste("\"",paste(common5,collapse="\", \""),"\"",sep="")
blast_hits = dbGetQuery(session, paste("select org_id, count(*) cnt from aligners_score where tag=\"BM\" and evalue<0.01 and org_id in (",
                                       seq,") group by org_id order by cnt desc",sep=""))
last_hits = dbGetQuery(session, paste("select org_id, count(*) cnt from aligners_score where tag=\"LAD\" and org_id in (",
  seq,") group by org_id order by cnt desc",sep=""))
diamond_hits = dbGetQuery(session, paste("select org_id, count(*) cnt from aligners_score where tag=\"DSM\" and org_id in (",
                                         seq,") group by org_id order by cnt desc",sep=""))
lambda_hits = dbGetQuery(session, paste("select org_id, count(*) cnt from aligners_score where tag=\"LSM\" and org_id in (",
                                        seq,") group by org_id order by cnt desc",sep=""))
pauda_hits = dbGetQuery(session, paste("select org_id, count(*) cnt from aligners_score where tag=\"PSM\" and org_id in (",
                                       seq,") group by org_id order by cnt desc",sep=""))

