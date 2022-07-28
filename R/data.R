# Firstly define the global variables to appease the R CMD Check
utils::globalVariables(c('element', 'fixture', 'id', 'id_lookup', 'kickoff_time',
                         'name', 'opponent', 'opponent_team', 'teams', 'assists',
                         'bonus', 'bps', 'clean_sheets', 'cost_change_start',
                         'creativity', 'dreamteam_count', 'form', 'goals_conceded',
                         'goals_scored', 'ict_index', 'influence', 'minutes',
                         'now_cost', 'own_goals', 'penalties_missed', 'penalties_saved',
                         'points_per_game', 'red_cards', 'saves', 'selected_by_percent',
                         'start_cost', 'status', 'team', 'team_name', 'threat', 
                         'total_points', 'value', 'yellow_cards'))

#' Corresponding id, team and position for every player in fpl 2019/20
#'
#' A dataset containing the basic information of over 500 players.
#'
#' @format A data frame with 532 rows and 4 variables:
#' \describe{
#'   \item{id}{unique id for each player, used to extract player specific data}
#'   \item{name}{the name of the player}
#'   \item{position}{position player is classified as on fpl}
#'   \item{team_name}{name of the team the player plays for}
#' }
#' @source \url{https://fantasy.premierleague.com/api/bootstrap-static/}
"id_lookup"

#' Data for each PL team
#' 
#' Mainly used to convert ID's to actual team names, but the strength assigned
#' by the FPL has been left in just in case it is of any interest.
#' 
#' @format A data frame with 20 rows and 10 variables:
#' \describe{
#'    \item{id}{id for each team}
#'    \item{name}{full name}
#'    \item{short_name}{abbreviated name}
#'    \item{strength}{Overall strenght value assigned by FPL algorithm}
#'    \item{strength_attack_away}{Teams attacking strength when playing away}
#'    \item{strength_attack_home}{Teams attacking strength when playing at home}
#'    \item{strength_defence_away}{Teams defensive strength when playing away}
#'    \item{strength_defence_home}{Teams defensive strength when playing at home}
#'    \item{strength_overall_away}{Teams overall strength when playing away}
#'    \item{strength_overall_home}{Teams overall strength when playing at home}
#'}
#'@source \url{https://fantasy.premierleague.com/api/bootstrap-static/}
"teams"

#' Data from the previous season
#' 
#' Obtained by running \code{get_season_data()} for all players on 28/07/22. As 
#' this is before the start of the new season it stll contains data from last season
#' 
#' @format A data frame with 533 rows and 17 variables
#' \describe{
#'    \item{id}{player id - can be used to pull data in other functions}
#'    \item{player_name}{Player name}
#'    \item{points_per_game}{Points per game from 21/22}
#'    \item{total_points}{Total points from 21/22}
#'    \item{minutes}{Total minutes played 21/22}
#'    \item{goals_scored}{Goals scored 21/22}
#'    \item{assists}{Assists 21/22}
#'    \item{clean_sheets}{Clean Sheets 21/22}
#'    \item{goals_conceded}{Goals Conceded 21/22}
#'    \item{own_goals}{Own goals 21/22}
#'    \item{penalties_saved}{Penalties saved 21/22}
#'    \item{penalties_missed}{Penalties missed 21/22}
#'    \item{yellow_cards}{Yellow cards 21/22}
#'    \item{red_cards}{Red cards 21/22}
#'    \item{saves}{Saves 21/22}
#'    \item{bonus}{Bonus points 21/22}
#'    \item{bps}{Bonus points system total 21/22}
#'    }
#' 
#' 
#' @source \url{https://fantasy.premierleague.com/api/bootstrap-static/}
#' 
"last_season_21_22"