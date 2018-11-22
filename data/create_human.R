#########
# author: Eemeli Annala
# data: November 22,  2018
# 
# This file is part of my IOPS course project, week 4 (clustering and classification)
#########

# Let us read the first data set, related to human development
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

# and the second file about gender inequality
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Let us then study the structure and the dimension of the data sets
dim(hd)
str(hd)
dim(gii)
str(gii)

# The fie 'hd' seems to contain 195 observations (rows) and 8 variables (columns)
# whereas the 'gii' file has 195 and 10, respectively.
# It seems that all varibales are in numerical form except the vaaribale 'Country'
# and 'Gross.National.Income..GNI..per.Capita'. However, it seems that the latter one
# can be converted into numerical form as well.

# Let us make a summary of these variables
summary(hd)
summary(gii)

# Let us then rename these variables
colnames(hd)[1] <- "rank_hdi"
colnames(hd)[2] <- "country" # I like to use small letters :p
colnames(hd)[3] <- "hdi"
colnames(hd)[4] <- "life_exp"
colnames(hd)[5] <- "exp_education"
colnames(hd)[6] <- "mean_education"
colnames(hd)[7] <- "gni"
colnames(hd)[8] <- "gni_minus_hdi"

colnames(gii)[1] <- "rank_gii"
colnames(gii)[2] <- "country"
colnames(gii)[3] <- "gii"
colnames(gii)[4] <- "maternal_mortality"
colnames(gii)[5] <- "birth_rate"
colnames(gii)[6] <- "parlamanet_perc"
colnames(gii)[7] <- "sec_education_f"
colnames(gii)[8] <- "sec_education_m"
colnames(gii)[9] <- "labour_f"
colnames(gii)[10] <- "labour_m"

# Calling library dplyr
library(dplyr) # mutate

# Then let us create two new varibales for 'gii' set
gii <- mutate(gii, sec_education_ratio = sec_education_f / sec_education_m)
gii <- mutate(gii, labour_ratio = labour_f/ labour_m)

# Joining data sets s.t. our identifier is the variable 'country'
hd_gii = inner_join(hd, gii, by = "country")

# Let us then check that everything is as it should be
str(hd_gii)
# 195 observations and 19 variables -> OK!

# Then we just need to save the combined data set
write.table(hd_gii, file = "data/human.txt", sep = "\t")
