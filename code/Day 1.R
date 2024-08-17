####################################
# R Workshop August 2024 Day 1
# Kayla Kahn
####################################

# Some basics to begin:
# File -> New File -> R Script to start an R Script
# R Script is what we are using right now
# When you run lines they will print to the console - the box on the bottom left
# When you assign objects (more on that later) they will show up in the global environment (top right)
# You can save R Scripts to open and work on them later. 
# If you only type in the console, you won't be saving it
# Generally only type to about 80 characters before next line 

# You can run your code by placing your cursor on the line you want and clicking
# the button near the top that says 'Run'
# But a much easier way is cmd + enter on mac or ctrl + enter on pc
# When you run, it will skip to run the first line of code from wherever your cursor is.
# I.E. it won't run the comments (unless you highlight the line)

# Using a # begins a comment
Without a pound sign, you are printing code
# If you try to run the above line, you will get an error 
# Let's try running a function.
print("Hello, world!")
# This works! What about...
print(Hello, world!)
# Why do we get an error on the above line? What we should have is a string.
# Strings need to be encased in quotes.
# What about this?
print(1)
# Why does this run? Because it's a numeric and not a string, so you don't need quotes

####################################
# Object Assignment
####################################
# In  R, you assign objects. If we print the variable x before assigning anything, 
# we will get an error because we haven't assigned x to mean anything
x
# But we can assign x to mean something.
# Use <- to assign objects. 
x <- 5
# Now you can print the object you just assigned to see what it is.
# (You can also see it appear in the global environment, probably in the upper right of your RStudio)
x
# You can also change the assignment, but R will forget the old assignment
x <- 10
x
# And you can assign an object to be another object
m <- x
m
# Objects are case sensitive, so we have an x and an m but no X or M
x
X

####################################
# Operators
####################################
# Arithmetic
2 + 2 # addition
2 - 2 # subtraction
2 * 2 # multiplication
2 / 2 # division
2 %% 2 # Modulus, remainder
2^2 # Exponentiation

# Logical
2 > 2 # greater than
2 < 2 # less than
2 <= 2 # less than or equal to
2 >= 2 # greater than or equal to
2 == 2 # exactly equal to
2 != 2 # not equal to

# Other
sqrt(4) # square root
log(4) # natural log
exp(4) # exponentiates 

# We can use operators on objects we have assigned
y <- 10
z <- 40
y + z
y - z
y == z
sqrt(y)
z+50
y/10
m == x # (from earlier)

n <- y - 40 # new object based on already existing object - 40
n <- y + z

####################################
# Object Assignment
####################################
# multiple ways to create a sequence
1:10 
c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10) # c() is combine
seq(10) 
seq(.1, 1, by = .1)

seq(1, 10, by = 2) # by increments of 2
rep(1:3, 2) # repeat 1 to 3 twice


####################################
# Data Types
####################################
# We have 5 basic data types
# Numeric: 5, 34.4, 6, .0152
# Integer: 5, 6, 10, 50, 5000
# Logical: TRUE, FALSE (also T, F)
# Character: "Hello, world!"
# Complex: 5+ 7i. You probably won't be using this data type

# How do we know the data type? We can use the 'class' or 'str' (structure) function
x # 5, 10, 15, 20
class(x)
str(x)
# To create an integer vector, you need L
x <- c(5L, 10L, 15L, 20L)
class(x)
# Or you can "coerce" it to a different type.
x <- as.numeric(x)
class(x)
x <- as.integer(x)
class(x)
# Could we coerce character to numeric? Let's see what happens
string_nums <- c("5", "10", "15", "20")
class(string_nums)
as.numeric(string_nums)
foods <- c("pizza", "sushi", "salad", "sandwich")
as.numeric(foods)
# In some cases, you may need R to treat your variable as categorical rather than numeric
x_factor <- as.factor(x)
str(x_factor)


####################################
# Vectors
####################################
# In R, we work with vectors. These are a "collection" of "elements"
# Each part of a vector is an element.
x
string_vector <- c("Charles", "Erik", "Logan", "Jean", "Raven")
str(string_vector)
# What happens when vectors contain elements of different types? 
mixed_vector <- c("Charles", 5, "11", TRUE)
# It turns each element into a string. What about without character?
mixed_vector <- c(5, 10, TRUE)
# It treats everything as numeric. TRUE/FALSE becomes 1/0
# let's go back to string_vector
string_vector
# If you want to see if a vector equals another vector, you use ==
y == z
# What if you want to see if an element is in a vector (collection of elements?)
"Erik" == string_vector
# But if our vector contains millions of elements, we can't spend all that time looking through
# so many FALSEs to find one TRUE! We might not even be able to print every element! TRUE might be hidden
# instead of ==, use %in%
"ERIK" %in% string_vector
# Or we can use which() to find at which element it is TRUE
which(string_vector == "Jean")
which(string_vector == "Charles")

