#1 load 3 CSV files; one with the actual datapoints, and 2 (_norm and _denorm) which have the same colum/row structure, 
# but all cells are empty other than the Primary Key. These will be needed later to fill with normalized or denormalized datapoints.
setwd("/R_working_directory")
datapoints        <- read.csv("/csv_original.csv", header = TRUE, sep = ";", dec = ',', row.names = 1)
datapoints_norm   <- read.csv("/csv_empty_except_PK.csv", header = TRUE, sep = ";", dec = ',', row.names = 1)
datapoints_denorm <- read.csv("/csv_empty_except_PK.csv", header = TRUE, sep = ";", dec = ',', row.names = 1)

#2 define min() and max() of each column, to be used for later (de-)normalization
  # (only if Axes divert from 0-1 range; then subsequent functions will transform to 0-1 scale)
  # TIP: you might want to use an iterator if there are many columns
min_column1 <- min(datapoints$column1)
min_column2 <- min(datapoints$column2)
min_column3 <- min(datapoints$column3)
min_column4 <- min(datapoints$column4)
#...

max_column1 <- max(datapoints$column1)
max_column2 <- max(datapoints$column2)
max_column3 <- max(datapoints$column3)
max_column4 <- max(datapoints$column4)
#...

#3 define the (de)normalization functions
  # mathematical basis for your reference: https://en.wikipedia.org/wiki/Feature_scaling#Rescaling_(min-max_normalization)
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

denormalize <- function(x,min_x,max_x) {
  return (x * (max_x - min_x) + min_x)
}

#4 run datapoints thru functions; write result in prepared (empy but for PK; which would be column 0) container
datapoints_norm$column1<-normalize(datapoints$column1)
datapoints_norm$column2<-normalize(datapoints$column2)
datapoints_norm$column3<-normalize(datapoints$column3)
datapoints_norm$column4<-normalize(datapoints$column4)
#...

#5 run kmeans clustering package; and save results as object "clusterkx"
  # the number for k is the number of clusters you want the computer to define
  # we will later on decide which value of k is mathematically optimal
clusterk2 <- kmeans(datapoints_norm, 2, iter.max = 40, nstart = 20, trace = TRUE)
clusterk3 <- kmeans(datapoints_norm, 3, iter.max = 40, nstart = 20, trace = TRUE)
clusterk4 <- kmeans(datapoints_norm, 4, iter.max = 40, nstart = 20, trace = TRUE)
clusterk5 <- kmeans(datapoints_norm, 5, iter.max = 40, nstart = 20, trace = TRUE)
clusterk6 <- kmeans(datapoints_norm, 6, iter.max = 40, nstart = 20, trace = TRUE)
clusterk7 <- kmeans(datapoints_norm, 7, iter.max = 40, nstart = 20, trace = TRUE)
clusterk8 <- kmeans(datapoints_norm, 8, iter.max = 40, nstart = 20, trace = TRUE)
clusterk9 <- kmeans(datapoints_norm, 9, iter.max = 40, nstart = 20, trace = TRUE)
clusterk10 <- kmeans(datapoints_norm, 10, iter.max = 40, nstart = 20, trace = TRUE)
clusterk11 <- kmeans(datapoints_norm, 11, iter.max = 40, nstart = 20, trace = TRUE)
clusterk12 <- kmeans(datapoints_norm, 12, iter.max = 40, nstart = 20, trace = TRUE)
clusterk13 <- kmeans(datapoints_norm, 13, iter.max = 40, nstart = 20, trace = TRUE)
clusterk14 <- kmeans(datapoints_norm, 14, iter.max = 40, nstart = 20, trace = TRUE)
clusterk15 <- kmeans(datapoints_norm, 15, iter.max = 40, nstart = 20, trace = TRUE)
clusterk16 <- kmeans(datapoints_norm, 16, iter.max = 40, nstart = 20, trace = TRUE)
#...

#6 save the total variation for each k run (totss) in a variable "elbow chart"
elbow_chart <- transform(as.data.frame(clusterk2["tot.withinss"]))
elbow_chart$k3 <- transform(as.data.frame(clusterk3["tot.withinss"]))
elbow_chart$k4 <- transform(as.data.frame(clusterk4["tot.withinss"]))
elbow_chart$k5 <- transform(as.data.frame(clusterk5["tot.withinss"]))
elbow_chart$k6 <- transform(as.data.frame(clusterk6["tot.withinss"]))
elbow_chart$k7 <- transform(as.data.frame(clusterk7["tot.withinss"]))
elbow_chart$k8 <- transform(as.data.frame(clusterk8["tot.withinss"]))
elbow_chart$k9 <- transform(as.data.frame(clusterk9["tot.withinss"]))
elbow_chart$k10 <- transform(as.data.frame(clusterk10["tot.withinss"]))
elbow_chart$k11 <- transform(as.data.frame(clusterk11["tot.withinss"]))
elbow_chart$k12 <- transform(as.data.frame(clusterk12["tot.withinss"]))
elbow_chart$k13 <- transform(as.data.frame(clusterk13["tot.withinss"]))
elbow_chart$k14 <- transform(as.data.frame(clusterk14["tot.withinss"]))
elbow_chart$k15 <- transform(as.data.frame(clusterk15["tot.withinss"]))
elbow_chart$k16 <- transform(as.data.frame(clusterk16["tot.withinss"]))
#...


#7 extract this elbow chart, so we can visualize in excel and visually look for the "elbow"
write.csv(elbow_chart, file = "/elbow_chart.csv",row.names = FALSE)

#8 centroids of chosen k value (4 in this example) are entered into table
centertable <- transform(as.data.frame(clusterk4[["centers"]]))
centertable_denorm <- transform(as.data.frame(clusterk4[["centers"]]))

#9 denormalize centroid table
centertable_denorm$column1<-denormalize(centertable$column1,min_column1,max_column1)
centertable_denorm$column2<-denormalize(centertable$column2,min_column2,max_column2)
centertable_denorm$column3<-denormalize(centertable$column3,min_column3,max_column3)
centertable_denorm$column4<-denormalize(centertable$column4,min_column4,max_column4)
#...

#10 place assigned cluster of each Primary Key into table
cluster_pk<- transform(as.data.frame(clusterk4[["cluster"]]))

#write all results into csv's
write.csv(centertable, file         = "/centertable.csv",row.names = TRUE)
write.csv(centertable_denorm, file  = "/centertable_denorm.csv",row.names = TRUE)
write.csv(cluster_pk, file          = "/cluster_pk.csv",row.names = TRUE)
