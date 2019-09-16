#' Function which gives access to higher level data about each player, aggregated at a
#' season level.
#' 
#' @param players Either a character vector of player names or a numeric vector of player
#' ID's which can be obtained from the `id_lookup` table
#' 
#' @return A data frame with one row for each player chosen and 27 variables as follows:
#' \describe{
#'    \item{player_name, team_name}{Information about the player}
#'    \item{start_cost}{Cost (in £m) at the start of the season (or when introduced to the game)}
#'    \item{now_cost}{Cost at the time of calling the function (in £m)}
#'    \item{dreamteam_count}{How many times this player has appeared in the dreamteam (team of the gameweek)}
#'    \item{form}{As calculated by pls based on games in the last 30 days}
#'    \item{points_per_game}{Average points per Gameweek participated in}
#'    \item{selected_by_percent}{Percent of managers who's team this player is selected in (at the time of running the function)}
#'    \item{status}{One of: Available, Injured - won't play, Injured - may play, Suspended or Unavailable}
#'    \item{total_points}{Total fpl points acrued by this player over the season to date}
#'    \item{goals_scored, assists, clean_sheets, goals_conceded, own_goals, penalties_saved,
#'    penalties_missed, yellow_cards, red_cards, saves}{Statistics relating to the players performance over the whole season}
#'    \item{bonus}{Total fpl bonus points earned over the whole season}
#'    \item{bps}{Points awarded to this player by the fpl bonus point system over the season}
#'    \item{influence, creativity, threat, ict_index}{Current values from fpl algorithms}}
#' 
#' @export
#' 
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr filter pull select mutate left_join case_when everything
#' 
#' @examples 
#' get_season_data(301)
#' 
#' get_season_data('John Fleck')
#' 
#' get_season_data(350:352)
get_season_data <- function(players){
  
  # Firstly check that players/ player id's that have been given are valid
  # Can do this by checking against the id_lookup table
  if(is.character(players)) {
    if(any(!(players %in% id_lookup$name))) {
      
      # obtain the naughty names positions
      incorrect <- which(!(players %in% id_lookup$name))
      
      # Print out a warning message
      message(paste0('The following player names provided are not valid: ',
                     paste0(players[incorrect], collapse = ', ')))
      
      # Now remove the offending names
      players <- players[-incorrect]
    }
  } else if (is.numeric(players)) {
    if(any(!(players %in% id_lookup$id))) {
      
      # obtain the naughty id's positions
      incorrect <- which(!(players %in% id_lookup$id))
      
      message(paste0('The following player ids provided are not valid: ',
                     paste0(players[incorrect], collapse = ', ')))
      
      # Now remove the offending id's
      players <- players[-incorrect]
    }
  }
  
  # Just check that there are some valid player names/ id's left
  if(length(players) == 0) stop("No valid player names or id's were provided")
  
  # Set the url
  url <- 'https://fantasy.premierleague.com/api/bootstrap-static/'
  
  # Using fromJSON - obtain the data from that url
  data <- jsonlite::fromJSON(url)
  
  # The elements dataset is the one we're interested in
  data <- data$elements
  
  # If a character vector is supplied - convert this to player ID's
  if (is.character(players)) {
    
    # Use filter and pull to get the player ID's
    players <- dplyr::filter(id_lookup, name %in% players) %>%
      dplyr::pull(id)
  }
  
  # Now filter the dataset by these player id's
  player_data <- data %>%
    dplyr::filter(id %in% players)
  
  # Now we've just got the desired data for chosen players
  # All that's left is to refine this dataset to give the user all the stats they
  # could possibly need!
  
  final_data <- player_data %>%
    # Ready for a horrible call to select...
    dplyr::select(cost_change_start, dreamteam_count, form, id, now_cost, points_per_game,
                  selected_by_percent, status, team, total_points, minutes, goals_scored,
                  assists, clean_sheets, goals_conceded, own_goals, penalties_saved,
                  penalties_missed, yellow_cards, red_cards, saves, bonus, bps, influence,
                  creativity, threat, ict_index) %>%
    # I'd quite like to calculate the starting price using the current cost and price change
    dplyr::mutate(start_cost = now_cost - cost_change_start) %>%
    # Convert the player and team id to the actual names
    dplyr::left_join(id_lookup %>% dplyr::select(id, name)) %>%
    dplyr::left_join(teams %>% dplyr::select(id, 'team_name' = name),
                     by = c('team' = 'id')) %>%
    dplyr::select(player_name = name, team_name, start_cost, now_cost, dplyr::everything(),
                  dreamteam_count, -id, -cost_change_start, -team) %>%
    # Lastly we'll convert the values of status to something a bit easier to understand
    # using case_when
    dplyr::mutate(status = dplyr::case_when(
      status == 'a' ~ "Available",
      status == 'i' ~ "Injured - won't play",
      status %in% c('u', 'n') ~ "Unavailable",
      status == 'd' ~ "Injured - may play",
      status == 's' ~ "Suspended",
      TRUE ~ as.character(status)
    ))
  
  # And that's it!
  final_data
}