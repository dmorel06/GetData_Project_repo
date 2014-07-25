Getting and Cleaning Data Course Project README file
========================================================
All files and code produced in RStudio version(0.98.507)  

This file takes you from the process of acquiring the data through to the production of the tidy data file posted on the course website.

1. Download file archive (.zip) and extract the "UCI HAR Dataset" directory 
---------------------------------------------------------------------------
Note: The Dataset directory is available in the project reposity in Github so the code is commented out.


```r
#fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(fileURL,destfile="UCI HAR Dataset.zip")
#unzip("UCI HAR Dataset.zip", files = NULL, exdir = ".", unzip = "internal")
```

### Background information: 
(selectively copied from the README.txt file included in the data directory) 

>The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

>The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

>For each record it is provided:

>- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
>- Triaxial Angular velocity from the gyroscope. 
>- A 561-feature vector with time and frequency domain variables. 
>- Its activity label. 
>- An identifier of the subject who carried out the experiment.

>The dataset includes the following files:

>- 'README.txt'
>- 'features_info.txt': Shows information about the variables used on the feature vector.
>- 'features.txt': List of all features.
>- 'activity_labels.txt': Links the class labels with their activity name.
>- 'train/X_train.txt': Training set.
>- 'train/y_train.txt': Training labels.
>- 'test/X_test.txt': Test set.
>- 'test/y_test.txt': Test labels.

>The following files are available for the train and test data. Their descriptions are equivalent. 

>- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

>Notes: 

>- Features are normalized and bounded within [-1,1].
>- Each feature vector is a row on the text file.

2. Read all appropriate files in 'data.table' objects
-----------------------------------------------------
### a. read rubric for variable names (561-feature vector):


```r
features<-read.table("UCI HAR Dataset/features.txt",header=FALSE)
```

### b. read data from both test and train files: 
Column names are assigned per the 'features' data.table above.


```r
test_data<-read.table("UCI HAR Dataset/test/X_test.txt",header=FALSE,col.name=as.character(features[,2]))
train_data<-read.table("UCI HAR Dataset/train/X_train.txt",header=FALSE,col.name=as.character(features[,2]))
```

### c. read activity codes that match observations in data files, add column name:


```r
id_test<-read.table("UCI HAR Dataset/test/y_test.txt",header=FALSE,col.names="Activity")
id_train<-read.table("UCI HAR Dataset/train/y_train.txt",header=FALSE,col.names="Activity")
```

### d. read subject info that matches each observation in data files, add column name:


```r
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt",header=FALSE,col.names="Subject")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt",header=FALSE,col.names="Subject")
```

3. Merge test/training files pairwise in the same order 
-----------------------------------------------------------------
### (step 1 in project description)

Protects the relationship between subject-activity-measurements


```r
merged_data<-rbind(test_data,train_data)            ## collected data
merged_id<-rbind(id_test,id_train)                  ## activity codes
merged_subject<-rbind(subject_test,subject_train)   ## subject info
```
4. Extract only the measurements of the mean and standard deviation
-------------------------------------------------------------------
### (step 2 in project description)

using the 'features' data.table, identify the variable names of interest 
(mean and std) by keeping only these columns. See the CodeBook.md file for selection criteria.


```r
feat <- grep("*-mean\\(|-std\\(*", features[,2])
```

The subset of variable names 'feat' can then be used to reduce the merged_data set to a trimmed_data set containing only the observations associated with the variables of interest.


```r
trimmed_data<-merged_data[,feat]
```

To complete the data set, add columns with the activity codes and subject info


```r
trimmed_data<-cbind(merged_subject, trimmed_data)
trimmed_data<-cbind(merged_id, trimmed_data)
```

At this point the trimmed_data table contains activity, subject, and mean/standard deviation data only.  
The data table contains 10299 obs. of 66 variables + activity + subject (= 68 cols)

5. Activity names
-----------------
### (step 3 in the project description)

To improve readability, replace the numeric activity codes by a descriptive name based on the rubric available in the dataset directory (activity_labels.txt).


```r
trimmed_data$Activity<-gsub(1,"walking",trimmed_data$Activity)
trimmed_data$Activity<-gsub("2","walking_up",trimmed_data$Activity)
trimmed_data$Activity<-gsub("3","walking_down",trimmed_data$Activity)
trimmed_data$Activity<-gsub("4","sitting",trimmed_data$Activity)
trimmed_data$Activity<-gsub("5","standing",trimmed_data$Activity)
trimmed_data$Activity<-gsub("6","laying",trimmed_data$Activity)
```
6. Variable names
-----------------
### (step 4 in project description)

Clean up the variable names (col names) by standardizing the formatting while respecting the original names assigned by the research team. This will minimize confusion in the documentation. Each change is shown here individually for clarity. The final data table has column names without spaces or special characters, with a capital letter at the start of each word, and lower case letters otherwise. See CodeBook.md for the full list of variables.


```r
colnames(trimmed_data)<-gsub("\\.","",colnames(trimmed_data))
colnames(trimmed_data)<-gsub("BodyBody","Body",colnames(trimmed_data))
colnames(trimmed_data)<-gsub("tBody","TimeBody",colnames(trimmed_data))
colnames(trimmed_data)<-gsub("fBody","FrequencyBody",colnames(trimmed_data))
colnames(trimmed_data)<-gsub("tGravity","TimeGravity",colnames(trimmed_data))
colnames(trimmed_data)<-gsub("mean","Mean",colnames(trimmed_data))
colnames(trimmed_data)<-gsub("std","Std",colnames(trimmed_data))
```

At this point, all files manipulations are complete and the data set is tidy.

The last steps in the project involve data manipulation and output only.

7. Averages 
-----------
### (step 5 in project description)

Create a second data set with averages of each variable for each activity type for each subject.The average (mean function in R) is obtained via R's aggregate function, which splits the trimmed_data set into subsets (per subject for each type of activity) and computes the average of each variable in the corresponding subset across all columns. The results are stored in the 'tidy_data' data frame, leaving the trimmed_data data table unchanged.


```r
tidy_data<-aggregate(.~Subject+Activity, data=trimmed_data, mean, na.rm=TRUE)
```
8. Output
---------
Write the tidy_data table to a text file that can be read across platforms. This file can then be used to produce formatted output (pdf, csv, html, etc.) as required. For this project, the text file was read with MS excel then saved in pdf format before submission to the course website as "tidy_data.pdf".


```r
write.table(tidy_data,"tidy_data.txt",row.names=FALSE)
```
See the run_analysis.R file for executable code and the CodeBook.md for additional details.

end
