# https://www.youtube.com/watch?v=kIKg5s_jDAk

#####           Dealing w/ missing values         ######

##|- 1) Do nothing
##|- 2) Delete
##|- 3) Replace
##|- 4) Impute


library(tidyverse)
library(naniar)     #visualise missing data
library(gtExtras)   #create beautiful tables

View(airquality)
View(starwars)

######           Magnitude of missing data          #####

#*** my work to understand the piping below

heller <- miss_var_summary(airquality)
table_x <- gt(heller)
table_viz <- gt_theme_guardian(table_x)
(table_viz2 <- tab_header(table_viz, title = "Missingness of variables"))
rm(list = ls())
#**** End of my work

### Table
?miss_var_summary
?gt
?tab_header
miss_var_summary(airquality) %>%
  gt() %>%                                        # everything from here is just themes
  gt_theme_guardian() %>%                         #...
  tab_header(title = "Missingness of variables")  #...

#plot missing values

gg_miss_var(airquality)


## Table of observations with missing data
airquality %>%
  filter(!complete.cases(.)) %>%        # recall ! => NOT complete cases; (.) => ALL of the data
  head(10) %>%
  gt() %>%
  gt_theme_guardian() %>%
  tab_header(title = "Rows that contain missing values")


### The distribn. of the missing data

vis_miss(airquality)    #numerical distribn of where the values are missing in the number spread

### The rel. to one variable:
airquality %>%
  mutate(
    Missing_Ozone = factor(is.na(Ozone),
                           levels = c("TRUE", "FALSE"),
                           labels = c("Missing", "Not Missing")
                           )
    ) %>%
  ggplot(aes(x= Wind, fill = Missing_Ozone)) +
  geom_histogram(position = "stack") +
  labs(title = "Distribution of Wind Speeds for Missing vs Non-Missing Ozone Values",
       x = "Wind speed",
       y="Ozone Observations",
       fill = "Missingness") +
  theme_bw()

#lets switch arnd the true and false => we can see the 'at a glance' numerical distribn of missingness at the bottom of the stack

airquality %>%
  mutate(
    Missing_Ozone = factor(is.na(Ozone),
                           levels = c("FALSE", "TRUE"),
                           labels = c("Not Missing", "Missing")
    )
  ) %>%
  ggplot(aes(x= Wind, fill = Missing_Ozone)) +
  geom_histogram(position = "stack") +
  labs(title = "Distribution of Wind Speeds for Missing vs Non-Missing Ozone Values",
       x = "Wind speed",
       y="Ozone Observations",
       fill = "Missingness") +
  theme_bw()

### Rel. to two variables

airquality %>%
  select(Ozone, Solar.R, Wind, Temp) %>%
  ggplot(aes(x = Wind,
             y = Temp,
             size = Solar.R,
             colour = is.na(Ozone))) +
  geom_point(alpha = 0.7) +
  facet_wrap(~is.na(Ozone)) +
  labs(title = "Missing Ozone Data by Wind and Temperature",
       color = "Missing Ozone data",
       y = "Temperature",
       x = "Wind speed") +
  theme_bw()


#####     Handling Missing data       #####

#**** First let's visualise like we learnt:

miss_var_summary(starwars) %>%
  gt() %>%                                        
  gt_theme_guardian() %>%                         
  tab_header(title = "Missingness of variables")

gg_miss_var(starwars)
  

starwars %>%
  filter(!complete.cases(.)) %>%        # is.na() works as well as !complete.cases()
  head(10) %>%
  gt() %>%
  gt_theme_guardian() %>%
  tab_header(title = "Rows that contain missing values")          #doesn't work due to nature of the data - when i try a variable (e.g hair_color) with missing values, it works


#*** End of my work


## 1)) Drop missing value => almost always a mistake, see below

#tabulate the missing values:
starwars %>%
  select(name, mass, height, hair_color) %>%
  head(15) %>%
  gt() %>%
  gt_theme_guardian() %>%
  tab_header(title = "starwars characters") %>%
  gt_highlight_rows(rows = is.na(mass),
                    fill = "steelblue") %>%
  gt_highlight_rows(rows = is.na(hair_color),
                    fill = "lightpink") %>%
  gt_highlight_rows(rows = is.na(height),
                  fill = "yellow")
  

###|- from the output, if we deleted missing values, we would be deleting imp. records like c3PO and R2D2 from any observation
###|- What we want is to surgically remove observations where there's a missing value in the variable we are interested in
###|- a look at the output table shows that there is a missing value for "Wilhuff Tarkin" under the mass variables, so we will delete just that row

#Now lets drop the missing value:

starwars %>%
  select(name, mass, height, hair_color) %>%
  drop_na(mass) %>%
  head(20) %>%
  gt() %>%
  gt_theme_guardian() %>%
  tab_header(title = "Starwars characters")           #You can see records for "Wilhuff Tarkin" are gone


## 2) Change missing values

starwars %>%
  select(name, hair_color, species) %>%
  head(5) %>%
  gt() %>%
  gt_theme_guardian() %>%
  tab_header(title = "Starwars character hair color and species") %>%
  gt_highlight_rows(rows = is.na(hair_color),
                    fill = "lightpink")

###|-Looking at output, droids don't have hair just like vader, therefore, we might want to change their NA to none

# Now lets change missing values
?mutate
?case_when
starwars %>%
  select(name, hair_color, species) %>%
  filter(species == "Droid") %>%
  mutate(hair_color = case_when(
    is.na(hair_color) &
      species == "Droid" ~ "none",
    TRUE ~ hair_color)) %>%
  gt() %>%
  gt_theme_guardian() %>%
  tab_header(title = "Starwars characters")       #"is.na(hair_color) & species == "Droid" ~ "none"" => Basically if haircolor is NA AND species = droid, then (~) change to "none",.....
                                                  #...... ,TRUE ~ hair_color) => otherwise (else), leave haircolor as is


## 3)  Impute


#First lets view missing height data as a table:
starwars %>%
  select(name, height) %>%
  filter(is.na(height)) %>%
  gt() %>%
  gt_theme_espn() %>%
  tab_header(title = "Starwars characters")

# Now lets impute:

starwars %>%
  mutate(height = case_when(
    is.na(height) ~ median(starwars$height,
                           na.rm = TRUE),                  #when we calc the median, we need to exclude missing values (NA)
    TRUE ~ height)) %>%
  select(name,height) %>%
  arrange(name) %>%
  gt() %>%
  gt_theme_dark() %>%
  tab_header(title = "starwars charcters") %>%
  gt_highlight_rows(rows = name %in% c("Arvel Crynyd", "Finn", "Rey",
                                       "Poe Dameron", "BB8",
                                        "Captain Phasma"),
                    fill = "steelblue")
