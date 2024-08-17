####################################
# R Workshop August 2024 Day 2
####################################
install.packages("dplyr")
install.packages("stargazer")
install.packages("lubridate")

library(dplyr)
library(stargazer)
library(lubridate)
# Today we will work with dataframes!!!

####################################
# Working directory
####################################
# But first, we have some things to cover.
# The working directory is the folder that you are working out of.
getwd() # see your current working directory
# The next line will set your working directory to another folder. Change it to a folder on your computer.
# Mac: setwd(“/Users/User Name/Documents/FOLDER”)
# PC: setwd(“C:/Users/User Name/Documents/FOLDER”)
# Or you can click 'Session' in the toolbar -> 'Set Working Directory -> 'Choose Directory' 
# When you set your working directory, it becomes easier to upload the files in the directory to R
# If I set my directory to the data folder for math camp that is on my computer,
# then I can upload files easily
setwd("/Users/Kayla/Library/CloudStorage/OneDrive-ThePennsylvaniaStateUniversity/math camp/2024/data")
# Now I don't need the entire file path
read.csv("the_office_series.csv")
# But if my working directory was somewhere else, I would need the entire filepath
read.csv("/Users/Kayla/Library/CloudStorage/OneDrive-ThePennsylvaniaStateUniversity/math camp/2024/data/the_office_series.csv")
# Note that in both of these examples, we are reading the csv into R but are not assigning it to anything
# More on this in a moment
# We also can write files to our computer
write.csv(csv_object, "file_path.csv")
# If you don't specify an entire file path (i.e. just put the name of the csv), it will save to wherever your WD is

####################################
# Packages
####################################
# Many of the functions we have worked with so far are in what we call base R. 
# These functions are already there.
# But there are tons of packages that can provide helpful or even necessary functions
# How do we install a package?
# install.packages("dplyr") # Note name of package in quotes
# Once a package is installed, you load it with library()
# You shouldn't have to install a package multiple times. Once it's there, it's there. 
library(dplyr) # Name of package not in quotes this time
# What if we loaded this but we actually don't need it?
detach("package:dplyr", unload = TRUE) # it is still installed, just not loaded now
#####
## Extra info that is good to have but we won't cover ##
# Sometimes a package you want won't be on cran so the typical install.packages() doesn't work
# In this case, you can install directly from source with devtools
# First you would make sure to have devtools
##install.packages("devtools")
# Then you would install the package
##devtools::install_github("bradleyboehmke/harrypotter")
# Notice: You can specify a specific package with the ::
# This is helpful when different packages use the same name for a function
# In the above code, we explicitly said to use install_github() from devtools, not from anywhere els

####################################
# Dataframes
####################################
read.csv("the_office_series.csv") # you might have to change the filepath based on your WD
# Source: https://www.kaggle.com/datasets/nehaprabhavalkar/the-office-dataset
# Right now we're only loading it in. It will be hard or impossible to work on it if we must load every time
# We will assign the dataframe as an object so that it stays in the global env. 
office_df <- read.csv("the_office_series.csv")
# Now it's in our global environment, and we can click it to explore it
# Wait a minute... it appears that empty lines on Guest Stars didn't read in as NA
# We can tell R what the NA strings are, in this case, just "" (empty quote indicates blank)
office_df <- read.csv("the_office_series.csv", na.strings = "")
# Use the $ to access columns. dataframe$column_of_interest
# We can see that this X column appears to be an index. We don't need it
office_df$X
office_df$X <- NULL
# What we've just done is take a column and assign it to be nothing so it disappears.
# What if we want to explore the full dataset - see data types and get summary statistics
# We can use head() or tail() to get a beginning or ending chunk of the data
head(office_df, 10)
str(office_df) # see structure of each col
summary(office_df) # summary statistics
names(office_df) # see column names
# We can print beautiful tables of our summary statistics
stargazer(office_df, type = "text")
# This is how you will print gorgeous beautiful tables when you report regression results
# Other packages: texreg, xtable

