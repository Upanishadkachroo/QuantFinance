#arthmetic operator
a=3
a

log(100, 2)
?log

#vector creation
c() seq()

#creation of vector
c(1,2,3,4)
v=c(1,2,3,4)
v
head(v)
tail(v)

5:13
v1=5:13
v1
v=3.8:11.8
v

seq(5, 9, by=0.4)
seq(0, 1, by=0.1)

#vector multiplication
v3=c(2,3,4,8,9)
v4=c(1,0,7,5,7)
v3+v4

v4-v3

v3*v4

#vector element recycling
v5=c(1,2,7,4)
v6=c(6,0)
v6+v5

#vector element sorting
sort(v)
sort(v, decreasing = T)

#indexing of vector
v[5]
v[0:3]
v[-c(1:4)]


#data types in R
y=5
class(y)
class(c("1", "2"))

v2=c("my", "name", "is", "rythm")
class(v2)
summary(v2)
nchar(v2)

#factor variables in R
v7=as.factor(c("M", "F", "F", "M", "F", "F", "F", "M", "F", "F", "F", "M", "F"))
class(v7)
v7
summary(v7)


#user defined function
x=c(1,2,4,5,6,7,8,9,0)
mean(x)

sum(x)/length(x)

mymean=function(y){
  sum(y)/length(y)
}
mymean(x)

mysd=function(z){
  sqrt(sum((x-mymean(x))^2)/(length(x)-1))
}
mysd(x)
sd(x)

#conditional statements
#ifelse(condition, expression1, expression2)
Gender=c("M", "F", "F", "M", "F", "F")
ifelse(Gender=='M', print("Male"), print('Female'))
length(Gender)

for(i in 1: length(Gender)){
  ifelse(Gender[i]=="M", print("Male"), print('Female'))
}


