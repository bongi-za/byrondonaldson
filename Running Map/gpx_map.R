library(tidyverse)
library(here)
library(readxl)
library(leaflet)
library(leaflet.extras)
library(htmlwidgets)


# read in gps tracks data

all_routes <- read_csv(here("all_gpx_routes.csv")) %>%
  mutate(ID = as.factor(ID))


## -----------------------------------------------------------------------


# create satellite map

map <-  leaflet() %>% 
  addTiles() %>% 
  # add base layer satellite map
  addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
  # add Dark map layer to toggle to
  addProviderTiles(providers$CartoDB.DarkMatter, group = "Dark") %>%
  # add stylised road map layer to toggle to
  addProviderTiles("Esri.WorldTopoMap", group = "Basic") %>%
  # Add a User-Interface (UI) control to switch layers
  addLayersControl(
    baseGroups = c("Satellite","Dark", "Basic"
                   ),
    options = layersControlOptions(collapsed = FALSE)
  )

# add running gps tracks
for( ID in levels(all_routes$ID)){
  map <- addPolylines(map, 
                      lng = ~longitude, 
                      lat = ~latitude, 
                      data = all_routes[all_routes$ID == ID,], 
                      color = ~"red",
                      weight = 2.5,
                      opacity = 0.6
  )
}

# save map to html file

htmlwidgets::saveWidget(map, file = "running_map.html")

