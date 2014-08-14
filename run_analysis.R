library(data.table)
library(reshape2)

read_file <- function(rootPath,filename,names) {
	if (length(names)==0)
	{
		data <- read.table( paste(rootPath,filename,sep=""), header=FALSE, sep = "");
	}
	else
	{
		data <- read.table( paste(rootPath,filename,sep=""), header=FALSE, sep = "", col.names=names);
	}
	data
}

load_data_set <- function(rootPath,name,activityLables,features,keyFeatures) {
	subjectData <- read_file(rootPath,paste("/",name,"/subject_",name,".txt",sep=""),c("id"));
	activityData <- read_file(rootPath,paste("/",name,"/y_",name,".txt",sep=""),c("id"));
	vectorData <- read_file(rootPath,paste("/",name,"/x_",name,".txt",sep=""),features$name);
	vectorData <- vectorData[,keyFeatures];
	vectorData["set"] <- name;
	vectorData["subject"] <- subjectData$id;
	vectorData["activity"] <- sapply(activityData$id,function(id){activityLables$name[id]});
 
	vectorData
}

is_mean_or_std <- function(name) {
	grep("_mean_",name)>0 || grep("_std_",name)>0
}

get_feature_key <- function(features) {
	Filter(is_mean_or_std,features$name);
}

trans_for_variable_name <- function(name) {
	name <- tolower(name);
	name <- gsub("[-]","_",name);
	name <- gsub("[(][)]","_",name);
	name <- gsub("[(]","_",name);
	name <- gsub("[)]","",name);
	name <- gsub("[,]","_",name);
	name <- gsub("__","_",name);
}

run_analysis <- function() {
	rootPath <- "./UCI HAR Dataset";
	activityLables <- read_file(rootPath,"/activity_labels.txt", c("id","name") );
	features <- read_file(rootPath,"/features.txt", c("id","name") );
	features$name <- sapply(features$name,trans_for_variable_name);

	keyFeatures <- get_feature_key(features);

	dataSetTest <- load_data_set(rootPath,"test",activityLables,features,keyFeatures);
	dataSetTrain <- load_data_set(rootPath,"train",activityLables,features,keyFeatures);
	dataSet <- data.table( rbind(dataSetTest,dataSetTrain) );

	dataFeatureSet <- melt(dataSet,id=c("subject","activity"),measure.vars=keyFeatures)
	meanSet <- dataFeatureSet[,mean(value),by=c("variable","subject","activity")]
	setnames(meanSet,"V1","mean")
	meanSet
}

