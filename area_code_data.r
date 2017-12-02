#Load relevant libraries
library(RedditExtractoR)
library(stringr)

# #uncomment to scrape /r/glassine
# glassine_urls<-reddit_urls(subreddit = "glassine",page_threshold = 40)

#use URL to get xls file -- file.download() didn't work for me
#"https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwi2lb79huDXAhWq0FQKHeQ0A9EQFggoMAA&url=http%3A%2F%2Fmedia.juiceanalytics.com%2Fdownloads%2Farea_codes_by_state.xls&usg=AOvVaw3xPwQBSxfXDIqjnq6etEWn"

#load area code table and /r/glassine dataset
area_codes_by_state <- read.csv("area_codes_by_state.csv")
glassine_urls <- read.csv("glassine_urls.csv")

#grab three-digit strings from thread titles; these are candidate area codes
area_codes<-str_extract(glassine_urls$title, "[0-9]{3}")

#lookup the state associated with each candidate area code
area_code_row<-match(area_codes, area_codes_by_state$Area.code)
state_codes<-area_codes_by_state[area_code_row,3]

# #uncomment to create an "area code | state code" mentions table
# df.counts<-cbind(area_codes,state_codes)
# write.csv(df.counts,"counts.csv",row.names = FALSE)