# What if we only want to work on one column?
mean(office_df$Votes) # see the mean of the votes column
# We have a variable (column) called seasons. Does it make sense to take the average of seasons?
# This perhaps should be categorical. Use as.factor to coerce a variable to be categorical
as.factor(office_df$Season)
str(office_df$Season) # It says it's still integer... why?
office_df$Season <- as.factor(office_df$Season)
# We assign the Season variable to be itself but factored (categorical)
# This overwrites the original integer season column
# If you didn't want to overwrite it for whatever reason, you can maintain the initial Season col
# And instruct a new column to be created based upon the season column
# First let's turn it back to integer. It's as if we haven't changed it at all
office_df$Season <- as.integer(office_df$Season)
# Now let's assign a new column to be categorical seasons, but maintain our integer Season column
office_df$season_cat <- as.factor(office_df$Season)

# What about Date? It's a character variable. How can we coerce it to a datetime format?
# (normally, you would import all your packages at the top of your script)
# We can see that it's date,. month, year, so we can use lubridate's dmy()
dmy(office_df$Date)
# What if date was in a different order? Like year, month, day? And you don't know lubridate by heart
# You can always google something - e.g. "how to turn date to datetime object R" 
# or look in the lubridate package
??lubridate

# What if we wanted to keep the character column but also have a date column?
# Well, office_df$Date <- dmy(office_df$Date) would replace the character column
# Instead, we will create a new column.
office_df$Date_datetime <- dmy(office_df$Date)
# Now we have our original character column and we have a new column with the same information but as datetime
# Why do we care so much about datetime?
# Well, you might want the year, or the month, or the day
year(office_df$Date)
year(office_df$Date_datetime)
month(office_df$Date_datetime)
# At this point, if you are worried that you might have a date variable that isn't in a format
# that can be turned into datetime, don't worry!
# 1) there are soooo many ways to make a datetime that this situation would be unusual
# 2) there are ways to extract partial strings from character variables, like the last 4 characters
# We won't do that here, but it does exist, and somebody on stack exchange has probably already asked how


####################################
# Dataframes: duplicates and NAs
####################################
# Let's look to another column and learn some more functions
office_df$Director
# What if we don't care about repeats? We want to know who has directed any episode, or how many different directors there were
unique(office_df$Director)
duplicated(office_df$Director) # just gives T/F for whether each is a duplicate
which(duplicated(office_df$Director)) # gives the ones that are duplicates
# To see the length of the Director variable (should be same as the dataframe length)
length(office_df$Director)
# To see the length of the unique directors
length(unique(office_df$Director))

# How about missing data?
is.na(office_df) # gives T/F for whether each value is missing
which(is.na(office_df), arr.ind = TRUE) 
# which(is.na(office_df)) should work too, but is not working for me 
# However, I am listing it here so that you know it exists
which(is.na(office_df$About)) # gives us NAs in column About. There are none
which(is.na(office_df$GuestStars)) # gives us the indices for NA in GuestStars col
# What if we want to subset our data so that we only have the episodes where there were no guest stars?
# You can subset the dataset by first using office_df[ ] - this says to use the whole dataset(as opposed to a column)
# Then inside the bracket is the condition
# In this case, show me the rows (for all the columns) but only where GuestStars is NA
# Note the comma before the closing bracket!!!
office_df[is.na(office_df$GuestStars),]
# What if we only wanted the rows when GuestStars is NOT NA - use !
office_df[!is.na(office_df$GuestStars),]
# You can also use na.omit, but this applies to the whole dataframe
na.omit(office_df)
# And again: if you want to work with a dataframe that has no missing guest stars, you must assign the df
office_gueststars <- office_df[!is.na(office_df$GuestStars),]

