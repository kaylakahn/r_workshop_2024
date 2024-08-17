####################################
# R Workshop August 2024 Day 3
####################################

#install.packages("ggplot2")
library(ggplot2)

# Plots!

# First we will read in our dataframe.
# Remember you might have to change your working directory or use the full filepath.
hp <- read.csv('hp_ao3.csv')
# source: scraped from ao3 using code from https://thaycarvalho.medium.com/the-harry-potter-fandom-on-ao3-9366a8824801

# This is the top 820 Harry Potter fanfictions on ao3 when sorted by kudos (likes)
# Let's explore the data.
str(hp)
# A lot of these read in as character when they should be numeric or integer.
# This is probably due to the commas.
as.integer(hp$Word_Count)
# That didn't work. We instead need to strip the commas. Remember grepl? Now we will use gsub
head(gsub(",", "", hp$Word_Count), 10) # Replace comma with nothing
# We can put this inside the as integer function and save it by assigning it to the df
hp$Word_Count <- as.integer(gsub(",", "", hp$Word_Count))
# Let's do this for the other columns
hp$Comments <- as.integer(gsub(",", "", hp$Comments))
hp$Kudos <- as.integer(gsub(",", "", hp$Kudos))
hp$Bookmarks <- as.integer(gsub(",", "", hp$Bookmarks))
hp$Hits <- as.integer(gsub(",", "", hp$Hits))
# Chapters is weird because it's showing how many chapters are complete out of how many chapters total.
# So let's just grab the top number.
# The gsub part says replace / and anything after it with nothing. Thus we are left with the top number
# If you are confused with the gsub part, that's ok. This is a bit too in depth, but we do need to do it, so it's here.
hp$Chapters <- as.integer(gsub("/.*", "", hp$Chapters))

# Now let's see some summary statistics
summary(hp)
# Also, having caps is annoying to me. Let's change that.
names(hp) <- tolower(names(hp))


####################################
# Plotting with base R
####################################

# We are now ready to plot. We will start with base R and then move to ggplot
# The most basic plot in R is a scatterplot
# Technically, integers are discrete, but we're going to treat them as continuous
plot(hp$word, hp$bookmarks)
# Another way
with(hp, plot(word_count, bookmarks))
# Changing the axis labels, add title
plot(hp$word_count, hp$bookmarks, 
     xlab = "Number of Words", ylab = "Number of Bookmarks", main = "Bookmarks and Fic Length")
# Change color with col and shape with pch
plot(hp$word_count, hp$bookmarks, 
     xlab = "Number of Words", ylab = "Number of Bookmarks", 
     main = "Bookmarks and Fic Length",
     col = "blue", pch = 2)
# Add line. lm() is the function for ols. Notice that y is first now.
abline(lm(bookmarks ~ word_count, data = hp), col = "red")
# Overlay points. We'll do green squares
points(hp$word_count, hp$comments, pch = 0, col = "green")
# And add another line
abline(lm(comments ~ word_count, data = hp), col = "purple")
# Add legend. Choose coordinates with first two args. lty is line type. cex is size.
legend(1, 35000, legend = c("Bookmarks", "Comments"),
       col = c("blue", "green"), pch = c(2,0), cex = 1)

# Make sure to change axis labels and title if necessary

# Boxplot
# create a new df with the ships we want so we don't have to do it every time
hp_ships <- hp[hp$ship %in% c("Sirius Black/Remus Lupin", "Draco Malfoy/Harry Potter", "Hermione Granger/Draco Malfoy", "Harry Potter/Ginny Weasley", "Regulus Black/James Potter"),]
# Do a chained ifelse so the tick labels are easier to deal with
hp_ships$ship_names <- with(hp_ships, 
                            ifelse(ship == "Draco Malfoy/Harry Potter", "Drarry",
                                   ifelse(ship == "Hermione Granger/Draco Malfoy", "Dramione",
                                          ifelse(ship == "Sirius Black/Remus Lupin", "Wolfstar", 
                                                 ifelse(ship == "Regulus Black/James Potter", "Jegulus",
                                                        ifelse(ship == "Harry Potter/Ginny Weasley", "Hinny", ship))))))


# We already learned how to add color and change axis labels so let's do it initially
boxplot(hp_ships$hits ~ hp_ships$ship_names, xlab = "ship", ylab = "hits", col=rainbow(4))
# The extreme outlier makes this UGLY. Let's get rid of it. For learning purposes.
boxplot(hp_ships$hits ~ hp_ships$ship_names, xlab = "ship", ylab = "hits",
        outline = FALSE, col=rainbow(4))
# Our tick labels are too big and therefore not printing fully. Let's change that
boxplot(hp_ships$hits ~ hp_ships$ship_names, xlab = "ship", ylab = "hits",
        outline = FALSE, cex.axis = .5, col=rainbow(4))
