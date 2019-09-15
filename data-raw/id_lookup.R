# Set the url
url <- 'https://fantasy.premierleague.com/api/bootstrap-static/'

# Call out to fromJSON with the url
library(jsonlite)
result <- fromJSON(url)

library(dplyr)

id_lookup <- result$elements %>%
  select(id, first_name, second_name, element_type, team) %>%
  mutate(name = stringr::str_c(first_name, second_name, sep = " ")) %>%
  select(-first_name, -second_name) %>%
  # join the position data frame
  left_join(result$element_types %>% select(id, position = singular_name),
            by = c('element_type' = 'id')) %>%
  # join the teams data frame
  left_join(result$teams %>% select(id, team_name = name),
            by = c('team' = 'id')) %>%
  # tidy up the columns
  select(-team, -element_type)

usethis::use_data("id_lookup")
