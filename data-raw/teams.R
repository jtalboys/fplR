all_data <- jsonlite::fromJSON('https://fantasy.premierleague.com/api/bootstrap-static/')

# Just pull the teams and select a few columns
teams <- all_data$teams %>%
  dplyr::select(id, name, short_name, dplyr::starts_with('strength'))

usethis::use_data(teams, overwrite = TRUE)
