require("VennDiagram")
require(RMySQL)
require(reshape)
session <- dbConnect(MySQL(), host="localhost", 
                     db="funnymat",user="funnymat", password="MathIsFunny")

last_hits = dbGetQuery(session, "select ko_id, count(*) cnt from aligners_score where tag=\"LAM\" and ko_id is NOT NULL group by ko_id order by cnt DESC limit 10;")
last_hits$rank=1:10
blast_hits = dbGetQuery(session, "select ko_id, count(*) cnt from aligners_score where tag=\"BM\" and evalue<0.01 and ko_id is NOT NULL group by ko_id order by cnt DESC limit 10;")
blast_hits$rank=1:10
diamond_hits = dbGetQuery(session, "select ko_id, count(*) cnt from aligners_score where tag=\"DSM\" and ko_id is NOT NULL group by ko_id order by cnt DESC limit 10;")
diamond_hits$rank=1:10
lambda_hits = dbGetQuery(session, "select ko_id, count(*) cnt from aligners_score where tag=\"LSM\" and ko_id is NOT NULL group by ko_id order by cnt DESC limit 10;")
lambda_hits$rank=1:10
pauda_hits = dbGetQuery(session, "select ko_id, count(*) cnt from aligners_score where tag=\"PSM\" and ko_id is NOT NULL group by ko_id order by cnt DESC limit 10;")
pauda_hits$rank=1:10

dd=merge(blast_hits,last_hits, by="ko_id",all=T,suffixes = c(".blast",".last"))
dd=merge(dd,diamond_hits, by="ko_id",all=T)
dd=merge(dd,lambda_hits, by="ko_id",all=T,suffixes = c(".diamond",".lambda"))
dd=merge(dd,pauda_hits, by="ko_id",all=T)
names(dd)=c("ko_id","blast.abd","blast.rank","last.abd","last.rank","diamond.abd","diamond.rank",
            "lambda.abd","lambda.rank","pauda.abd","pauda.rank")
dd = dd[with(dd, order(blast.rank)), ]

id2desc = function(ko_id){
  as.character(unlist(dbGetQuery(session, paste("select description from ko_description where ko_id=",shQuote(ko_id),";",sep=''))))
}  
desc=apply(as.matrix(dd$ko_id),1,id2desc)
dd$ko_id = desc

g1<-tableGrob(
  format(dd, digits = 1,
         scientific=F,big.mark = ","),
  core.just="left",
  #core.just="right",
  #col.just="right",
  gpar.coretext=gpar(fontsize=11), 
  gpar.coltext=gpar(fontsize=11, fontface='bold'), 
  show.rownames = F,
  h.even.alpha = 0,
  gpar.rowtext = gpar(col="black", cex=0.7,
                      equal.width = TRUE,
                      show.vlines = TRUE, 
                      show.hlines = TRUE,
                      separator="grey")                     
)

grid.newpage()
grid.draw(g1)

png(filename = "table_expression_MRNA_KO.png", width=1000, height=400, pointsize = 18);
grid.draw(g1)
dev.off();




#Extract Legend
g_legend <- function(a.gplot){
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)}
legend <- g_legend(p)

grid.newpage()
vp1 <- viewport(width = 0.75, height = 1, x = 0.375, y = .5)
vpleg <- viewport(width = 0.25, height = 0.5, x = 0.85, y = 0.75)
subvp <- viewport(width = 0.2, height = 0.2, x = 0.8, y = 0.7)
print(p + opts(legend.position = "none"), vp = vp1)
upViewport(0)
pushViewport(vpleg)
grid.draw(legend)
#Make the new viewport active and draw
upViewport(0)
pushViewport(subvp)
grid.draw(my_table)


id2desc = function(org_id){
  as.character(unlist(dbGetQuery(session, paste("select name from organisms where code=",shQuote(org_id),";",sep=''))))
}  
desc=apply(as.matrix(dd$org_id),1,id2desc)

df=melt(dd)

p=ggplot(df,aes(x=org_id,y=value,fill=variable)) + geom_bar(position="dodge") + 
  scale_x_discrete(labels=desc) + theme(axis.text.x = element_text(angle = 70, hjust = 1, vjust=1))+
  ggtitle("Top 10 most abundant organisms compared by aligner, mRNA")
p

ggsave(arrangeGrob(p, ncol=1), width=180, height=180, units="mm",
       file="abundance-mRNA-ORG-score-all.png", dpi=100)