# Our numeric or integer columns don't having NA
# But I am going to add an NA to show you how to operate on cols with NA
office_df$Ratings[57] # gives us the rating for the 57th row
office_df$Ratings[57] <- NA # turn it to NA
# Now, let's try to get the average rating
mean(office_df$Ratings) 
# the whole thing is NA!!! But we WANT a mean, we just want to ignore NA
mean(office_df$Ratings, na.rm = TRUE)
# remember we can check for NAs
is.na(office_df$Ratings)
# but we don't want to sort through all that. Let's subset the dataset to when Ratings col
# contains NA. Recall from earlier
office_df[is.na(office_df$Ratings),]
# OR get the indices for when it = NA
which(is.na(office_df$Ratings))
# And then view the row 
office_df[57,]

####################################
# Dataframes: subsetting, strings
####################################
# dataframe[rows that you want,] (note the comma placement)
# dataframe[, columns that you want] (again note the comma placement)

# We worked a little with subsetting above, but let's dive in and really discuss it
# What if we only wanted episodes written by Mindy Kaling
mindy_df <- office_df[office_df$Writers == "Mindy Kaling",]
# We can also use subset()
mindy_df <- subset(office_df, Writers == "Mindy Kaling")
# BUT this doesn't account for episodes written by Mindy Kaling and someone else
# To deal with this, we have to use string operations. 
# We will use grep functions, but there is also a package called stringr that has the same type of functions
# grep functions look for patterns within strings
# Let's take a moment to explore grep functions before returning to subsetting
# Let's say I want anything that includes "Mindy Kaling", even if it's "Greg Daniels, Michael Schur, Mindy Kaling"
grepl("Mindy Kaling", office_df$Writers) # logical where TRUE is any row in Writers col that contains Mindy Kaling
# Recall from earlier that which() will give us the indices where the condition is true
which(grepl("Mindy Kaling", office_df$Writers)) 
# Working with strings and text in depth is beyond the scope of this course. Feel free to explore in your own time
# But we will now return to subsetting
# Continuing: From which(grepl("Mindy Kaling", office_df$Writers)), we have the indices
# of all rows where Writers contains "Mindy Kaling" -- both "Mindy Kaling" alone and anything that
# CONTAINS "Mindy Kaling" even with other text, like "Greg Daniels, Mindy Kaling".
# We could subset our data by  using these indices
# these are our indices 6   7  18  24  34  42  57  62  73  79  80  82  95  96 104 107 113 122 128 137 151 158
# and we can literally use c() and put a comma between them by hand
# but a less tedious way would be to save a vector
mindy_indices <- which(grepl("Mindy Kaling", office_df$Writers))
# and then subset the dataframe
office_df[mindy_indices,]
# What's happening here?
# First we name the dataframe: office_df[ ]
# The brackets say that you're going to take a subset of this dataframe that you're calling
# Inside the brackets tells R which way to subset it: mindy_indices
# and the comma goes after so R knows you're working with rows

# We found indices where "Mindy Kaling" is contained in the Writers column
# Then we assigned this as an object
# Then we subsetted our office_df by that object. (We did not assign it to anything, so it's not "saved")
# Is there an easier way? Could we smoosh some of these functions into one line? YES. 
# (And this time let's assign it)
mindy_df <- office_df[grepl("Mindy Kaling", office_df$Writers),]
# What did we do?
# We called office_df and used brackets [ ] to tell R we are subsetting
# Inside the brackets we used grepl because we want to subset to where a pattern is matched
# What pattern? "Mindy Kaling" What column? Writers
# And our comma after the grepl() before the end bracket says we are going rowwise

# What if we wanted all episodes written by Mindy Kaling and/or B. J. Novak
# Recall from earlier that we used == when it was just Mindy
office_df[office_df$Writers == "Mindy Kaling",]
# Now that we are looking for more than one thing, == does not always behave as expected
# I tested this out and it actually does behave here office_df[office_df$Writers == c("Mindy Kaling", "B. J. Novak"),]
# But when looking for more than one thing, you should defer to %in% instead of ==
office_df[office_df$Writers %in% c("Mindy Kaling", "B. J. Novak"),]
# Or you could split things up. Remember that | means or.
# This says subset to rows where Writers is Mindy Kaling OR where Writers is B. J. Novak
office_df[office_df$Writers == "Mindy Kaling" |  office_df$Writers == "B. J. Novak",]
# Here it is using subset()
subset(office_df, Writers == "Mindy Kaling" |  Writers == "B. J. Novak")

