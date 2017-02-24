# Peer-graded Assignment: Getting and Cleaning Data Course Project
A Peer-graded Assignment of the Coursera course "Getting and Cleaning Data" week 4. The purpose of this project is to demonstrate ability to collect, work with, and clean a data set.

In this assignment we retrieve data for the project from the website that is a Machine Learning Repository and it represents data collected from the accelerometers from the Samsung Galaxy S II smartphone, who's needed to be rearrange in order to be tidy data set.

The code contained in the script named "run_analysis.R", can be called from inside an R session. For example, when launching a new R session and writing in the command line:

\> source("run_analysis.R")

This will read and execute the script that performs certain operations on a data set, as explained below, in order to prepare tidy data that can be used for later analysis. The final structure and content of the tidy data set is partly detailed in the file "CodeBook.md" and can be viewed with the command

\> View(Accelerometers_Mean)

written to the command line after running the script named "run_analysis.R".

Description the script run_analysis.R
======================================
The R script called run_analysis.R does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Description of how run_analysis.R performs the above steps:
===========================================================
1. Loads the librareis **library(utils)** and **library(dplyr)**. If one haven't installed yet these libraries it is possible to install them with the command **install.packages("package_name")**. Concatinate the training and the test sets with the command **rbind** and then concatenate the Subject, Activity and Feature columns with the **cbind** command. <br />
2. Load the features labels and extract the mean and standard deviation column names with the command **gerp** and extract the right columns with the command **subset**. <br />
3. Load activity labels and then use the command **merge** to merge the tidy data set with the activity label. The result needed to be rearrange again in the right order and that is been done with the command **select**. <br />
4. Using the **gsub** command we appropriately labels the data set with descriptive variable names. <br />
5. In the last step we use a special function from the dplyr package, **summarise_each**, in order to aggregate the information in wanted way. Since the summarise_each function changes the names of the columns, a renaming is needed.
