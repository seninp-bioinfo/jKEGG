require(ggplot2)

data=read.table("~/tmp/fm/marisol/hcgA.csv",sep="\t",as.is=T,header=T)

# all unique samples
#
length(unique(data$sample))
#
#
similarity=data$identity
p=ggplot(data,aes(x=similarity))+geom_histogram(identity=T,binwidth=1)+
  ggtitle("Identity of LAST hits for HCGA")
p


require(ggplot2)

data=read.table("~/tmp/fm/marisol/integrases.csv",sep="\t",as.is=T,header=T)

# all unique samples
#
length(unique(data$sample))
#
#
similarity=data$identity
p=ggplot(data,aes(x=similarity))+geom_histogram(identity=T,binwidth=1)+
  ggtitle("Identity of LAST hits for Integrases")
p
similarity[similarity>100]
