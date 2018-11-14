#########
# author: Eemeli Annala
# data: November 14,  2018
# 
# This file is part of my IOPS course project, week 3 (logistic regression)
#########

# reading given data
# If you want to know more about the data sets, go to
# https://archive.ics.uci.edu/ml/datasets/Student+Performance
data_mat <- read.csv("data/student-mat.csv", sep=";", header=TRUE)
data_por <- read.csv("data/student-por.csv", sep=";", header=TRUE)

# examining these data sets
dim(data_mat)
str(data_mat)

dim(data_por)
str(data_por)

# It seems that the 1st data set contains 33 variables (columns) with 395 data points (rows)
# Accordingly, the latter set contains 33 variables and 649 points
# Besides, both data sets have the same variables (column names), which is nice :)

# Let us call the dplyr library
library(dplyr)

# Let us then define the student identifier variables as a vector
join_variables <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# And then we can just combine these two data sets using the above given identifiers
# NB the possible suffix refers to the corresponding original data set
combined_data <- inner_join(data_mat, data_por, by = join_variables, suffix = c(".mat",".por"))

# Let us then examine the joined set
dim(combined_data)
str(combined_data)

# Now we have 53 variables and 382 data points
# At least, the amount of variable seems to be correct which is good
# As well, the number of data points 382 < 395 < 649

# Let us get rid of duplicated variables
# firstly, let us form a vector which contains all variables that are not joined yet
notjoined_variables <- colnames(data_mat)[!colnames(data_mat) %in% join_variables]

# Let us initial the result array with existing join data
fully_combined_data <- select(combined_data, one_of(join_variables))

# loop through all non-joined variables
for(column_name in notjoined_variables) {
  # selects colums with same name (NB exculding suffix)
  similar_columns <- select(combined_data, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(similar_columns, 1)[[1]]
  
  # if the selected columns contain only numerical data, then...
  if(is.numeric(first_column)) {
    # use the average (and save the column)
    fully_combined_data[column_name] <- round(rowMeans(similar_columns))
  } else { 
    # else just use the 1st column
    fully_combined_data[column_name] <- first_column
  }
}

# Let us see what did happen...
str(fully_combined_data)
# 33 variables :)

# Let us define a new column which contains the alcohol usage
# This variable is defined to be an average of the workday (Dalc) and weekend usage (Walc)
fully_combined_data <- mutate(fully_combined_data, alc_use = (Dalc + Walc) / 2)

# We will create another new column which tells us if the alcohol usage is high or not
# Here, we define that if alc_use > 2 then one is consuming too much alcohol :(
fully_combined_data <- mutate(fully_combined_data, high_use = alc_use > 2)

# Let check this freshly created data set one more time
glimpse(fully_combined_data)
# 382 observations and 35 variables => OK!

# Then we just need to save this beauty...
write.table(fully_combined_data, file = "data/alc.txt", sep = "\t")