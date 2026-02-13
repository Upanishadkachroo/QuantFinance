#data handling and cleaning
Data=read.csv("salary.csv")
dim(Data)

summary(Data)
brief(Data)
head(Data, 8)
str(Data)
colnames(Data)

#changing names
colnames(Data)[]="Name"
colnames(Data)[2:4]=c('Title', 'ID', "AgencyName")
head(Data)


#cleaning the dataframe
x=c(0, NA, 2, 3, 4, -0.5, 0.2)
x
x>2

is.na(NA)

x>2 & !is.na(NA)

(x==0 | x==2) & !is.na(NA)

is.nan(0/0)
is.infinite(1/0)

head(Data)
Data_1=Data #copy of data

is.nan(Data_1)

Data_1[1000, 5]=NA
Data_1[3000, 2]=NA
Data_1[4000, 3]=NA

all(!is.na(Data_1))

Data_1[is.na(Data_1)]=0
sum(is.na(Data_1))

DF=data.frame(a=c(NA, 1, 2), b=c("ONE", NA, "Three"))
DF
subset(DF, !is.na(a))
subset(DF, !is.na(b))

#to remove all Na
subset(DF, complete.cases(DF))
na.omit(DF)

###
library(car)
head(Freedman)
str(Freedman)
summary(Freedman)
rm(Freedman)

median(Freedman$density)
median(Freedman$density, na.rm=T)

mean(Freedman$density)
mean(Freedman$density, na.rm=T)

Freedman.good=na.omit(Freedman)
summary(Freedman.good)

Freedman_notav=Freedman[!complete.cases(Freedman),]
Freedman_notav

####
library(usingR)

x=babies$dwt
summary(x)
x[x==999]=NA
range(X)
summary(X)
range(X, na.rm=T)


##Removal of non unique columns
head(Data)
Data_2=Data_2
dim(Data_2)

Data_3=rbind.data.frame(Data_2, Data_2[1:1500, ])
dim(Data_3)

Data_4=unique(Data_3)


##selection of columns and rows
head(iris)
iris[,3]
head(iris[,3])

iris[, c[3:5]]
head(iris[, c[3:5]])
iris[c(4:10), c(3:5)]

#creation of new variable
iris$Petal.Ratio= iris$Petal.Length/iris$Petal.Width
iris$Sepal.Ratio= iris$Sepal.Length/iris$Sepal.Width
head(iris)

##extracting obs
iris[iris$Petal.Width>0.5 & iris$Species=="setosa",]

subset(iris, Petal.Width>0.5 & Species=="setosa")

library(car)

dim(Davis)
head(Davis)

output=data.frame(matrix(nrow=dim(Davis)[1], ncol=dim(Davis)[2]))

dim(output)
head(output)


##transform data frma across long and wide formats
Speed.1=c(850, 740, 400, 500, 600)
Speed.2=c(820, 740, 100, 530, 690)
Speed.3=c(720, 140, 900, 230, 790)
Speed.4=c(120, 740, 200, 930, 590)
id=c(1,2,3,4,5)
Run=c("A", "B", "C", "D", "E")

Speed=cbind.data.frame(id, Run, Speed.1, Speed.2, Speed.3, Speed.4)
head(Speed)
summary(Speed)
str(Speed)
library(reshape2)

long =melt(Speed, id.vars=names(Speed)[1:2, variable.name="Speed"])
head(long, 10)



wide=dcast(long, id+Run ~Speed)
head(wide)


##merging data frames
v1=c("The avengers", "darks kingt", "skygall", "joker")
v2=c(23344, 344334, 13234, 9483332)
domestic=cbind.data.frame(v1, v2)
head(domestic)
colnames(domestic)=c("Name", "Domestic")
head(domestic)

v3=c("The avengers", "darks kingt", "skygall", "momento")
v4=c(221334, 45312323, 23432312, 21313)

foreign=cbind.data.frame(v3, v4)
head(foreign)
colnames(foreign)=c("name", "foreign")
head(foreign)

Final=merge(domestic, foreign, by.x="name", by.y="name")
head(Final)

colnames(foreign)=c("name", "foreign")
Final=merge(domestic, foreign, by="name")
head(Final)
