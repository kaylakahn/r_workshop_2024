####################################
# R Workshop August 2024 Day 5
####################################

# Best practices
# https://style.tidyverse.org

# typically try not to pass 80 characters per line even though I break that in this lesson
# snake_case instead of camelCase or PascalCase or smushtogether
# space after comma
# spaces before and after operators. object <- thing instead of object<-thing
# but no spaces with ^, :, $, []
# assign left. z <- sample(1:100, 10) instead of sample(1:100, 10) = z
# use "" instead of '' unless you need to quote inside a quote
# You will pick this up as you read others' example code.
# Most importantly, pick something and stick with it.
# e.g. Within one script don't randomly switch naming conventions or the way you do spacing


# Today we will learn about data wrangling with the tidyverse, with attention paid to dplyr
# Extremely good tidyverse guide https://modern-rstats.eu/descriptive-statistics-and-data-manipulation.html - chapter 4
library(dplyr)
library(lubridate)

# We will return to the dataset we worked with on Tuesday
office_df <- read.csv("the_office_series.csv", na.strings = "")
names(office_df) <- tolower(names(office_df))

# select() is for columns and filter() is for rows
# We removed column X by using office_df$X <- NULL
# But we can use dplyr
office2 <- select(office_df, !x)
# But something amazing about dplyr is the pipe %>%
office2 <- office_df %>%
  select(!x)
# Or you could select all columns except the first
office2 <- office_df %>%
  select(season:writers)
# Maybe we only want numeric columns
office2 <- office_df %>%
  select(where(is.numeric))

# What about rows
# What if we only wanted episodes written by Mindy Kaling
# previous: office_df[office_df$Writers == "Mindy Kaling",]
mindy_df <- office_df %>%
  filter(writers == "Mindy Kaling")
# previous: office_df[grepl("Mindy Kaling", office_df$Writers),]
mindy_df <- office_df %>%
  filter(grepl("Mindy Kaling", writers))
# Mindy Kaling or B. J. Novak?
mindy_df <- office_df %>%
  filter(writers == c("Mindy Kaling", "B. J. Novak"))
# Something is weird... why only 14 observations when with just mindy it was 20?
# This is why we discussed %in% on Tuesday
mindy_df <- office_df %>%
  filter(writers %in% c("Mindy Kaling", "B. J. Novak"))

# We can chain operations. This is when the pipe becomes useful
# Let's say we want ratings above 8, and we only want columns episodetitle, about, and director
office2 <- office_df %>%
  select(episodetitle, about, director) %>%
  filter(ratings > 8)
# What does the error tell us? Why?
office2 <- office_df %>%
  filter(ratings > 8) %>%
  select(episodetitle, about, director) 

# We can rename too
office2 <- office_df %>%
  filter(ratings > 8) %>%
  select(episodetitle, about, director) %>%
  rename(episode_title = episodetitle) # new = old

# summarize() (also summarise()) is a function you might end up working with a lot
# Let's say we want the mean and sd of the ratings column
# (This time we won't assign an object - we'll just look in the console)
office_df %>%
  summarize(mean = mean(ratings), max = max(ratings))
# That isn't too informative. It might be better to get the mean and sd of ratings by year
# First, we need a year column
office_df$year <- year(dmy(office_df$date))
# Now we can use dplyr to group by the year
office_year_ratings <- office_df %>%
  group_by(year) %>%
  summarize(mean = mean(ratings), max = max(ratings))

office_year_ratings
# This output is a "tibble" and not a dataframe
# In many circumstances, functions treat the two the same. In other cases...
as.data.frame(office_year_ratings)

# Return to summarize()
# We want to summarise a lot of columns! Let's try it with just one function first
# We will use the function across() inside summarize()
# And earlier, we actually named something mean, so we need to remove it so R recognizes the function
rm(mean)
office_df %>%
  group_by(year) %>%
  summarize(across(ratings:duration, .fns = mean, .names = "mean_{col}"))
# Use {} to dynamically refer to columns instead of typing them out

# Here are some other very similar things we can do
# Summarize across all numeric columns
office_df %>%
  group_by(year) %>%
  summarize(across(where(is.numeric), .fns = mean, .names = "mean_{col}"))

# Summarize across all columns starting with a certain letter
# (first we will need to rename some columns to illustrate what happens)
office_df %>%
  rename_with(.fn = ~ paste0("k_", .), .cols = c(ratings:duration)) %>%
  group_by(year) %>%
  summarize(across(starts_with("k_"), .fns = mean, .names = "mean_{col}"))

# What if we want to apply more than one function?
office_df %>%
  group_by(year) %>%
  summarize(across(ratings:duration, .fns = list(mean = mean, max = max, min = min), .names = "{.fn}_{.col}"))

# Grouping by more than one column
office_df %>%
  group_by(year, month(dmy(date))) %>%
  arrange(year, month(dmy(date))) %>% # sort by years then months
  summarize(across(ratings:duration, list(mean = mean, max = max, min = min), .names = "{.fn}_{.col}"))

# Applying different functions to different columns
# We want all episode titles and all writers and we just want to separate them by ;
# We want the highest rating and viewership for that year-month
# And we want the mean votes
# And the first about and first director
# Then just a count of episodes

office_df_yrmonth <- office_df %>%
  group_by(year, month(dmy(date))) %>%
  summarise(across(.cols = c(episodetitle, writers), .fns = ~ paste(., collapse = "; ")),
            across(.cols = c(ratings:viewership), .fns = max),
            across(.cols = votes, .fns = mean), # could also use mean(votes)
            across(.cols = c(about, director), .fns = first),
            num_eps = n()
            )
# Side notes, not super important to know right now:
# ~ in this sense is different than ~ in regression models
# ~ here is for an anonymous function. Telling R that we're using a formula
# . refers to the current value of the column. or you can also think of it as referring to itself


# mutate() is used to create new columns
# When we use summarize(), we are shrinking our dataframe, so we can only do summary type statistics.
# But we might need to apply functions to the whole dataframe, like log 
# Let's divide duration by 60 minutes
office_df <- office_df %>%
  mutate(hours = duration/60)
# We can do multiple at once, like with summary
office_df %>%
  mutate(across(where(is.numeric), .fns = log, .names = "log_{col}"))
# You can also use mutate() to do summary statistics without collapsing your data
office2 <- office_df %>%
  group_by(year) %>%
  mutate(across(where(is.numeric), .fns = list(mean = mean, max = max), .names = "{fn}_{col}"),
         across(where(is.character), .fns = ~ first(na.omit(.)), .names = "first_{col}"))
# quickly make sure the mean was calculated correctly... should match the first in the df
office_df %>% 
  filter(year==2005) %>% 
  summarise(mean(ratings)) 

# There are many more important functions like pivot_wider() and slice()
# There is also a series of join functions that are very similar to base R's merge()
?left_join



