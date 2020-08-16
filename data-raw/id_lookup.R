# Set the url
url <- 'https://fantasy.premierleague.com/api/bootstrap-static/'

# Call out to fromJSON with the url
result <- jsonlite::fromJSON(url)

id_lookup <- result$elements %>%
  dplyr::select(id, first_name, second_name, element_type, team) %>%
  dplyr::mutate(name = stringr::str_c(first_name, second_name, sep = " ")) %>%
  dplyr::select(-first_name, -second_name) %>%
  # join the position data frame
  dplyr::left_join(result$element_types %>% dplyr::select(id, position = singular_name),
            by = c('element_type' = 'id')) %>%
  # join the teams data frame
  dplyr::left_join(result$teams %>% dplyr::select(id, team_name = name),
            by = c('team' = 'id')) %>%
  # tidy up the columns
  dplyr::select(-team, -element_type)

usethis::use_data(id_lookup, overwrite = TRUE)
