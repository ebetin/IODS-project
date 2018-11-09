#########
# author: Eemeli Annala
# data: November 9,  2018
# 
# This file is part of my IOPS course project when we study data wrangling.
#########


## Part 2

# reading data
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# structure of the data
str(learning2014)
#
# output: This function tells us about the structure of the data, for instance, name of the columns, data types etc.

# dimensions of the data
dim(learning2014)
#
# output: There seems to be 183 rows (ie. data sets) and 60 columns (ie. variables).


## Part 3

# Using the dplyr library
library(dplyr)

# Initializing object lrn2014 with data about the gender, age and attitude.
lrn2014 <- learning2014[c("gender","Age","Attitude")]

# Defining vectors that contains information about deep, surface and strategic learning, respectively
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# Creating a matrix that contains all deep learing related questions
deep_matrix <- select(learning2014, one_of(deep_questions))

# Avarage of every row of the deep_matrix and insert this column into lrn2014
lrn2014$deep <- rowMeans(deep_matrix)

# Sama as above but about the strategic learning
strategic_matrix <- select(learning2014, one_of(strategic_questions))
lrn2014$stra <- rowMeans(strategic_matrix)

# Sama as above but about the surface learning
surface_matrix <-select(learning2014, one_of(surface_questions))
lrn2014$surf <- rowMeans(surface_matrix)

# Renaming columns (coding and capital letters...)
colnames(lrn2014)[2] <- "age"
colnames(lrn2014)[3] <- "attitude"
colnames(learning2014)[59] <- "points"

# Add column points to lrn2014
lrn2014 <- cbind(lrn2014, learning2014["points"])

# Scaling column attitude by dividing it by 10
lrn2014$attitude <- lrn2014$attitude / 10

# Removing data students with zero exam points
lrn2014 <- filter(lrn2014, points > 0)


## Part 4

# Saving the data (NB The working directory is the iods folder!)
write.table(lrn2014, file = "data/learning2014.txt", sep = "\t")

# Let us read it
read.table("data/learning2014.txt", sep="\t", header=TRUE)

# And everything seems to be all right! :)