# Two dependent variables? 
boxplot(hp_ships$hits ~ hp_ships$ship_names, xlab = "ship", ylab = "hits",
        outline = FALSE, cex.axis = .5, col = "purple")
boxplot(hp_ships$kudos ~ hp_ships$ship_names, add = TRUE,
        outline = FALSE, cex.axis = .5, col = "green")
# That's very uninformative due to the distributions. Let's look at bookmarks and comments
boxplot(hp_ships$bookmarks ~ hp_ships$ship_names, xlab = "ship", ylab = "hits",
        outline = FALSE, cex.axis = .5, col = "purple")
boxplot(hp_ships$comments ~ hp_ships$ship_names, add = TRUE,
        outline = FALSE, cex.axis = .5, col = "green")

legend(4, 8000, legend = c("Bookmarks", "Comments"),
       col = c("purple", "green"), pch = c(2,0), cex = .8)
# Let's put them next to each other instead
boxplot(hp_ships$bookmarks ~ hp_ships$ship_names, xlab = "ship", ylab = "hits",
        outline = FALSE, cex.axis = .5, col = "purple",
        at = 1:length(unique(hp_ships$ship_names)) - 0.2)
boxplot(hp_ships$comments ~ hp_ships$ship_names, add = TRUE,
        outline = FALSE, cex.axis = .5, col = "green",
        at = 1:length(unique(hp_ships$ship_names)) + 0.2)
# Make them skinnier
boxplot(hp_ships$bookmarks ~ hp_ships$ship_names, xlab = "ship", ylab = "stats",
        outline = FALSE, cex.axis = .5, col = "purple",
        at = 1:length(unique(hp_ships$ship_names)) - 0.2,
        boxwex = .4)
boxplot(hp_ships$comments ~ hp_ships$ship_names, add = TRUE,
        outline = FALSE, cex.axis = .001, col = "green",
        at = 1:length(unique(hp_ships$ship_names)) + 0.2,
        boxwex = .4)
# What about two separate graphs next to each other?
par(mfrow = c(1, 2)) # 1 row 2 columns
boxplot(hp_ships$bookmarks ~ hp_ships$ship_names, xlab = "ship", ylab = "bookmarks",
        outline = FALSE, cex.axis = .5, col = "purple")
boxplot(hp_ships$comments ~ hp_ships$ship_names, xlab = "ship", ylab = "comments",
        outline = FALSE, cex.axis = .5, col = "green")
# To reset so 1 plot shows (it won't do anything until you run the next plot)
par(mfrow = c(1, 1))

# Barplot
# We will get a table of ship counts. How many fics per ship? 
ship_counts <- table(hp_ships$ship_names)
barplot(ship_counts, col =cm.colors(5))
# ylim or xlim to stop it from running off the axis 
barplot(ship_counts, col = cm.colors(5), ylim = c(0,300), main = "Fics per ship")
# Can turn it sideways
barplot(ship_counts, horiz = TRUE, cex.names = .8, col = cm.colors(5), xlim = c(0,300))
# fics per year
fics_year <- table(hp_ships$date)
barplot(fics_year, col=heat.colors(20), ylim = c(0,60), main = "fics per year")

# Histograms and Density Plots
plot(density(hp_ships$hits))
hist(hp_ships$hits)
# change the number of breaks
hist(hp_ships$hits, breaks = 40)

# ggplot
# We'll start with a scatterplot.
# We'll do word count and bookmarks like before
ggplot(data=hp_ships, aes(x = word_count, y = bookmarks)) + # this sets it up, but this alone won't add the points
  geom_point() # this adds the points
# Wow! It's super basic. Let's change the color
ggplot(data=hp_ships, aes(x = word_count, y = bookmarks)) + 
  geom_point(color = "violet") # fixed color
# But we can instead color it based on another variable! Here's if the variable is continuous (or "continuous")
ggplot(data=hp_ships, aes(x = word_count, y = bookmarks)) + 
  geom_point(aes(color = chapters))
# Here's if the variable is categorical
ggplot(data=hp_ships, aes(x = word_count, y = bookmarks)) + 
  geom_point(aes(color = ship_names))
# We can change the shape
ggplot(hp_ships, aes(x = word_count, y = bookmarks)) + 
  geom_point(aes(color = ship_names, shape = ship_names))
# We can change the size
ggplot(hp_ships, aes(x = word_count, y = bookmarks)) + 
  geom_point(aes(color = ship_names, shape = ship_names, size = date))
# That's super large. We can make them smaller by defining the range of sizes to stay within
ggplot(hp_ships, aes(x = word_count, y = bookmarks)) + 
  geom_point(aes(color = ship_names, shape = ship_names, size = date)) +
  scale_size_continuous(range = c(1, 4))
