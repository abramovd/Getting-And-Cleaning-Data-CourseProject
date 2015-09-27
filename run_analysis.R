library(plyr)

#Getting data

xtest<-read.table("UCI HAR Dataset/test/X_test.txt")
ytest<-read.table("UCI HAR Dataset/test/Y_test.txt")
subjecttest<-read.table("UCI HAR Dataset/test/subject_test.txt")

xtrain<-read.table("UCI HAR Dataset/train/X_train.txt")
ytrain<-read.table("UCI HAR Dataset/train/Y_train.txt")
subjecttrain<-read.table("UCI HAR Dataset/train/subject_train.txt")

labelactivities<-read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("Id", "Activity"))

#Getting features labels
featurelabels<-read.table("UCI HAR Dataset/features.txt", colClasses = c("character"))

# merging

train<-cbind(xtrain, subjecttrain, ytrain)
test<-cbind(xtest, subjecttest, ytest)
data<-rbind(train, test)

labels<-rbind(featurelabels, c(562, "Subject"), c(563, "Id"))[,2]
names(data) <- labels

# mean, std

meanstddata <- data[,grepl("mean\\(\\)|std\\(\\)|Subject|Id", names(data))]

# label activities

labelactivities[, 2] <- gsub("_", "", tolower(as.character(labelactivities[, 2])))
meanstddata$Id <- labelactivities[data$Id, 2]
meanstddata <- rename(meanstddata, c(Id = "Activity"))

# tidy data
clean <- meanstddata

write.table(clean, "tidy_data.txt")

clean2<-aggregate(. ~ Subject + Activity, clean, mean)
clean2<-clean2[order(clean2$Subject,clean2$Id),]

write.table(clean2, file = "tidy_data2.txt",row.name=FALSE)