# Earlier we worked on how to deal with episodes Mindy cowrote, because == or %in% will only find exact matches
# grep is a little odd here. The function is
grepl("Mindy Kaling|B. J. Novak", office_df$Writers)
# The reason it's odd is because, due to the quote placement, this looks like it's saying:
# "Find where the Writers column contains this literal string "Mindy Kaling|B. J. Novak"."
# But what it really means is find where the writers column contains either Mindy Kaling or B. J. Novak.
# Note that if we incorrectly put spaces between the | sign, it will look for "Mindy Kaling " or " B. J. Novak"
grepl("Mindy Kaling | B. J. Novak", office_df$Writers)
# Here's how we subset to all rows where the Writers column contains either Mindy Kaling or B. J. Novak
office_df[grepl("Mindy Kaling|B. J. Novak", office_df$Writers),]

####################################
# Dataframes: subsetting, numbers
####################################
# What if we want to subset by years? Let's say we want every episode from 2009
# We don't have a year column. But remember, we made a datetime column. dmy(office_df$Date)
# So we can easily create a year column
office_df$year <- year(office_df$Date_datetime)
# Now we have a new column year, and we can subset on this
office_2009 <- office_df[office_df$year == 2009,]
# What if we want all years 2009 and below?
# You could literally list out the years and use year %in% c(list of years)
# But that's very tedious if you have a ton of years. So instead, use < or <=
office_2009_below <- office_df[office_df$year < 2010,] # years less than 2010
office_2009_below <- office_df[office_df$year <= 2009,] # years less than or equal to 2009
# What if we want to meet two conditions? Let's say years below 2007 or years above 2009
office_df[office_df$year < 2007 | office_df$year > 2009,]
# 2006 or before and rating above 8? 
office_df[office_df$year < 2007 & office_df$Ratings > 8,]
# There are other ways to do this. Let's cover one now. 
# ifelse(condition, value if condition is met, value if condition is not met)
?ifelse
office_df$year_rating <- ifelse(office_df$year < 2007 & office_df$Ratings > 8, 1, 0)
# You can also type out the arguments
office_df$year_rating <- ifelse(test = office_df$year < 2007 & office_df$Ratings > 8, yes = 1, no =0)
# The above line of code adds a variable (column) to the dataframe
# If the year is below 2007 and the rating is above 8, our new variable year_rating takes on the value of 1
# otherwise, it's 0. Then we can subset based on this column
office_df[office_df$year_rating == 1,]
# Here it is using subset()
subset(office_df, year_rating == 1)

# ifelse() is AWESOME, so let's do a couple more to get the hang of it
# What does the following function say to do? (What does each argument mean?)
ifelse(office_df$Ratings > mean(office_df$Ratings, na.rm = TRUE), "higher", "lower")
# What about this one?
ifelse(!(is.na(office_df$GuestStars)), "*", NA) # hint: ! means NOT
ifelse(test = !(is.na(office_df$GuestStars)), yes = "*", no = NA) # same thing with arguments typed out
# What about this one?
ifelse(grepl("Michael Schur|Paul Lieberstein|Greg Daniels", office_df$Writers), "yes", "no")


