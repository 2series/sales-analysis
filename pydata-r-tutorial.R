### Introduction to R, dplyr, and ggplot
### Authors: David Sung & Rihad Variawa
### Last Updated: 10/19/2018
### Created for the purposes of introducing R as a programming language

# This is a comment. A comment in programming is ignored by compiler. 
## A comment in R can be prefixed by any number of "#"

# To run the below command, you can:
#  1.) If you want to just run one line, click on the line, and select run or press 'cntrl + enter' or 'command + enter' if on Mac
#  2.) If you want to run both lines, highlight it, and select run or press 'cntrl + enter' or 'command + enter' if on Mac

# Operators
1 + 1 # addition
2 * 3 # multiplication
3 ^ 4 # exponential
12 / 4 # division
12 %% 4 # modulus
12 %% 5

# Logic
1 == 1
1 == 2
1 < 2
1 > 2
1 <= 2
1 >= 2
1 != 2
5%%2 == 1 # Modulus is used a lot of the time to see if a number if even or odd by dividing by two

# Different types of variables in R: numeric, logic, and character.
# Also notice that you can assign variables with either '<-' or '='.
# I tend to use '<-' to not confuse '=' with '=='
a <- 5
a = 7
b = TRUE
c = 'Hello'

str(c) # to see the type that it is

# In R, we will work with vectors and tables a lot.
# To create a vector, we are going to use the c() function
# When you see two closed parentheses (), that is a function.
vec1 <- c(1, 2, 3, 4, 5)
# Try running the below command. Use the environment to figure out what happened?
# What does this mean about vectors and lists in R?
vec2 <- c(1, 'text', TRUE)

# Run the below and observe the different computations you can do with vectors
?min # To see the help if you forgot what it does
min(vec1)
max(vec1)
mean(vec1)
sd(vec1)
length(vec1)

summary(vec1)

vec1 * 2
vec3 <- vec1 / 3

## Reading in a csv file
## Taken from: https://www.kaggle.com/kyanyoga/sample-sales-data/version/1#_=_
# If receiving an error like this, make sure to set your working directory!:
# Error in file(file, "rt") : cannot open the connection
# In addition: Warning message:
#   In file(file, "rt") :
#   cannot open file 'sales_data_sample.csv': No such file or directory
sales_data <- read.csv('sales_data_sample.csv')

# sales_data is a 'data.frame'. It is the main way that R deals with tables of data.
# click on the arrow next to sales_data in the Environment pane to see the data types of each column
# click on sales_data in the Environment pane to see the table. You can also type View(sales_data) to do this
View(sales_data)

# Can run summary to see a summary of the data
summary(sales_data)

# Or can run summary on individual columns
summary(sales_data$PRICEEACH)
summary(sales_data$PRODUCTLINE)
max(sales_data$SALES)
mean(sales_data$SALES)
min(sales_data$SALES)
sd(sales_data$SALES)

##################################################
#               dplyr Tutorial                   #
##################################################

# Install a library using the bottom right pane
# After installing run the below line
library(dplyr) # importing a library (like a tool box)

# We will now go through select(), arrange(), filter(), mutate(), group_by(), summarise()
# 1.) select() function
#     select specific columns
#     first argument is always the data set, and each argument after is the fields you want
select(sales_data, QUANTITYORDERED, PRICEEACH)

# don't forget to assign it!
select_data <- select(sales_data, QUANTITYORDERED, PRICEEACH)

# 2.) arrange() function
#     order your data
arranged_asc_data <- arrange(select_data, PRICEEACH)
arranged_desc_data <- arrange(select_data, -PRICEEACH)

# 3.) filter() function
#     filter out data
#     first argument is the dataset, second argument is the filter conditions
filtered_data <- filter(sales_data, STATE == 'NY')
filtered_data <- filter(sales_data, STATE == 'NY' & PRODUCTLINE == 'Classic Cars')

# If I want to 'filter' and 'select' data, I have to run the command twice
filtered_data <- filter(sales_data, STATE == 'NY' & PRODUCTLINE == 'Classic Cars')
select_data <- select(filtered_data, QUANTITYORDERED, PRICEEACH) # notice the first argument is filtered_data
arrange_data <- arrange(select_data, PRICEEACH) # notice the first argument is select_data

# It's kind of tedious to have to run the command twice, so we will use a concept called piping (%>%)
# Piping is sending the output of one function into the input of another. The output will be the first argument of the next function
# The same command above can be written like this:
piped_data <- sales_data %>%
  filter(STATE == 'NY' & PRODUCTLINE == 'Classic Cars') %>%
  select(QUANTITYORDERED, PRICEEACH) %>%
  arrange(PRICEEACH)

