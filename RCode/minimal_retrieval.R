#ged libraries
require(SRAdb)
require(RSQLite)

# get connected to local DB copy
sqlfile <- "SRAmetadb.sqlite"
sra_con <- dbConnect(SQLite(),sqlfile)

# select RUNS
rs <- dbGetQuery(sra_con, 
                 "SELECT ROUND((bases/spots)) AS SpotLength, sra.* 
                 FROM sra WHERE (taxon_id=9031 OR taxon_id=208526) 
                 AND UPPER(library_source)=\"TRANSCRIPTOMIC\" 
                 AND UPPER(library_layout) LIKE \"%PAIRED%\" 
                 AND UPPER(instrument_model) LIKE \"%HISEQ%\" 
                 AND SpotLength>=200.0;")

# get the links to SRA files with ASPERA
fasp = listSRAfile(rs$run_accession,sra_con=sra_con,fileType="fastq",srcType="fasp")

## Download sra FASTQ file using ASPERA protocol:
ascpCMD <- "/usr/local/bioinfo/src/Aspera/current/bin/ascp -i /usr/local/bioinfo/src/Aspera/current/etc/asperaweb_id_dsa.openssh -QT -l 500m"
for(f in rs$run_accession){
  
  print(paste("Run ",f,"; current time: ",format(Sys.time(), "%D %H:%M:%S"),sep=""))
  
  if( 0 == length(list.files(path = ".", pattern = paste("^",f,".*gz$",sep=""))) ){
    
    res <- try( getFASTQfile(f, srcType="fasp", ascpCMD=ascpCMD) )
    if("try-error" %in% class(res)) print(paste(res))
    Sys.sleep(10)
    
    res <- try( getSRAfile(f, sra_con = sra_con, destDir = getwd(), fileType = "sra" ) )
    if("try-error" %in% class(res)){
      print(paste(res))  
    }else{
      system ( paste("fastq-dump ",f,".sra",sep=""))
    }
    
  }else{
    print(paste("Run ",f," found, iterating further", sep=""))  
  }
  
}
