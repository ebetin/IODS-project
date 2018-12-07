#########
# author: Eemeli Annala
# data: December 7,  2018
# 
# This file is part of my IOPS course project, week 6
#########

# Needed libraries
library(tidyr) # gather
library(dplyr) # mutate

# Reading the data sets (wide forms)
bprs <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
rats <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep  ="\t", header = T)

# Variables names
colnames(bprs)
colnames(rats)

# Structures
str(bprs)
str(rats)

# Seems like the 

# Summaries
summary(bprs)
summary(rats)

# Coverting categorical variables into factors
bprs$treatment <- factor(bprs$treatment)
bprs$subject <- factor(bprs$subject)
rats$ID <- factor(rats$ID)
rats$Group <- factor(rats$Group)

# Creating a long form where the week variables are defided into
# integer variable 'week' and numerical variable 'bprs' 
bprs_long <-  bprs %>% 
  gather(key = weeks, value = bprs, -treatment, -subject)

bprs_long <- bprs_long %>% mutate(week = as.integer(substr(bprs_long$weeks,5,5)))

# Creating a long form where the week variables are defided into
# integer variable 'weight' and numerical variable 'time' 
rats_long <- rats %>%
  gather(key = wd, value = weight, -ID, -Group)

rats_long <- rats_long %>% mutate(time = as.integer(substr(rats_long$wd,3,4))) 

# Removing useless doublicate/temporary columns
bprs_long$weeks <- NULL
rats_long$wd <- NULL

# Let us then study the created data sets
glimpse(bprs_long)
glimpse(rats_long)

# The shapes of the data sets are changed. First of all, the 'bprs' set contains
# 40 obs. and 11 var. but the updated version 'bprs_long' contains 360 obs and 4 var.
# Correspondingly, the 'rats' set contains 16 obs. and 13 var. => 176 and 4.
# So, the difference between the wide formula and the long one is the wide one 
# contains more variables (columns) whereas the long one has more observations (rows).
# Nonetheless, the same data is still there but in different format. For isntance, 
# the content of 11 'WDxx' variables is turned into two variables 'bprs' and 'week'.
# The first one contains the numerical information of the object whereas the latter
# one has information about the 'xx' part of the original variable 'WDxx'.
# The same type of transformation have been done for the other data set as well.

# The variables of 'bprs_long' data set:
#  treatment: either 1 or 2
#  subject:   betweeen 1 and 20
#  bprs:      the bprs value (at given time)
#  week:      number of the week

# The variables of 'rats_long' data set:
#  ID:      ID number, 1 to 16
#  Group:   group number, either 1 or 2
#  weight:  weight (at given time)
#  time:    time of the measurement

# Finally, let us save these updated data sets
write.table(bprs_long, file = "data/bprs_long.txt", sep = "\t")
write.table(rats_long, file = "data/bprs_long.txt", sep = "\t")