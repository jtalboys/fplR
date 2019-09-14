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
#'    \item{stength_*}{Breakdown of a teams strengths, split in to overall, attacking
#'    and defending for home and away}
#'}
#'@source \url{https://fantasy.premierleague.com/api/bootstrap-static/}
"teams"