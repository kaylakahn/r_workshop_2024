####################################
# R Workshop August 2024 Day 4
# Kayla Kahn
####################################

# Today we will work with control structures and simulations
# Thank you to Tuba Sendinc who taught this workshop last year - I am heavily following her code today

# if and else: code to be executed when condition is true, code to be executed when condition is false

# for loop: loop over a vector or dataframe and execute code at each index

# while loop: execute code while a condition remains true

# repeat loop: execute code until an explicit break written in the loop (infinite loop)

# Also important to know:
# break - to break out of a loop
# next - to skip an iteration in a loop

# ifelse() might serve your purposes better than if/else
# The apply family of functions (apply, lapply, sapply, mapply) are better than loops in some cases
# We also have user defined functions - you can create your own functions


####################################
# if/else
####################################

# We will begin with if/else
set.seed(9986000) # set random seed
x <- rnorm(n = 1, mean = 0, sd = 1) # generate a random number following normal distribution. first argument is how many numbers to gen
print(x)

# Let's put it into if/else
if(x > 0) { 
  y <- 5 
} else { 
  y <- -6 
}
# generate an object "y" which is equal to 5 if x > 0 and equal to -6 if x <= 0

# We did that on one number. Let's try it on a vector of many numbers.
# We will redefine x using rnorm again, but this time generate 25 numbers.
x <- rnorm(25, 0, 1)
if(x > 0) { 
  y <- 5 
} else { 
  y <- -6 
}

# R does not like this. It doesn't recognize that you want it to be applied to each element of the vector.
# Instead, it's saying "Hey, this condition is both true and false depending on which element I look at,
# so I'm just going to give you the first one." 
# To get the outcome we intended, you would have to loop over the vector, which we will do in a moment 
# or use a vectorized function... ifelse() 
y <- ifelse(test = x > 0, yes = 5, no = -6)
y

####################################
# for loops
####################################

for(i in 1:10) {
  print(i)
}
# Go 1 through 10 and for each i, print the i'th value
# i is a placeholder name. We can call it anything
for(index_number in 1:10) {
  print(index_number)
}

# What if we want to add 5 to every number in the x vector
for(i in 1:length(x)) {
  x + 5
}
# Now we can look at x
x
# But x didn't seem to change
# Recall that we can access an element of a vector using brackets [ ]
x[3]
x[7]
# In this loop we are saying FOR EACH ELEMENT of vector x, add 5
# So how would we access the element? 
# Use x[i]
for(i in 1:length(x)) {
  x[i] + 5
}
x
# But it still didn't appear do anything! 
# Because we weren't assigning it to anything.
# What we just ran is very similar to just saying "x + 5", which prints the operation output into the console, 
# but it doesn't change anything
x + 5
x

# So let's put together everything we've covered to make this work
for(i in 1:length(x)) {
  y[i] <- x[i] + 5
}
y

# What did we do?
# for(i in 1:length(x)) says that we're going to do something for every i (index) from 1 to the length of x
# We know x is 25, so (i in 1:25) would work too
# "y[i] <-" says we're creating an object y and it's going to have as many elements as i
# if we just did "y <-", we'd be overwriting y with each i of the loop, so at the end, y would be x[25] + 5 (the last i in the loop)
# "x[i] + 5" says y will take on the value of x + 5, but for each i
# if we said "x + 5", it'd still be 25 long because of y[i], but it would have 25 elements all equal to the first x + 5 in the loop because it doesn't know to move on

# Let's go back to our if/else statement that didn't work how we wanted and put it in the for loop
for(i in 1:length(x)) {
  if(x[i] > 0) { 
    y[i] <- 5 
  } else { 
    y[i] <- -6 
  }
}
y
# What did we do?
# for(i in 1:length(x)) --- for every index value from 1 to the length of x
# if(x[i] > 0) --- if x at THAT SPECIFIC INDEX VALUE is greater than 0
# y[i] <- 5 --- then y at THAT SPECIFIC INDEX VALUE is equal to 5
# else  --- but if x at THAT SPECIFIC INDEX VALUE is not greater than 0
# y[i] <- -6  --- then y at THAT SPECIFIC INDEX VALUE is equal to 6

# Clarity: we are not saying if the index value is greater than 0
# We're saying if x at the index value is greater than 0
# So if the index value is 7, it's not 7, it's x[7]
x[7]
# And we evaluate whether that is greater than 0

# In some instances, you might need to initialize a vector (or df) outside of the loop
# in order to store the loop results. 
z <- rep(NA, 10) # create vector of 10 elements all filled with NA
z <- vector() # create an empty vector




