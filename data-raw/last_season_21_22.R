# # Note this should only be run before the start of the new season
# # In this case it was run on 28/7/22 before the start of the 22/23 season
# 
# all_data <- get_season_data(id_lookup$id) 
# 
# # Add id column
# # Select only last season relative columns 
# last_season_21_22 <- all_data %>%
#   dplyr::mutate(id = id_lookup$id) %>%
#   dplyr::select(id, player_name, points_per_game, total_points, minutes, goals_scored,
#                 assists, clean_sheets, goals_conceded, own_goals, penalties_saved,
#                 penalties_missed, yellow_cards, red_cards, saves, bonus, bps)

usethis::use_data(last_season_21_22, overwrite = TRUE)
