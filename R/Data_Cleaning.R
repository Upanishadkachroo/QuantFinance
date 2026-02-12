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