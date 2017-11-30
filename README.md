# glassine-area-codes #
Counted area code mentions in the subreddit /r/glassine, which contains threads reviewing heroin "branded" bags

Link to subreddit: https://www.reddit.com/r/glassine/

## Description of what /u/VroooMoose is looking for: ##

*Hello! I'm an EMT in one of the United States' hotbeds for heroin and opiate use, addiction, and overdoses.
I rarely go a couple of years without being affected within ~3 degrees of separation, I rarely go a shift of EMS without having an overdose, and I can't go through watching anything on TV without seeing at least 3 commercials addressing addiction. It is a massive problem.*

*I originally went to r/opiates so that I could get some insight from users from their perspectives since many of my coworkers have a blanket-attitude that they are all pieces of shit, but I believe that is painfully short-sighted.
From there, I discovered r/glassine, which is a board of Reviews, Discussions, or HAT (Has anyone tried?) threads on specific bags or "brands" of heroin. Glassine refers to the bags that heroin used to primarily come in, whereas plain plastic baggies has been more common in my experience in EMS. Glance through this [Vice](https://www.vice.com/en_us/article/nneyew/heroin-bag-art-dequincey-jynxie-interview) article for a quick visual idea.*

*I'm interested in creating a heatmap by Area Code (the most common way r/glassine identifies locations) to see how the locations vary for threads. While opiate use and addiction has become widely accepted as an epidemic around the country, I think it would be interesting to see where some geographic concentrations are.*

*Let me know if you have any questions!*

## Description of files ##

**AreaCode.zip**: zipped folder containing the .shp file that delineates area code boundaries.

**area_code_data.r**: script for obtaining the above datasets

**area_code_map.r**: script for generating the maps in the .png files.

**area_codes_by_state.csv**: a reference detailing which area code belongs to which state

**counts.csv**: a tally of area code mentions for each of the /r/glassine thread titles in glassine_urls.csv

**glassine_urls.csv**: a collection of thread urls & titles from /r/glassine obtained with the redditextractor R package

**pa_glassine.png**: a cholopleth map of the Pennsylvania-New Jersey region shaded according to number of /r/glassine mentions. 

**usa_glassine.png**: a cholopleth map of mainland USA shaded according to number of /r/glassine mentions.





## Preliminary Analysis: ##

Out of 998 threads, here are the tallies:

Area Code | Count | State
---------|-----|-----
412 | 263 | PA
973 | 205 | NJ
215 | 52 | PA
609 | 38 | NJ
724 | 13 | PA
other | 34 | ""
NA | 393 | ""

"NA" is counted each time a thread does not contain a three-digit area code, which happened ~40% of the time.

See the .png files for cholopleth maps of area code mentions in mainland US and Pennsylvania-New Jersey region.
