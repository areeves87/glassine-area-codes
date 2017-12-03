#Load relevant libraries
library(RedditExtractoR)
library(stringr)

if (file.exists("glassine_urls.csv")) {
        glassine_urls <- read.csv("glassine_urls.csv")
} else {
        glassine_urls <- reddit_urls(subreddit = "glassine",page_threshold = 40)
}

if (file.exists("area_codes_by_state.csv")) {
        area_codes_by_state <- read.csv("area_codes_by_state.csv")
} else {
        download.file("https://github.com/areeves87/glassine-area-codes/blob/master/area_codes_by_state.csv","area_codes_by_state.csv",mode="wb")
        area_codes_by_state <- read.csv("area_codes_by_state.csv")
}

#grab three-digit strings from thread titles; these are candidate area codes
area_codes<-str_extract(glassine_urls$title, "[0-9]{3}")

#lookup the state associated with each candidate area code
area_code_row<-match(area_codes, area_codes_by_state$Area.code)
state_codes<-area_codes_by_state[area_code_row,3]

# #uncomment to create an "area code | state code" mentions table
# df.counts<-cbind(area_codes,state_codes)
# write.csv(df.counts,"counts.csv",row.names = FALSE)