# We can also add labels. (And we will get rid of size)
ggplot(hp_ships, aes(x = word_count, y = bookmarks)) + 
  geom_point(aes(color = ship_names, shape = ship_names)) +
  geom_text(aes(label = title))
# Whoa!!!! We definitely don't want that. What if we label only the 10 most popular based on hits?
ggplot(hp_ships, aes(x = word_count, y = bookmarks)) + 
  geom_point(aes(color = ship_names, shape = ship_names)) +
  geom_text(data = hp_ships[order(-hp_ships$hits), ][1:10, ], aes(label = title))
# We need to make the text smaller
ggplot(hp_ships, aes(x = word_count, y = bookmarks)) + 
  geom_point(aes(color = ship_names, shape = ship_names)) +
  geom_text(data = hp_ships[order(-hp_ships$hits), ][1:10, ], aes(label = title), size = 2)
# Let's add a regression line
ggplot(hp_ships, aes(x = word_count, y = bookmarks)) + 
  geom_point(aes(color = ship_names, shape = ship_names)) +
  geom_text(data = hp_ships[order(-hp_ships$hits), ][1:10, ], aes(label = title), size = 2) +
  stat_smooth(method=lm)
# And we can change the legend location or suppress it
ggplot(hp_ships, aes(x = word_count, y = bookmarks)) + 
  geom_point(aes(color = ship_names, shape = ship_names)) +
  geom_text(data = hp_ships[order(-hp_ships$hits), ][1:10, ], aes(label = title), size = 2) +
  stat_smooth(method=lm) + 
  theme(legend.position="left")
# Although that is ugly so we will go back to right, which is default
# Let's add titles to the plot and the axes
ggplot(hp_ships, aes(x = word_count, y = bookmarks)) + 
  geom_point(aes(color = ship_names, shape = ship_names)) +
  geom_text(data = hp_ships[order(-hp_ships$hits), ][1:10, ], aes(label = title), size = 2) +
  stat_smooth(method=lm) + 
  labs(title = "HP Fanfiction", x = "Word Count", y = "Bookmarks")
  
# There are tons of options. When it comes time for you to plot stuff, you will probably
# end up looking up all sorts of options.
# Other types of plots will functions similarly, but I've included a few cool options for
# barplots and boxplots




# Grouped barplot
# dodge says to group them, identity says it takes on the value of itself
ggplot(data = hp_ships, aes(x = ship_names, y = kudos)) + 
  geom_bar(position = "dodge", stat = "identity", aes(fill = ship_category))

# Stacked barplot. All we change from before is position.
ggplot(data = hp_ships, aes(x = ship_names, y = kudos)) + 
  geom_bar(position = "stack", stat = "identity", aes(fill= ship_category))

# Boxplot 
ggplot(hp_ships, aes(x = ship_names, y = comments)) +
  geom_boxplot(aes(col = ship_names)) +
  scale_color_manual(values = c("lightgreen", "lightpink", "lightblue", "mediumslateblue", "lightsalmon" )) # choosing our own colors
# Rescale the axis. It will cut off the most extreme outliers but it won't remove all of them.
ggplot(hp_ships, aes(x = ship_names, y = comments)) +
  geom_boxplot(aes(col = ship_names)) +
  scale_color_manual(values = c("lightgreen", "lightpink", "lightblue", "mediumslateblue", "lightsalmon" ))  +
  scale_y_continuous(limits = c(0, 7500))
# Cool part: add points
ggplot(hp_ships, aes(x = ship_names, y = comments)) +
  geom_boxplot(aes(col = ship_names)) +
  scale_color_manual(values = c("lightgreen", "lightpink", "lightblue", "mediumslateblue", "lightsalmon" ))  +
  scale_y_continuous(limits = c(0, 7500)) +
  geom_jitter(color="black", size=0.4, alpha=0.9)

# Histogram 
ggplot(hp_ships, aes(x = chapters)) +
  geom_histogram()
# change bins by controlling the width
ggplot(hp_ships, aes(x = chapters)) +
  geom_histogram(binwidth = 3, fill = "lavender")
# change background 
ggplot(hp_ships, aes(x = chapters)) +
  geom_histogram(binwidth = 3, fill = "lavender") +
  theme_dark()
# overlapping
ggplot(hp_ships, aes(x = kudos, fill = ship_names)) +
  geom_histogram(position = "identity", alpha = .3, bins = 40) 
# mirror (doing it for density plot but it can also be done for histograms)
ggplot(hp, aes(x=x)) +
  geom_density(aes(x = bookmarks, y = ..density..), fill = "steelblue3") +
  geom_label(aes(x = 15000, y = .0001, label = "bookmarks")) +
  geom_density(aes(x = comments, y = -..density..), fill = "palevioletred") +
  geom_label(aes(x = 10000, y = -.0004, label = "comments"))


  
  




  




