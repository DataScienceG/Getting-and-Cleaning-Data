## Note: In order to run the file, you have to install package plyr
####################################################################

##1.Merges the training and the test sets to create one data set.

Xtrain <- read.table("train/X_train.txt")
Ytrain <- read.table("train/y_train.txt")
Subtrain <- read.table("train/subject_train.txt")

#Test data
Xtest <- read.table("test/X_test.txt") 
Ytest <- read.table("test/y_test.txt") 
Subtest <- read.table("test/subject_test.txt") 
## Merge X
XCombine<-rbind(Xtrain,Xtest)
## Merge Y
YCombine<-rbind(Ytrain,Ytest)
##Merge Subject
SubCombine<-rbind(Subtrain,Subtest)
##2.Extracts only the measurements on the mean and standard deviation for each measurement. 

#Read Features
Features <- read.table("features.txt")
## Either mean or std
ExtFeatures<-grep("mean|std", Features[,2])

##Subset
XCombine<- XCombine[, ExtFeatures]
## Corresponded names for each column
names(XCombine) <- Features[ExtFeatures, 2]

##3.Uses descriptive activity names to name the activities in the data set
##Read activity label
Activity<-read.table("activity_labels.txt")
YCombine[,1]<-Activity[YCombine[, 1], 2]
names(YCombine)<-"Activity"

##4.Appropriately labels the data set with descriptive variable names. 
names(SubCombine)<-"Subject"
##Combine all clean data X, Y and Subject
Combine<-cbind(XCombine,YCombine,SubCombine)
##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)
Avg <- ddply(Combine, .(Subject, Activity), function(x) colMeans(x[, 1:66]))
##write data to file
write.table(Avg, "Avgdata.txt", row.name=FALSE)