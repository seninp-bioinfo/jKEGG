require(VennDiagram)
require(RMySQL)
require(ggplot2)
require(Cairo)
require(grid)
library(gridExtra)

get_table = function(len){
  res = dbGetQuery(session, paste(
        "select tag, count(distinct(query_id)) from aligners_comparison where aln_length>=",
        len," group by tag",sep=""))
  res
}

session <- dbConnect(MySQL(), host="localhost", 
                     db="funnymat",user="funnymat", password="XXX")

get_table(0)
