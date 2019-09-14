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