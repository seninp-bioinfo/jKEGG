require("VennDiagram")
require(RMySQL)
session <- dbConnect(MySQL(), host="localhost", 
                     db="funnymat",user="funnymat", password="XXX")
threshold=95
blast_hits = as.vector(unlist(dbGetQuery(session, paste("select ko_id from aligners_similarity where tag=\"BD\" and identity>",threshold," order by hit_id ASC",sep=""))))
last_hits = as.vector(unlist(dbGetQuery(session, paste("select ko_id from aligners_similarity where tag=\"LAD\" and identity>",threshold," order by hit_id ASC",sep=""))))
diamond_hits = as.vector(unlist(dbGetQuery(session, paste("select ko_id from aligners_similarity where tag=\"DSD\" and identity>",threshold," order by hit_id ASC",sep=""))))
lambda_hits = as.vector(unlist(dbGetQuery(session, paste("select ko_id from aligners_similarity where tag=\"LSD\" and identity>",threshold," order by hit_id ASC",sep=""))))
pauda_hits = as.vector(unlist(dbGetQuery(session, paste("select ko_id from aligners_similarity where tag=\"PSD\" and identity>",threshold," order by hit_id ASC",sep=""))))

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

grid.draw(venn.plot)

png(filename = "venn_ko_similarity_95.png");
grid.draw(venn.plot);
dev.off();