# We can extract elements from our vectors by indices
string_vector[4]

# We can add numeric or integer vectors
x + x
x + y

####################################
# Lists
####################################
# Recall that a vector contains elements. One element per "slot"
# A list is a vector that can contain vectors. So a "slot" could be an entire vector
list_example <- list(mixed_vector, x, 3, string_vector, 400L)
list_example

class(list_example)
str(list_example)
# Let's use two ways to get the second element, which is the integer vector containing 5, 10, 15, 20
list_example[2] # second element in the list 
list_example[[2]] # second element but not in list structure
str(list_example[2])
str(list_example[[2]])
# How could we access an element within a vector within the list?
# What if we wanted the third element of the list containing 5, 10, 15, 20
# [[2]] (double brackets) takes us to the second element of the LIST, which is a vector
# [3] (single brackets) then takes us to the third element of that vector
list_example[[2]][3]

# We cannot add lists like we do with vectors
list_example + list_example
list_example[2] + list_example[2]
# but we can access that vector inside the list and add it
list_example[[2]] + list_example[[2]]
# We get an error here. Why?
list_example[[2]] + list_example[[1]]

####################################
# Matrices and Dataframes
####################################
# A matrix is vectors of the same type set up into a fixed number of rows and columns
matrix1 <- matrix(1:9, byrow = TRUE, nrow = 3)
# A few things to note:
# matrix() is the function we used to create the matrix
# We name our matrix matrix1 instead of matrix because we don't want to override the function!
# 1:9 is the same as saying c(1, 2, 3, 4, 5, 6, 7, 8, 9)
# byrow = TRUE tells it to fill the matrix by rows. FALSE would fill by columns
# nrow = 3 says 3 rows
# We can print our matrix with matrix1 or we can view it by clicking it in the global environment or View(matrix1)
matrix1
# We can access the row and column names
rownames(matrix1)
colnames(matrix1)
# Right now we don't have names. But we can create them. Note that names can't start with a number.
rownames(matrix1) <- c("row1","row2","row3")
colnames(matrix1) <- c("col1","col2","col3")
# Now let's try accessing the row and column names again
rownames(matrix1)
colnames(matrix1)

# There are other ways to create a matrix. 
a <- c(1, 2, 3)
b <- c(4, 5, 6)
rbind(a, b) # bind by row
cbind(a, b) # bind by column
# Note that we did not assign either to an object, so the only matrix we have right now is still matrix1
# see class
class(rbind(a, b))

# What if we want to add a dimension to our matrices? We use an array
array(1:15, dim=c(5,3,2)) # rows, 3 cols, 2 matrices
# Why would we do this?

# Dataframes can have different types of vectors, whereas matrices need the same types.  
df1 <- data.frame(c('cat', 'dog', 'bird', 'fish'),
                  c(4, 4, 2, 0),
                  c(0, 0, 2, 0),
                  c(FALSE, FALSE, FALSE, TRUE))
# This is very ugly. How can we rename the columns?
# Well, we can do it when we create the df
df2 <- data.frame(animal = c('cat', 'dog', 'bird', 'fish'),
                  legs = c(4, 4, 2, 0),
                  wings = c(0, 0, 2, 0),
                  scales = c(FALSE, FALSE, FALSE, TRUE))
# Or we can use functions
colnames(df1) <- c('animals', 'legs', 'wings', 'scales')
# We can even do one at a time like this:
# colnames(df)[colnames(df) == 'oldName'] <- 'newName'
colnames(df1)[colnames(df1) == 'scales'] <- 'gills'
# This says we're accessing the column names of df1, and then we're specifically accessing where
# the column name is scales, and we want to change it to gills.
# This second way is a bit much for the first day, but now you know it exists. 
# As we work more with datasets, you will become more familiar with using brackets to operate on dataframes

# Let's look at the structure of our df
str(df1)
# Could we turn a matrix to a df?
as.data.frame(matrix1)
# What about df to matrix
as.matrix(df1) 


# We will talk more about dataframes and functions in upcoming lessons.
# But we have already used some functions! For example, 
# c(), matrix(), as.data.frame(), str(), class() are functions!

# What if you need help?
?data.frame # pull up help tab (bottom right in R Studio)
help(data.frame) # same thing
example(data.frame) # shows example

