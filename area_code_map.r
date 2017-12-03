# load up libraries:
library(imager)
library(sp)
library(rgdal)
library(RColorBrewer)
library(ggplot2)
library(broom)
library(ggmap)
library(rgeos)

source("area_code_data.r")
rm(area_code_row)

#states<-names(table(state_codes)) #only need if we delineate states

#make table of area code mention frequencies
ac_tbl<-table(area_codes)

#hard-coded solution that should be improved later:
#get rid of low-count area codes that overlap high-count area code
ac_tbl<-ac_tbl[!(names(ac_tbl) %in% c("267","862"))]

#read in the shapefile delineating area code latitude and longitude
if (file.exists("AreaCode.shp")) {
        area <- readOGR("AreaCode.shp")
} else if (file.exists("AreaCode.zip")) {
        unzip("AreaCode.zip")
        area <- readOGR("AreaCode.shp")
        
        file.remove("AreaCode.dbf","AreaCode.prj","AreaCode.sbn",
                    "AreaCode.sbx","AreaCode.shx","AreaCode.shp","AreaCode.shp.xml")
} else {
        download.file("https://github.com/areeves87/glassine-area-codes/blob/master/AreaCode.zip","AreaCode.zip",mode="wb")
        unzip("AreaCode.zip")
        area <- readOGR("AreaCode.shp")
        
        file.remove("AreaCode.dbf","AreaCode.prj","AreaCode.sbn",
                    "AreaCode.sbx","AreaCode.shx","AreaCode.shp","AreaCode.shp.xml")
}

#select only area code shapes that are mentioned in /r/glassine data
glassine_area<-area[which(area$NPA %in% names(ac_tbl)),]

#add a column of data indicating number of mentions per area code
ac_ref<-match(glassine_area@data$NPA,names(ac_tbl))
glassine_area@data$TALLY <- as.vector(ac_tbl[ac_ref])

#Find area code centroids and add them as two columns of data
glassine_area$CENTER.x<-tidy(gCentroid(glassine_area, byid=TRUE))[,1]
glassine_area$CENTER.y<-tidy(gCentroid(glassine_area, byid=TRUE))[,2]

#Make proper transform -- not sure if this is necessary
glassine_WGS84 <- spTransform(glassine_area, CRS("+init=epsg:4326"))
glassine_df_WGS84 <- tidy(glassine_WGS84)
glassine_WGS84$polyID <- sapply(slot(glassine_WGS84, "polygons"), function(x) slot(x, "ID"))
glassine_df_WGS84 <- merge(glassine_df_WGS84, glassine_WGS84, by.x = "id", by.y="polyID")

#Create a choropleth map of mainland USA
if (file.exists("usa_glassine.png")) {
        img <- imager::load.image('usa_glassine.png')
        grid::grid.raster(img)
} else {
        usa_basemap <- get_map(location="United States", zoom=4, maptype = 'satellite')
        
        ggmap(usa_basemap) +
                geom_polygon(data = glassine_df_WGS84, 
                             aes(x=long, y=lat, group = group, # coordinates, and group them by polygons
                                 fill = TALLY), alpha = 0.5) + # variable to use for filling
                scale_fill_gradient(low="#bfefff",high="red")+
                ggtitle("Area Code Mentions in /r/glassine")
}

#Create a choropleth map of Pennsylvania-New Jersey region
if (file.exists("pa_glassine.png")) {
        img <- imager::load.image('pa_glassine.png')
        grid::grid.raster(img)
} else {
        pa_basemap <- get_map(location="PA", zoom=6, maptype = 'satellite')
        
        ggmap(pa_basemap) +
                geom_polygon(data = glassine_df_WGS84, 
                             aes(x=long, y=lat, group = group, # coordinates, and group them by polygons
                                 fill = TALLY), alpha = .8) + # variable to use for filling
                scale_fill_gradient(low="#bfefff",high="red")+
                geom_text(data = glassine_df_WGS84,aes(x=CENTER.x,y=CENTER.y,
                                                       label=ifelse(TALLY>20,as.character(NPA),'')))+
                ggtitle("Area Code Mentions in /r/glassine")
}
