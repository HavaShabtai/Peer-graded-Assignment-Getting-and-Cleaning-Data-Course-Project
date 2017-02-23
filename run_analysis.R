### Getting and Cleaning Data Course Project

### Question 1 : Merges the training and the test sets to create one data set.

 library(utils)
 library(dplyr)

## Create a data folder if not exists already.
## Also, download the accelerometers data.
 
 if(!file.exists("./data")){
   dir.create("./data")  
 }
 if(!file.exists("./data/accelerometers_data.zip")){
   fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
   download.file(fileUrl, destfile="./data/accelerometers_data.zip")
  #, method="curl"
 }
 
 
 ## We will unzip the accelerometers data.
 
 Accelerometers_Data <- unzip("./data/accelerometers_data.zip", exdir="./data")
 
 
 ## Get the file path.
 
 path <- file.path("./data" , "UCI HAR Dataset")
 
 
 ## We will read the Test/Training labels.
 
 Activity_Label_Test  <- read.table(file.path(path, "test" , "Y_test.txt" ), header = FALSE)
 Activity_Label_Train <- read.table(file.path(path, "train", "Y_train.txt"), header = FALSE)
 
 
 ## We will read the Test/Training Subject files.
 ## Each row identifies the subject who performed the activity for each window sample.
 
 Subject_Train <- read.table(file.path(path, "train", "subject_train.txt"), header = FALSE)
 Subject_Test  <- read.table(file.path(path, "test" , "subject_test.txt"), header = FALSE)
 
 
 ## We will read the Features Test/Training files.
 ## Features are normalized and bounded within [-1,1].
 ## Each feature vector is a row on the text file.
 
 Features_Test  <- read.table(file.path(path, "test" , "X_test.txt" ), header = FALSE)
 Features_Train <- read.table(file.path(path, "train", "X_train.txt"), header = FALSE)
 
 
 ### This code will merges the training and the test sets to create one data set.
 ### The goal is to create a table that will look like this:
 
 ###  (Variables Name) | Subject           | Activity       |  features.txt |
 ###                   _______________________________________________________
 
 ###  (data)           | Subject_train.txt |  y_train.txt   |  X_train.txt  | 
 ###  (data)           | Subject_test.txt  |  y_test.txt    |  X_test.txt   | 
 ###                   |                     (according to       
 ###                                           the file 
 ###                                           activity_labels.txt)
 ###                  _______________________________________________________
 
 
 ## First we need to concatenate the Train and Test tables by rows
 
 Subject  <- rbind(Subject_Train, Subject_Test)
 Activity <- rbind(Activity_Label_Train, Activity_Label_Test)
 Features <- rbind(Features_Train, Features_Test)
 
 
 ## Now we set the name to each column.
 
 
 colnames(Subject) <- c("Subject")
 colnames(Activity) <- c("Activity")
 
 ## For the features column we will use "features.txt"
 
 colFeatures_Names <- read.table(file.path(path, "features.txt"), head=FALSE)
 
 ## Let's see how Features_Names looks like:
 
 ## head(Features_Names, 4)
 ## V1                V2
 ## 1   tBodyAcc-mean()-X
 ## 2   tBodyAcc-mean()-Y
 ## 3   tBodyAcc-mean()-Z
 ## 4    tBodyAcc-std()-X
 
 ## We would like to use V2

 colnames(Features)<- colFeatures_Names$V2
 
 ## Now we can concatenate the columns to create the wanted table with the wanted names
 
 Subject_Activity <- cbind(Subject, Activity)
 Accelerometers_Tidy_Data <- cbind(Subject_Activity, Features)
 Accelerometers_Names <- c("Subject", "Activity", as.character(colFeatures_Names$V2))
 colnames(Accelerometers_Tidy_Data) <- Accelerometers_Names
 
 ## str(Accelerometers_Tidy_Data)
 ## 'data.frame':	10299 obs. of  563 variables:
 ## $ Subject                             : int  1 1 1 1 1 1 1 1 1 1 ...
 ## $ Activity                            : int  5 5 5 5 5 5 5 5 5 5 ...
 ## $ tBodyAcc-mean()-X                   : num  0.289 0.278 0.28 0.279 0.277 ...
 ## $ tBodyAcc-mean()-Y                   : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
 ## $ tBodyAcc-mean()-Z                   : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
 ## $ tBodyAcc-std()-X                    : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
 ## $ tBodyAcc-std()-Y                    : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
 ## ....
 
 ### Question 2 : Extracts only the measurements on the mean and standard deviation for each measurement.
 
 ## We will create a subset from the names of Features_Names that will include only 
 ## measurements on the mean and standard deviation.
 
 Mu_Sig_Features_Names <- colFeatures_Names$V2[grep("mean\\(\\)|std\\(\\)", colFeatures_Names$V2)]
 
 
 ## We will create a subset of the data frame Accelerometers_Tidy_Data 
 ## with only the measurements on the mean and standard deviation for each measurement.
 
 Subset_Names <- c("Subject", "Activity", as.character(Mu_Sig_Features_Names))
 Accelerometers_Tidy_Data <- subset(Accelerometers_Tidy_Data, select = Subset_Names)
 
 ## str(Accelerometers_Tidy_Data)
 ## 'data.frame':	10299 obs. of  68 variables:
 ## $ Subject                             : int  1 1 1 1 1 1 1 1 1 1 ...
 ## $ Activity                            : int  5 5 5 5 5 5 5 5 5 5 ...
 ## $ tBodyAcc-mean()-X                   : num  0.289 0.278 0.28 0.279 0.277 ...
 ## $ tBodyAcc-mean()-Y                   : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
 ## $ tBodyAcc-mean()-Z                   : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
 ## $ tBodyAcc-std()-X                    : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
 ## $ tBodyAcc-std()-Y                    : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
 ## ....
 
 ### Question 3 : Uses descriptive activity names to name the activities in the data set.
 
 
 ## We will first read the descriptive activity names from the file "activity_labels.txt"
 
 Activity_Labels <- read.table(file.path(path, "activity_labels.txt"), header = FALSE)
 
 ##  head(Activity_Labels)
 ##    V1                 V2
 ##  1  1            WALKING
 ##  2  2   WALKING_UPSTAIRS
 ##  3  3 WALKING_DOWNSTAIRS
 ##  4  4            SITTING
 ##  5  5           STANDING
 ##  6  6             LAYING
 
 ## We will give the columns names
 
 colnames(Activity_Labels) <- c("activity id","Activity Descriptive")
 
 ## Now, We will convert every number in the Activity column 
 ## with a descriptive activity names by merge.
 
 Accelerometers_Activity = merge(x = Accelerometers_Tidy_Data, y = Activity_Labels, by.x="Activity", by.y="activity id")
 
 
 ## Remove the Activity field
 
 Accelerometers_Activity <- select(Accelerometers_Activity, -Activity)
 
 ## str(Accelerometers_Activity)
 ## 'data.frame':	10299 obs. of  68 variables:
 ## $ Subject                    : int  7 5 6 23 7 7 11 6 10 11 ...
 ## $ tBodyAcc-mean()-X          : num  0.302 0.343 0.27 0.268 0.314 ...
 ## $ tBodyAcc-mean()-Y          : num  -0.02688 -0.00343 0.01091 -0.01273 -0.0087 ...
 ## ...
 ## $ Activity Descriptive       : Factor w/ 6 levels "LAYING","SITTING",..: 4 4 4 4 4 4 4 4 4 4 ...
 
 ## We need to reorder the Accelerometers_Activity to the original order
 
 Accelerometers_Activity <- select(Accelerometers_Activity, Subject, 68, 2:67)
 
 
 ### Question 4 : Appropriately labels the data set with descriptive variable names.
 
 ## In this section we will change the Names of Features using descriptive variable names, 
 ## according to the features_info.txt.
 
 ## Prefix t means a time measurment and will be replace by Time.
 ## Prefix f means frequency measurement and will be replace by Frequency.
 ## Body means related to body movement, if perform twice will be replace by Body.
 ## Gravity means acceleration of gravity won't be replaced, because it is clear enough. 
 ## Acc means accelerometer measurement will be replace by Accelerometer.
 ## Gyro means gyroscopic measurements will be replace by gyroscope.
 ## Jerk means sudden movement acceleration won't be replaced, because it is clear enough.
 ## Mag means magnitude of movement magnitude will be replace by Magnitude.
 ## mean and std are calculated for each subject for each activity for each mean and std measurements. 
 ## will be replace by Mean and SD, respectively for the sake of uniformity.
 
 colnames(Accelerometers_Activity) <- gsub("^t", "Time", colnames(Accelerometers_Activity))
 colnames(Accelerometers_Activity) <- gsub("^f", "Frequency", colnames(Accelerometers_Activity))
 colnames(Accelerometers_Activity) <- gsub("Acc", "Accelerometer", colnames(Accelerometers_Activity))
 colnames(Accelerometers_Activity) <- gsub("Gyro", "Gyroscope", colnames(Accelerometers_Activity))
 colnames(Accelerometers_Activity) <- gsub("Mag", "Magnitude", colnames(Accelerometers_Activity))
 colnames(Accelerometers_Activity) <- gsub("BodyBody", "Body", colnames(Accelerometers_Activity))
 colnames(Accelerometers_Activity) <- gsub("mean", "Mean", colnames(Accelerometers_Activity))
 colnames(Accelerometers_Activity) <- gsub("std", "SD", colnames(Accelerometers_Activity))
 
 ## Here is an example of the result:
 
 ## head(colnames(Accelerometers_Activity))
 ## [1] "TimeBodyAccelerometer-Mean()-X" "TimeBodyAccelerometer-Mean()-Y" "TimeBodyAccelerometer-Mean()-Z"
 ## [4] "TimeBodyAccelerometer-SD()-X"   "TimeBodyAccelerometer-SD()-Y"   "TimeBodyAccelerometer-SD()-Z"
 
 
 ### Question 5 : From the data set in step 4, creates a second, independent tidy data set
 ### with the average of each variable for each activity and each subject.
 
 ## We will use a special function from the dplyr package, summarise_each, 
 ## in order to aggregate the information in wanted way.
 
 ## We will first transform Accelerometers_Activity into a tbl_df object. 
 ## No change will occur to the standard data.frame object 
 ## however, a much better print method will be available.
 
 Accelerometers_complete <- tbl_df(Accelerometers_Activity)
 
 ## According to the request in the question the information should be aggregated 
 ## by subject and activity.
 
 ## We will create unique column names, otherwise the summarise_each will give errors
 
 colnames(Accelerometers_complete) <- make.names(colnames(Accelerometers_complete) , unique=TRUE)
 
 ## We will aggregate by Subject and Activity Descriptive with the function group_by.
 Accelerometers_agg <- group_by(Accelerometers_complete, Subject, Activity.Descriptive)
 
 
 ## We will calculate the mean of each variable for each activity and each subject with summarise_each.
 
 Accelerometers_Mean <- summarise_each(Accelerometers_agg, funs(mean))
 
 ## Now we can attach the name of the columns again, since the summarise_each function changes them
 
 colnames(Accelerometers_Mean) <- colnames(Accelerometers_Activity)
 
 ## Let's see a sample of the data:
 ## Accelerometers_Mean[1:10, 1:3]
 ## Subject `Activity Descriptive` `TimeBodyAccelerometer-Mean()-X`
 ## <int>                 <fctr>                            <dbl>
 ## 1        1                 LAYING                        0.2215982
 ## 2        1                SITTING                        0.2612376
 ## 3        1               STANDING                        0.2789176
 ## 4        1                WALKING                        0.2773308
 ## 5        1     WALKING_DOWNSTAIRS                        0.2891883
 ## 6        1       WALKING_UPSTAIRS                        0.2554617
 ## 7        2                 LAYING                        0.2813734
 ## 8        2                SITTING                        0.2770874
 ## 9        2               STANDING                        0.2779115
 ## 10       2                WALKING                        0.2764266
 
 ## class(Accelerometers_Mean)
 ## [1] "grouped_df" "tbl_df"     "tbl"        "data.frame"
 
 ## We need to convert Accelerometers_Mean back to data frame and we will do it with write.table
 ## write.table will craete a text file which we will read with read.table.
 
 write.table(Accelerometers_Mean, file="Accelerometers_Mean.txt", row.names=FALSE, col.names=TRUE, sep="\t", quote=TRUE)
 
 Accelerometers_Avg <- read.table(file.path("Accelerometers_Mean.txt"), header = FALSE)