# 4.) mutate() function
#     create your own columns using mutate
mutated_data <- mutate(sales_data, discounted = 0.95 * SALES)
# Same as above but using piping
mutated_data <- sales_data %>%
  mutate(discounted = 0.95 * SALES)

# YOUR TURN!
sales_data <- read.csv('sales_data_sample.csv') # Reread the data in case you made any changes to it

# Q1: What is the most common deal size (column name: DEALSIZE)?
summary(sales_data$DEALSIZE)
# Medium

# Q2: What is the average quantity ordered? (HINT: Can also use mean function)
mean(sales_data$QUANTITYORDERED)
summary(sales_data$QUANTITYORDERED)

# Q3: Create a new dataset called q3_data with 
#       - a new column called MSRP_REV which is equal to the MSRP * QUANTITYORDERED
#       - filtered to only have 'Large' sized deals 
#       - with only the selected columns ORDERNUMBER, QUANTITYORDERED, PRICEEACH, MSRP, SALES, MSRP_REV
#       - ordered in descending order by SALES
q3_data <- sales_data %>% 
  mutate(MSRP_REV = MSRP * QUANTITYORDERED) %>% 
  filter(DEALSIZE == 'Large') %>% 
  select(ORDERNUMBER, QUANTITYORDERED, PRICEEACH, MSRP, SALES, MSRP_REV) %>% 
  arrange(-SALES)



# 5.) group_by() and summarise() function
#     group_by() and summarise() will help us solve questions such as, what are the total sales by country?
grouped_data <- group_by(sales_data, COUNTRY)
summarised_data <- summarise(grouped_data, total_sales = sum(SALES))
# Same as above but using piping
summarised_data <- sales_data %>%
  group_by(COUNTRY) %>%
  summarise(total_sales = sum(SALES))

# Instead of sum(), can also do max(), min(), mean(), n() for count, and others

# Q4: What is the average SALE by PRODUCTLINE?
summarised_data <- sales_data %>% 
  group_by(PRODUCTLINE) %>% 
  summarise(average_sales = mean(SALES))


##################################################
#               ggplot Tutorial                  #
##################################################

library(ggplot2)

# Great resource for ggplot: https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf

# Creating a simple dot plot
ggplot(sales_data, aes(x = QUANTITYORDERED, y = SALES)) +
  geom_point()

# Can change colors
ggplot(sales_data, aes(x = QUANTITYORDERED, y = SALES)) +
  geom_point(aes(color = 'red'))

# Can add labels and remove legend
ggplot(sales_data, aes(x = QUANTITYORDERED, y = SALES)) +
  geom_point(aes(color = 'red')) +
  labs(title = 'Sales and Quantity Ordered',
       y = 'Unit Price ($)',
       x = 'Quantity Ordered (Units)') + 
  theme(legend.position="none")

# Can add regression line
ggplot(sales_data, aes(x = QUANTITYORDERED, y = SALES)) +
  geom_point(aes(color = 'red')) +
  labs(title = 'Sales and Quantity Ordered',
       y = 'Unit Price ($)',
       x = 'Quantity Ordered (Units)') + 
  theme(legend.position = "none")+
  geom_smooth(method = "lm")

# Bar charts
# Will first create a grouped by and summarised dataset
status_data <- sales_data %>%
  group_by(STATUS) %>%
  summarise(total_count = n()) %>%
  select(STATUS, total_count)

# Now we will create a bar chart
ggplot(status_data, aes(x = STATUS, y = total_count)) +
  geom_bar(stat = 'identity', color = 'red', fill = 'blue') 


# Your turn!
# Q5: Create a bar chart of the total sales by country with the following properties:
#     - x axis label: Product Line
#     - y axis label: Total Sales ($)
#     - title: Sales by Product Line
#     - Outline of bars: red
#     - Fill of bars: pink

# Will first create a grouped by and summarised dataset
status_data <- sales_data %>%
  group_by(PRODUCTLINE) %>%
  summarise(total_sales = sum(SALES))

# Bar plot
ggplot(status_data, aes(x = PRODUCTLINE, y = total_sales)) +
  geom_bar(stat = 'identity', color = 'red', fill = 'pink') +
  labs(title = 'Sales by Product Line') +
  theme_classic() +
  coord_flip()
            
# Challenge: What can you do to make your chart look cleaner? Try using the cheat sheet or google to make it better!



# Q6: Using the ggplot2 cheat sheet, try constructing your own plot of choice!
# Bar plot
ggplot(status_data, aes(x = PRODUCTLINE, y = total_sales)) +
  geom_bar(stat = 'identity', color = 'red', fill = 'yellow') +
  labs(title = 'Sales by Product Line') +
  theme_classic() +
  coord_polar()
