

###----------------Libraries-----------------------------------------------

library(dplyr)


###---------------- Input of Feature Names and Activity Label--------------

# Feature Names
path <- "features.txt"
FeatureNames <- read.table(file = path, header = FALSE,
                           colClasses=c("integer", "character"),
                           col.names=c("feature_id", "feature_name"))

# Activity labels
path <- "activity_labels.txt"
ActivityLabels <- read.table(file = path, header = FALSE,
                             colClasses=c("integer", "character"),
                             col.names=c("label_id", "activity"))


###----------------Training Data Input-------------------------------------

# Training Data
path <- "train/X_train.txt"
X_train <- read.table(file = path, header = FALSE,
                      colClasses="double",
                      # Appropriately labels the data set
                      # with descriptive variable names
                      col.names=FeatureNames$feature_name)
# Subject ids
path <- "train/subject_train.txt"
subject_train <- read.table(file = path, header = FALSE,
                            colClasses="integer",
                            col.names=c('subject_id'))
# Activity ids
path <- "train/y_train.txt"
y_train <- read.table(file = path, header = FALSE,
                      colClasses="integer",
                      col.names="label_id")


###----------------Training Data Prepararion-------------------------------

# Extracts only the measurements on the mean and standard deviation
# for each measurement.
X_train <- X_train[grep( "std|mean", names(X_train))]

X_train <- cbind(X_train,
                 subject_train,
                 # Uses descriptive activity names to name the activities
                 # in the data set.
                 merge(y_train, ActivityLabels, by="label_id")[2])

###----------------Testing Data Input--------------------------------------

# Testing data
path <- "test/X_test.txt"
X_test <- read.table(file = path, header = FALSE,
                     colClasses="double",
                     # Appropriately labels the data set
                     # with descriptive variable names
                     col.names=FeatureNames$feature_name)
# Subject ids
path <- "test/subject_test.txt"
subject_test <- read.table(file = path, header = FALSE,
                            colClasses="integer",
                            col.names=c('subject_id'))
# Activity ids
path <- "test/y_test.txt"
y_test <- read.table(file = path, header = FALSE,
                      colClasses="integer",
                      col.names="label_id")


###----------------Testing Data Prepararion--------------------------------

# Extracts only the measurements on the mean and standard deviation
# for each measurement.
X_test <- X_test[grep( "std|mean", names(X_test))]

X_test <- cbind(X_test,
                subject_test,
                # Uses descriptive activity names to name the activities
                # in the data set.
                merge(y_test, ActivityLabels, by="label_id")[2])


###----------------Merging Testing and Training Data------------------------

# Merges the training and the test sets to create one data set.
Data <- rbind(X_train, X_test)


###----------------Averaged Data from Groping by Activity and subject-------

# Second, independent tidy data set with the average of each variable
# for each activity and each subject
New <- Data %>% group_by(subject_id, activity) %>% summarise_each(funs(mean))
names(New) <- gsub("\\.", "", names(New))
write.table(x = New, file="Result.txt", row.name=FALSE)

###----------------Tiding new data------------------------------------------

#bad_features <- names(New)[grep("[XYZ]", names(New))]
#temp <- unique(unlist(strsplit(bad_features, split="\\.\\.\\.")))
#measurement <- setdiff(temp, c("X", "Y", "Z"))


###----------------Memory Cleaning------------------------------------------

rm(list=ls()[!(ls() %in% c( "Data", "New"))])