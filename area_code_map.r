# load up area shape file:
library(maptools)
library(sp)
library(rgdal)
library(RColorBrewer)
library(ggplot2)
library(broom)
library(classInt)
library(ggmap)
library(rgeos)

source("area_code_data.r")

states<-names(table(state_codes))
ac_tbl<-table(area_codes)

#get rid of low-count area codes that overlap with another area code
#hard-coded solution that should be improved later
ac_tbl<-ac_tbl[!(names(ac_tbl) %in% c("267","862"))]

area <- readOGR(unzip("AreaCode.zip", "AreaCode.shp"))

glassine_acs<-area[which(area$NPA %in% names(ac_tbl)),]

ac_ref<-match(glassine_acs@data$NPA,names(ac_tbl))

glassine_acs@data$TALLY <- as.vector(ac_tbl[ac_ref])

#Identify overlapping area codes by comparing area code centroids

glassine_acs$CENTER.x<-tidy(gCentroid(glassine_acs, byid=TRUE))[,1]
glassine_acs$CENTER.y<-tidy(gCentroid(glassine_acs, byid=TRUE))[,2]

glassine_WGS84 <- spTransform(glassine_acs, CRS("+init=epsg:4326"))
glassine_df_WGS84 <- tidy(glassine_WGS84)
glassine_WGS84$polyID <- sapply(slot(glassine_WGS84, "polygons"), function(x) slot(x, "ID"))
glassine_df_WGS84 <- merge(glassine_df_WGS84, glassine_WGS84, by.x = "id", by.y="polyID")


usa_basemap <- get_map(location="United States", zoom=4, maptype = 'satellite')

ggmap(usa_basemap) +
        geom_polygon(data = glassine_df_WGS84, 
                     aes(x=long, y=lat, group = group, # coordinates, and group them by polygons
                         fill = TALLY), alpha = 0.5) + # variable to use for filling
        scale_fill_gradient(low="#bfefff",high="red")+
        ggtitle("Area Code Mentions in /r/glassine")

pa_basemap <- get_map(location="PA", zoom=6, maptype = 'satellite')

ggmap(pa_basemap) +
        geom_polygon(data = glassine_df_WGS84, 
                    aes(x=long, y=lat, group = group, # coordinates, and group them by polygons
                        fill = TALLY), alpha = .8) + # variable to use for filling
        scale_fill_gradient(low="#bfefff",high="red")+
        geom_text(data = glassine_df_WGS84,aes(x=CENTER.x,y=CENTER.y,
                        label=ifelse(TALLY>20,as.character(NPA),'')))+
        ggtitle("Area Code Mentions in /r/glassine")

hi_glassine_df_WGS84 <- glassine_df_WGS84[glassine_df_WGS84$TALLY>20,]

ggmap(pa_basemap) +
        geom_polygon(data = hi_glassine_df_WGS84, 
                     aes(x=long, y=lat, group = group, # coordinates, and group them by polygons
                         fill = TALLY), alpha = .8) + # variable to use for filling
        scale_fill_gradient(low="#bfefff",high="red")+
        geom_text(data = glassine_df_WGS84,aes(x=CENTER.x,y=CENTER.y,
                        label=ifelse(TALLY>20,as.character(NPA),'')))+
        ggtitle(">20 Area Code Mentions in /r/glassine")
