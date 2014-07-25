## Getting and Cleaning Data - Course Project
## all files and code produced in RStudio version(0.98.507) under Windows7

## download file archive (.zip) and extract the "UCI HAR Dataset" directory 

fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,destfile="UCI HAR Dataset.zip")
unzip("UCI HAR Dataset.zip", files = NULL, exdir = ".", unzip = "internal")

## read-in all appropriate files in 'data.table' objects

## rubric for variable names (i.e., column names in the data files)

features<-read.table("UCI HAR Dataset/features.txt",header=FALSE)

## measured data both 'test' and 'train' files. 
## column names are assigned per the 'features' data.table above.

test_data<-read.table("UCI HAR Dataset/test/X_test.txt",
                      header=FALSE,col.name=as.character(features[,2]))
train_data<-read.table("UCI HAR Dataset/train/X_train.txt",
                       header=FALSE,col.name=as.character(features[,2]))

## activity codes matching observations in data files, add column name

id_test<-read.table("UCI HAR Dataset/test/y_test.txt",
                    header=FALSE,col.names="Activity")
id_train<-read.table("UCI HAR Dataset/train/y_train.txt",
                     header=FALSE,col.names="Activity")

## subject info matching each observation in data files, add column name

subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt",
                         header=FALSE,col.names="Subject")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt",
                          header=FALSE,col.names="Subject")

## merge test/training files pairwise in the same order to protect 
## relationship between subject-activity-measurements

merged_data<-rbind(test_data,train_data)            ## collected data
merged_id<-rbind(id_test,id_train)                  ## activity codes
merged_subject<-rbind(subject_test,subject_train)   ## subject info

## using the 'features' data.table, identify the variables of interest 
## (mean and std) by keeping only those columns. 

feat <- grep("*-mean\\(|-std\\(*", features[,2])

## The subset of variable names can then be used to reduce the merged_data set 
## to a trimmed_data set containing only the observations associated with the
## variables of interest

trimmed_data<-merged_data[,feat]

## To complete the data set, add columns with the activity codes and subject info

trimmed_data<-cbind(merged_subject, trimmed_data)
trimmed_data<-cbind(merged_id, trimmed_data)

## At this point the trimmed_data file contains activity, subject, and 
## mean/std data only.
## The file contains 10299 obs. of 66 variables + activity + subject (68 cols)

## To improve readability, replace the activity codes by a descriptive names

trimmed_data$Activity<-gsub(1,"walking",trimmed_data$Activity)
trimmed_data$Activity<-gsub("2","walking_up",trimmed_data$Activity)
trimmed_data$Activity<-gsub("3","walking_down",trimmed_data$Activity)
trimmed_data$Activity<-gsub("4","sitting",trimmed_data$Activity)
trimmed_data$Activity<-gsub("5","standing",trimmed_data$Activity)
trimmed_data$Activity<-gsub("6","laying",trimmed_data$Activity)

## Clean up the variable names (col names) by standardizing the formatting
## while respecting the original names assigned by the research team to minimize
## confusion in the documentation

colnames(trimmed_data)<-gsub("\\.","",colnames(trimmed_data))
colnames(trimmed_data)<-gsub("BodyBody","Body",colnames(trimmed_data))
colnames(trimmed_data)<-gsub("tBody","TimeBody",colnames(trimmed_data))
colnames(trimmed_data)<-gsub("fBody","FrequencyBody",colnames(trimmed_data))
colnames(trimmed_data)<-gsub("tGravity","TimeGravity",colnames(trimmed_data))
colnames(trimmed_data)<-gsub("mean","Mean",colnames(trimmed_data))
colnames(trimmed_data)<-gsub("std","Std",colnames(trimmed_data))

## Finally, create a second data set with averages of each variable for each 
## activity type and each subject

tidy_data<-aggregate(.~Subject+Activity, data=trimmed_data, mean, na.rm=TRUE)

## Write the tidy_data table to a text file that can be read across platforms

write.table(tidy_data,"tidy_data.txt",row.names=FALSE)

## end of course project code