#' Function to extract data for a specific player(s) from a certain gameweek or weeks.
#' 
#' @param players a vector of players, referred to either using their ID's (numerical
#' vector) or names (character vector).
#' as they are written in the id_lookup data frame. I would reccomend using the players
#' ID's due to potential issues with special characters.
#' @param gw The FPL Gameweek to pull data for, a vector of integers between 1 and 38.
#' Note that if gameweeks chosen haven't been played yet then data won't be displayed for them.
#' Defaults to all gameweeks.
#' 
#' @return A data frame, with one row of data for each chosen player for each chosen gameweek.
#' The data has 29 variables:
#' \describe{
#'    \item{name}{Player name}
#'    \item{opponent}{Team played against in this round}
#'    \item{total_points}{Total fpl points earned in this gameweek}
#'    \item{was_home}{Boolean - did the player play at home?}
#'    \item{team_h_score, team_a_score}{Number of goals scored by the home or away team}
#'    \item{round}{The Gameweek}
#'    \item{minutes}{Minutes played by the player in this gameweek}
#'    \item{goals_scored, assists, clean_sheets, goals_conceded, own_goals, penalties_saved,
#'    penalties_missed, yellow_cards, red_cards, saves}{Statistics related to the players performance in this gameweek}
#'    \item{bonus}{fpl bonus points awarded to the player in this gameweek}
#'    \item{bps}{Points allocated to the player by the fpl bonus points system - used to determine how many bonus point player should be awarded}
#'    \item{influence, creativity,threat, ict_index}{Values calculated by fpl algorithms}
#'    \item{value}{The cost of the player in this gameweek  (£m)}
#'    \item{transfers_balance, transfers_in, transfers_out}{Figures relating to how many managers transferred this player in/out for this gameweek}
#'    \item{selected}{Number of fpl managers selected by}}
#' 
#' @export
#' 
#' @importFrom dplyr filter pull left_join select everything mutate
#' @importFrom magrittr %>%
#' @importFrom jsonlite fromJSON
#' @importFrom purrr map_dfr
#' 
#' @examples 
#' get_gw_data('Simon Mignolet')
#' 
#' get_gw_data(190, 1:2)
#' 
#' get_gw_data(1:10, 3)
#' 
#' get_gw_data(c('Simon Mignolet', 'Laurent Koscielny'))
get_gw_data <- function(players, gw = 1:38) {

  # start with the base url
  url <- 'https://fantasy.premierleague.com/api/element-summary/'
  
  # If the players are specified using the ID's, then we don't need to do anything
  # But if they are specified by their names then we need to obtain their ID's
  # using the id_lookup table.
  
  if (is.character(players)) {
    
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
    dplyr::select(name, opponent, dplyr::everything(), -opponent_team) %>%
    # Dived the value by 10 to get the value in millions
    dplyr::mutate(value = value / 10)
  
  df
}