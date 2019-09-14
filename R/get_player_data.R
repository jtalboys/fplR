#' Function to extract data for a specific player from a certain gameweek.
#' 
#' @param players a vector of players, referred to either using their ID's (numerical
#' vector) or names (character vector).
#' as they are written in the id_lookup data frame. I would reccomend using the players
#' ID's due to potential issues with special characters.
#' @param gw The FPL Gameweek to pull data for, a vector of integers between 1 and 38.
#' Note that if gameweeks chosen haven't been played yet then data won't be displayed for them.
#' Defaults to all gameweeks.
#' 
#' @return A data frame, with one row of data for each player for each gameweek
#' 
#' @export
#' 
#' @importFrom dplyr filter pull left_join select everything
#' @importFrom magrittr %>%
#' @importFrom jsonlite fromJSON
#' @importFrom purrr map_dfr
#' 
#' @examples 
#' get_player_data('Simon Mignolet')
#' 
#' get_player_data(190, 1:2)
#' 
#' get_player_data(1:10, 3)
#' 
#' get_player_data(c('Simon Mignolet', 'Laurent Koscielny'))
get_player_data <- function(players, gw = 1:38) {
  # start with the base url
  url <- 'https://fantasy.premierleague.com/api/element-summary/'
  
  # If the players are specified using the ID's, then we don't need to do anything
  # But if they are specified by their names then we need to obtain their ID's
  # using the id_lookup table.
  
  if (is.character(players)) {
    # First load in the id_lookup dataset
    data(id_lookup)
    
    # Use filter and pull to get the player ID's
    players <- dplyr::filter(id_lookup, name %in% players) %>%
      dplyr::pull(id)
  }
  
  # Now we can generate the queries we need to run
  queries <- paste0(url, players, '/')
  
  # Iterate over these queries, applying fromJSON from the jsonlite package
  df <- purrr::map_dfr(queries, ~{data <- jsonlite::fromJSON(.x)
                        # For now we're only interested in the history dataset
                        data$history %>%
                          dplyr::filter(round %in% gw)}
             )
  
  # Lovely!
  # Now to just tidy it up for the end user
  
  # (We'll require the teams dataset so load that here)
  data(teams)
  
  # We'll start by including the players actual name
  df <- df %>%
    dplyr::left_join(id_lookup %>% dplyr::select(id, name),
                     by = c('element' = 'id')) %>%
    # Now get rid of the element column as well as a few others
    dplyr::select(-element, -fixture, -kickoff_time) %>%
    # Next we want to use the teams dataset to convert the opponents id
    # into an actual name
    dplyr::left_join(teams %>% dplyr::select(id, opponent = name),
                     by = c('opponent_team' = 'id')) %>% 
    dplyr::select(name, opponent, dplyr::everything(), -opponent_team)
  
  df
}