####################################
# Dataframes: subsetting columns!
####################################
# subset to specific columns that you want
# Having nothing before the comma tells R we want all rows
office_df[, c("Season", "EpisodeTitle", "Ratings", "Viewership", "year")]
# Same thing but using subset
# With subset(), you must use the argument titled "select" to tell R that you're talking about columns
# Without "select", it defers to "subset" since that's the second argument, and it gets confused because
# it thinks you mean rows
subset(office_df, c("Season", "EpisodeTitle", "Ratings", "Viewership", "year"))
subset(office_df, select = c("Season", "EpisodeTitle", "Ratings", "Viewership", "year"))
# We can give this new df a name. Let's take a peek at our old mindy_df again
mindy_df
# Now lets name our new df mindy_df. What happens to our old mindy_df?
mindy_df <- office_df[, c("Season", "EpisodeTitle", "Ratings", "Viewership", "year")]
mindy_df
# Our old mindy_df has been replaced.
# Why might you want to overwrite your datasets? If they are huge, you wouldn't
# want to be saving tons and tons of new, slightly different dfs to memory
# This will cause R to slow down and potentially eventually crash
# On the other hand, if your dataset is huge and takes forever to read in
# and if you are unsure about the function you are about to apply to it,
# you might create a new one (simply by using a different name so as to not overwrite it) to explore
# or you can first run your functions without assigning anything to see what happens
# before assigning that function/df as an object

# Back to column subsets
# If your columns are next to each other, you can use :
office_df[, 5:7]
subset(office_df, select = 5:7)
office_df[, c(2:5, 9:14)]
subset(office_df, select = c(2:5, 9:14))

# you can't mix indices and column names.


####################################
# Dataframes: merging
####################################
# Let's create two dataframes from our office_df so that we can learn to merge
# In practical use, you would not be separating your df into two dfs only to merge them back together
# You'd likely have two dfs. E.g. two dfs of insurgent groups from different sources, and you merge on group id
ep_desc_df <- office_df[, c(1:3, 9:12)]
ep_stats_df <- office_df[, c(2, 4:7, which(names(office_df) == "Date_datetime"))]
# Note: which(names(office_df) == "Date_datetime") is there to get the index # of the Date_datetime col,
# because you can't mix numeric indices and col names like c(2, 4:7, office_df$Date_datetime)

# We have two dataframes now: ep_desc_df and ep_stats_df
# We can take a look at them both and also make note of which columns might be the same between the two
# We have EpisodeTitle and Date_datetime in both. Let's try merging on one of them
merged_df <- merge(ep_desc_df, ep_stats_df, by = "EpisodeTitle")
# We can click to explore it. ALWAYS make sure your merges worked by comparing to the original DFs
# When we click we can see that it merged on EpisodeTitle! 
# But it did not merge on Date_datetime even though they are the same in both. Why?
merged_df <- merge(ep_desc_df, ep_stats_df, by = c("EpisodeTitle", "Date_datetime"))
# What if one df is shorter than the other?
# Let's arbitrarily make one of our df's shorter to explore what happens
set.seed(9986000) # set the random seed because we are going to sample() and we want to be able to reproduce it
ep_desc_df <- ep_desc_df[sample(nrow(ep_desc_df), 100), ]
# The above line says take ep_desc_df and subset [ ] it based on a sample
# Inside the sample function, nrow(ep_desc_df) = length of df, 100 = number we want to end up w/
# And assign it to ep_desc_df (which overwrites the old)
# Now let's merge
merged_df <- merge(ep_desc_df, ep_stats_df, by = c("EpisodeTitle", "Date_datetime"))
# We can see in the global environment that our merged dataframe is only 100 rows! 
# What if we want all 188? When you merge, the first df is x and the second is y
# Here, ep_stats_df is our longer one, so we use the argument all.y = TRUE
merged_df <- merge(ep_desc_df, ep_stats_df, by = c("EpisodeTitle", "Date_datetime"), all.y = TRUE)
# You do need at least one column in common to merge on. You can always rename a column if necessary.

# In the future we will work with tidyverse. It provides other ways to data wrangle
# RECAP:
# install.packages() and library()
# read.csv()
# calling columns with $
# deleting columns with df$column <- NULL
# subsetting with df[condition,] or df[, columns]
# subset()
# ifelse()
# merge()
# grepl() - not as important right now, but important that you know it's there
# which() - to get indices
# str(), summary(), names()
# is.na(), na.omit(), na.rm = TRUE
# datetime with lubridate


