library(RedditExtractoR)
library(stringr)
library(maps)

#glassine_urls<-reddit_urls(subreddit = "glassine",page_threshold = 40)
#area_codes_by_state from https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwi2lb79huDXAhWq0FQKHeQ0A9EQFggoMAA&url=http%3A%2F%2Fmedia.juiceanalytics.com%2Fdownloads%2Farea_codes_by_state.xls&usg=AOvVaw3xPwQBSxfXDIqjnq6etEWn

area_codes_by_state <- read.csv("~/R/Projects/glassine analysis/area_codes_by_state.csv")

glassine_urls <- read.csv("~/R/Projects/glassine analysis/glassine_urls.csv")

area_codes<-str_extract(glassine_urls$title, "[0-9]{3}")

area_code_row<-match(area_codes, area_codes_by_state$`Area code`)

state_codes<-area_codes_by_state[area_code_row,3]

df.counts<-cbind(area_codes,state_codes)

write.csv(df.counts,"counts.csv",row.names = FALSE)




