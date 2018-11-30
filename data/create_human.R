#########
# author: Eemeli Annala
# data: November 22,  2018
# updated: November 30, 2018
# 
# This file is part of my IOPS course project, week 4 & 5
#########

## Week 4

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
# can be converted into numerical form as well if needed.

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
colnames(gii)[6] <- "parliament_perc"
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

## Week 5

# Reading the data file
human <- read.table("data/human.txt", sep = "\t", header = T)

# Let us study the data set
str(human)
dim(human)
# Still 195 observations and 19 variables
# All varibales are numberical ones except 'country' (country name) 
# and 'gni' (Gross National Income per capita) variables
# However, the 'gni' variable seems to contain numerical data
# The other interesting varaibles are:
# 'life_exp' (life expectancy)
# 'exp_education' (expected amount of years in school)
# 'maternal_mortality' (maternal mortality ration)
# 'birth_rate' (birth rate)
# 'parliament_perc' (number of females in parliament (per cent))
# ['sec_education_f' (numner of females in secondary education (per cent))]
# ['sec_education_m' (number of males in secondary education (per cent))]
# 'sec_education_ratio' ('sec_education_f'/'sec_education_m')
# {'labour_f' (number of females in the labour force (per cent))]
# {'labour_m' (number of males in the labour force (per cent))]
# 'labour_ratio' ('labour_f'/'labour_m')


# Let us transform the 'gni' variable into numerical form
# First of all, we need to access to a library
library(stringr) # str_replace

# Then we remove all commas and turn the variable into numerical form
human$gni <- str_replace(human$gni, pattern=",", replace ="") %>% as.numeric

## Let us get rid of unneeded columns, ie. the ones not listed above
# Columns that we need
needed_columns <- c("country", "sec_education_ratio", "labour_ratio", "exp_education", "life_exp", "gni", "maternal_mortality", "birth_rate", "parliament_perc")

# Let us only keep these ones
human <- select(human, one_of(needed_columns))

# Then we can remove all rows with NA values
human <- filter(human, complete.cases(human))

# Let us then study the 'country' variables
human$country
# It also seems like the last seven entries of variable 'country' are not contries but bigegr areas

# We should remove these entries
human_ <- human[1:(nrow(human) - 7),]

# renaming row names by the corresponding country name (using dummy variable 'human_')
rownames(human_) <- human_$country

# removing the column 'country (NB using the dummy varibale 'human_')
human <- select(human_, -country)

# Checking the end results
glimpse(human) # 155 observations and 8 variables => OK
rownames(human) # seems OK as well

# Then we just need to save the end product
write.table(human, file = "data/human_updated.txt", sep = "\t")