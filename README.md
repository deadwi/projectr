projectr
========

Description
======
It loads the mean and standard deviation features in training and the test sets. (./UCI HAR Dataset/)
And calculates average of each variable for each activity and each subject. 

Usage
======
run_analysis()

Return
======
Table of average of each variable for each activity and each subject
Columns
 * variable : Feature name. If the suffix is "_mean_", mean value. Or the suffix is "_std_", standard deviation.
 * subject : An identifier of the subject who carried out the experiment. Its range is from 1 to 30.
 * activity : Activity name. All activity name are defined by activity_labels.txt file
 * mean : Average of variable, subject and activity.