####################################
# user defined functions
####################################
# These functions are useful when you need to repeat a series of functions or apply them broadly
# and can't find a way to do this.

# The structure is like this
# name_of_function <- function(arguments_in_function) {
  #function
#}

# Here is a simple example
add5 <- function(x) {
  x + 5
}
# And once you create your function you can use it
add5(20)
# function(x) doesn't mean you have to apply your function to something called x
# Instead, it means that your function has one argument. Like this:
add5(x = 20)
# That should look familiar because we've been working with functions that have arguments
rnorm(n = 5)
merge(x = df1, y = df2, by = column) # don't run (we don't have these dfs)
add5(x = c(1, 4, 8))

# Functions can have multiple arguments
x_plus_y <- function(x, y){
  x + y
}
x_plus_y(10, -5)
x_plus_y(x = 10, y = -5)

# You can set the default value for arguments
x_plus_y <- function(x, y = 1){
  x + y
}
x_plus_y(x = 10) # y = 1 because it is the default 
# default value is like how in rnorm we have a default mean of 0 and sd of 1 but we can change it
rnorm(10, mean = 7, sd = 10)
x_plus_y(x = 10, y = -5) 

# You can put control structures or loops into functions
# Let's make a function that adds 5 to every element of x
add5 <- function(x){ 
  for(i in 1:length(x)) {
    x[i] <- x[i] + 5
  }
}

y <- runif(n = 15) # drawing from uniform distribution this time
y
print(add5(y))
y

# Our function didn't work. Why?
# Inside the function, you create a local environment. 
# Whatever happens in the function stays in the function
# UNLESS you tell it to move to the global environment
# So when we ran that function, we did change x, but only in the local environment
# We must return a value

add5 <- function(x){ 
  for(i in 1:length(x)) {
    x[i] <- x[i] + 5
  }
  return(x)
}
y
add5(y)



####################################
# simulating data
####################################

# Let's try a more complicated for loop.
# What if we want to randomly draw a number from a normal distribution 
# but we want to change the mean and sd each draw?

# Decide n 
n = 300 # our loop will run for 300

# Let's remind ourselves how to draw one number from a normal distribution
rnorm(1) # this has mean = 0 and sd = 1
# Let's put that into a loop
for (i in 1:n) {
  rnorm(1)
}

# That gives us 300 draws from rnorm, but we want to vary the mean and sd each time
# We can sample() for the mean and sd
# and we use seq() inside sample because sample is meant for integers only
ex_mean <- sample(seq(-10, 10, by = 0.1), 1) 
ex_sd <- sample(seq(0.1, 5, by = 0.01), 1) 
rnorm(1, mean = ex_mean, sd = ex_sd)

#Let's add it to the loop
set.seed(1)
for (i in 1:n) {
  mean <- sample(seq(-10, 10, by = 0.1), 1) 
  sd <- sample(seq(0.1, 5, by = 0.01), 1) 
  number <- rnorm(1, mean, sd)
}
# The reason we haven't done anything with [i] yet is because our loop is saying
# For the first i, randomly draw the m (mean) and s (sd), and then draw our number
# using that mean and sd. 
# For the second i, randomly draw the m (mean) and s (sd) ......
# It overwrites with each new i. 

# But we need to save our loop results at every i. Right now it runs but we can't see the results
# We'll initialize an empty dataframe to store our loop results
df <- data.frame(matrix(ncol = 3, nrow = n)) # create df of 3 columns and n (300) rows
colnames(df) <- c("number", "mean", "sd")

# We want to store the results at each i into the df. This is where [i] comes in
for (i in 1:n) {
  print(i)
  mean <- sample(seq(-10, 10, by = 0.1), 1) 
  sd <- sample(seq(0.1, 5, by = 0.01), 1) 
  number <- rnorm(1, mean, sd)
  
  df$mean[i] <- mean # df$mean at the current i takes on the current value of m
  df$sd[i] <- sd
  df$number[i] <- number
}
# Let's view our df
df

# Let's recap what happens in the loop
# for (i in 1:n) -- for every i from 1:300
# mean <- ... we get a value of mean by sampling 1 number from a large group of numbers
# sd <- ... we get a value of sd by sampling 1 number from a large group of numbers
# number <- ... we get a value of number by drawing 1 value from rnorm
# but we give it the ith mean and ith sd 
# df$mean[i] <- mean -- the ith element of df$mean will take on the currently defined mean (because we are currently on ith iteration)



# using rnorm to get mean and sd in rnorm draw
rnorm(1, mean = rnorm(1), sd = rnorm(1, mean = 3, sd = 2))

# remove object from global environment
rm(mean)





