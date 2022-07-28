# fplR
An R Package that provides wrappers around the fantasy premier league (fpl) API! Only works for the current (2019/20) season as that's the data that the API URL's allow the public to access. The data available via these URL's updates during games with stats such as goals scored and assists by a player. Not all information from the game is available straight away, for example bonus points aren't confirmed until some hours after the game.

## Installation
For now give installation a go using `devtools::install_github('jtalboys/fplR')`

## Functionality
There are 2 different levels of data to access; by gameweek or by the season as a whole. For gameweek level data use the function `get_gw_data()`. For example running `get_gw_data('Teemu Pukki', 3)` Will fetch information on Teemu Pukki from Gameweek 3 (he probably scored). To access the season long data use `get_season_data()`; so running `get_season_data('Teemu Pukki')` will obtain you all of Teemu Pukki's data up to the moment you ran the function.

You WILL need access to the internet to use these functions, hopefully that's not too much of a trade-off for up to date stats!

Now there are a lot of complicated names of players in the Premier League, with accents and all sorts. To save you having to spell right and being able to access some of the trickier named players at all there is another way! Each player has an 'id' associated with them. Both the `get_*` functions will accept this 'id' as a numeric in place of the player name. Just look it up in the `id_lookup` table that comes with the package.

You can also pass through a vector of names/id's at once (e.g. `get_season_data(150:160)`). Obtaining player data for multiple Gameweeks works in a similar way (`get_gw_data(191, 1:5)`). 

Both functions spit out some rather wide and horrible datasets, full details on the output can be found in the help files for each function. I wanted to retain as much data as possible during scraping.
