# 1. Merge training and test sets 

  # Read in the data into the test and training sets
  test.data <- read.table(file.path(targetFolder, 'test', 'X_test.txt'))
  test.activities <- read.table(file.path(targetFolder, 'test', 'y_test.txt'))
  test.subjects <- read.table(file.path(targetFolder, 'test', 'subject_test.txt'))
  
  train.data <- read.table(file.path(targetFolder, 'train', 'X_train.txt'))
  train.activities <- read.table(file.path(targetFolder, 'train', 'y_train.txt'))
  train.subjects <- read.table(file.path(targetFolder, 'train', 'subject_train.txt'))
  
  # Bind the rows for each of the data sets together
  data.data <- rbind(train.data, test.data)
  data.activities <- rbind(train.activities, test.activities)
  data.subjects <- rbind(train.subjects, test.subjects)
  
  # Now combine all of of the different columns together into one table
  full_data <- cbind(data.subjects, data.activities, data.data)

# 2. Extracts measurements on mean and standard deviation 

  # Grab the complete list of features
  features <- read.table(file.path(targetFolder, 'features.txt'))
  
  # Filter to the features we want
  requiredFeatures <- features[grep('-(mean|std)\\(\\)', features[, 2 ]), 2]
  full_data <- full_data[, c(1, 2, requiredFeatures)]

# 3. Uses descriptive activity names
  
  # Read in the activity labels
  activities <- read.table(file.path(targetFolder, 'activity_labels.txt'))
  
  # Update the activity name
  full_data[, 2] <- activities[full_data[,2], 2]
  
# 4. Appropriately labels with descriptive variable names. 
  
  colnames(full_data) <- c(
    'subject',
    'activity',
    # Remove the brackets from the features columns
    gsub('\\-|\\(|\\)', '', as.character(requiredFeatures))
  )
  
  # Coerce the data into strings
  full_data[, 2] <- as.character(full_data[, 2])
  
# 5. Creates second independent tidy data set, with the average of each variable for each activity

  # Melt the data so we have a unique row for each combination of subject and acitivites
  final.melted <- melt(full_data, id = c('subject', 'activity'))
  
  # Cast it getting the mean value
  final.mean <- dcast(final.melted, subject + activity ~ variable, mean)

  # Emit the data out to a file
  write.table(final.mean, file=file.path("tidy.txt"), row.names = FALSE, quote = FALSE)
