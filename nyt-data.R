
```{r, message=FALSE, results='hide'}
library(tidyverse)
library(httr)
library(jsonlite)
```

## Iowa Election Data
Load JSON data from NYTimes election data API:

```{r}
iowa_url <- "https://int.nyt.com/applications/elections/2020/data/api/2020-02-03/iowa/president/democrat.json"
iowa_votes_json <- fromJSON(iowa_url)

## Converting JSON into usable dataframe:
iowa_counties <- iowa_votes_json$data$races$counties[[1]]
iowa_counties_all <- bind_cols(select(iowa_counties, name), iowa_counties$results)
head(iowa_counties_all)
```

Pivot the data from wide to long. Consider why the arguments candidate and votes are in quotes, but name is not.

```{r}
iowa_counties_long <- iowa_counties_all %>% 
  pivot_longer(cols = c(-name), names_to = "candidate", values_to = "votes")
head(iowa_counties_long, n=20)
```

This longer version of the data lets us run statistics in the way we are used to, with group_by and summarize:

```{r}
iowa_counties_agg <- iowa_counties_long %>%
  group_by(candidate) %>%
  summarize(total_sdes = sum(votes)) %>%
  arrange(desc(total_sdes))

head(iowa_counties_agg, n=15)
```

Now back to the original format, using pivot_wider:

```{r}
iowa_counties_wide <- iowa_counties_long %>% 
  pivot_wider(id_cols = name, names_from = candidate, values_from = votes)
head(iowa_counties_wide)
```


## New Hampshire Election Data
Lets do it again for New Hampshire:

```{r}
nh_url <- "https://int.nyt.com/applications/elections/2020/data/api/2020-02-11/new-hampshire/president/democrat.json"
nh_votes_json <- fromJSON(nh_url)

## Converting JSON into usable dataframe:
nh_counties <- nh_votes_json$data$races$counties[[1]]
nh_counties_all <- bind_cols(select(nh_counties, name, fips), nh_counties$results)
head(nh_counties_all)
```

Test your knowledge: Write the code to pivot the New Hampshire data to a longer form, then back. Note the inclusion of the FIPS code, which is unique to each county, changes the code"

```{r}


```

If you wrote the above code correctly, you should be able to run the code below and [match the results from AP](https://www.google.com/search?q=fianl+results+new+hampshire&rlz=1C5CHFA_enUS865US865&oq=fianl+results+new+hampshire&aqs=chrome..69i57j33l7.3442j0j7&sourceid=chrome&ie=UTF-8).

```{r, eval=FALSE}
nh_counties_agg <- nh_counties_long %>%
  group_by(candidate) %>%
  summarize(total_votes = sum(votes)) %>%
  arrange(desc(total_votes))

glimpse(nh_counties_agg)
```


## Simple Introduction to Writing Functions

We use this basic syntax for writing functions (this is pseudocode):

```{bash, eval=FALSE}
function(argument1, argument2...){
  create new_thing from argument1 and argument2
  return(new_thing)
}
```

Here is a rel example using R code:

```{r}
square_plus2 <- function(x){
  y <- x^2 + 2
  return(y)
}

square_plus2
square_plus2(5)
square_plus2(x=7)
```



```{r}
primary_results <- function(date, state){
 .url <- paste0("https://int.nyt.com/applications/elections/2020/data/api/", date, "/", state, "/president/democrat.json")
  print(.url)
 .json <- fromJSON(.url)
 .counties <- .json$data$races$counties[[1]]
 .counties_all <- bind_cols(select(.counties, name, fips), .counties$results)

 .counties_long <- .counties_all %>% 
   pivot_longer(cols = c(-name, -fips), names_to = "candidate", values_to = "votes")
 
 .counties_agg <- .counties_long %>%
   group_by(candidate) %>%
   summarize(total_votes = sum(votes)) %>%
   arrange(desc(total_votes))
 
 return(.counties_agg)
}
```

Test the function with Iowa and New Hampshire!

```{r}
# test here!

```