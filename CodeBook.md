Getting and Cleaning Data Course Project CodeBook
========================================================

Part 1. Feature Selection - from the orginal data documentation <br/>
Part 2. Modified labels and subset of data selected<br/>
Part 3. Calculations performed

Part 1. Feature Selection (original) 
------------------------------------
(copied from the 'features_info.txt' file available in the UCI HAR Dataset directory)

>The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

>Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

>Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

>These signals were used to estimate variables of the feature vector for each pattern:    
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ<br/>
tGravityAcc-XYZ<br/>
tBodyAccJerk-XYZ<br/>
tBodyGyro-XYZ<br/>
tBodyGyroJerk-XYZ<br/>
tBodyAccMag<br/>
tGravityAccMag<br/>
tBodyAccJerkMag<br/>
tBodyGyroMag<br/>
tBodyGyroJerkMag<br/>
fBodyAcc-XYZ<br/>
fBodyAccJerk-XYZ<br/>
fBodyGyro-XYZ<br/>
fBodyAccMag<br/>
fBodyAccJerkMag<br/>
fBodyGyroMag<br/>
fBodyGyroJerkMag<br/>

>The set of variables that were estimated from these signals are: 

mean(): Mean value<br/>
std(): Standard deviation<br/>
mad(): Median absolute deviation <br/>
max(): Largest value in array<br/>
min(): Smallest value in array<br/>
sma(): Signal magnitude area<br/>
energy(): Energy measure. Sum of the squares divided by the number of values.<br/> 
iqr(): Interquartile range <br/>
entropy(): Signal entropy<br/>
arCoeff(): Autorregresion coefficients with Burg order equal to 4<br/>
correlation(): correlation coefficient between two signals<br/>
maxInds(): index of the frequency component with largest magnitude<br/>
meanFreq(): Weighted average of the frequency components to obtain a mean
frequency<br/>
skewness(): skewness of the frequency domain signal <br/>
kurtosis(): kurtosis of the frequency domain signal <br/>
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of
each window.<br/>
angle(): Angle between to vectors.<br/>

>Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean<br/>
tBodyAccMean<br/>
tBodyAccJerkMean<br/>
tBodyGyroMean<br/>
tBodyGyroJerkMean<br/>

>The complete list of variables of each feature vector is available in 'features.txt'

Part 2. Modified labels and subset of data selected
---------------------------------------------------
### Data files:

The 'features.txt' file has 't' for time domain and 'f' for frequency domain for all its variable names. These were changed to the full name (Time/Frequency) as part of the data processing. The remainder of the variable names were left intact (with the exception of the 'BodyBody' mislabeling) to preserve the association with the original data. The variables included in the tidy data set submitted are:

TimeBodyAcc (one each for XYZ) <br/>
TimeGravityAcc (one each for XYZ)<br/>
TimeBodyAccJerk (one each for XYZ)<br/>
TimeBodyGyro (one each for XYZ)<br/>
TimeBodyGyroJerk (one each for XYZ)<br/>
TimeBodyAccMag<br/>
TimeGravityAccMag<br/>
TimeBodyAccJerkMag<br/>
TimeBodyGyroMag<br/>
TimeBodyGyroJerkMag<br/>
FrequencyBodyAcc (one each for XYZ)<br/>
FrequencyBodyAccJerk (one each for XYZ)<br/>
FrequencyBodyGyro (one each for XYZ)<br/>
FrequencyBodyAccMag<br/>
FrequencyBodyAccJerkMag<br/>
FrequencyBodyGyroMag<br/>
FrequencyBodyGyroJerkMag<br/>

The set of variables that were estimated from each of these signals are: 

Mean: Mean value<br/>
Std: Standard deviation<br/>

***The total number of variables is therefore 66 (33 for the mean and 33 for the standand deviation). 

Angular, i.e., angle(), and meanFreq() measurements were not selected as they are not directly associated with the instrumentation readings as explained above. Therefore all other variables listed in Part 1 above were not selected from the original data set for the purpose of this project.

The complete list of variables of each feature vector is available in 'features.txt' and the subset of variables selected for this project was stored in the 'feat' data table while running the code. See the README.md and run_analysis.R files for procedures.

### Activity codes:

Another change in labeling took place with the activity codes, where were reported in numeric form in the "y_test.txt"" and "y_train.txt"" files in the Dataset directory. Based on the rubric given in the activities_labels.txt file, the numeric codes were replaced by the corresponding activity names 1:walking, 2:walking up(stairs), 3:walking down(stairs), 4:sitting, 5:standing, and 6:laying. See the README.md and run_analysis.R files for procedures. 

Part 3. Calculations performed
------------------------------

### Files manipulations:

- reading files (test data, train data, test activity, train activity, test subject, train subject, activity codes rubric, variable names list)
- use the variable names list to assign column names to the data files
- merging pairwise test & train data, activity, and subject files
- use the varible names list to select those varibles of interest for this project (mean and standard deviation)
- reduce merged data set to create a trimmed data set
- add a column for activity codes and a column for subject info to the data set
- exchange activity numeric codes with descriptive names
- clean variable names

***This process resulted in a data table with 10299 observations and 68 variables (66 data columns, 1 activity name column, 1 subject info column)

### Calculations:

Following the merging of files, subsetting of variables, and label modifications performed to produce a 'trimmed' data set (trimmed_data), one set of calculations was performed on this data set. The average (mean function in R) of each variable for each activity and each subject was obtained via the aggregate function in R. This function splits the measurement data set into subsets (per subject for each type of activity) and computes the average of each variable in the corresponding subset. 

***This process resulted in a data table with 180 averages (180 rows = 30 subjects x 6 types of activities) for each of the 66 variables of interest. The data table is therefore 180 rows x 68 columns.

See the run_analysis.R file for executable code and the README.md file for additional documentation.

end
