library(leaflet)
library(shiny)
library(ggplot2)
library(tidyverse)
library(gifski)
library(png)
library(gganimate)
library(gapminder)
library(plotly)

# Import Data Set
USHospitalBeds <- read.csv("USHospitalBeds.csv")

ByState <- group_by(USHospitalBeds, state, type) 
ByStatetotal <- summarize(ByState, 
                          TotalBeds = sum(beds))

ByStatetotal$state <- as.factor(ByStatetotal$state)
SelectStates<-c("CA","NY","FL")
#Select CA, NY, FL

TriStates<-subset(ByStatetotal, subset = state%in%SelectStates)
# Example data frame 
Trimap <- data.frame(Site = c("California: Total 173,787 Beds", 
                              "New York: Total 151,678 Beds", 
                              "Florida: Total 250,486 Beds"), 
                     Latitude = c(36.951968, 43.29943, 27.66483), 
                     Longitude = c(-122.064873, -74.21793, -81.51575))

# Define UI for application that draws a histogram
ui <- navbarPage(title = "Covid-19 US Hospital Beds",
                 tabPanel(title = "Maps",
                          column(7, leafletOutput("Trimap", height = "600px")),
                          br(),
                          br(),
                          plotOutput("output$RoomType2")
                 ),
                 tabPanel(title = "Individual States Information",
                          selectInput("SelectRoomType",
                                      "Select a Room Type:",
                                      c(  "ACUTE" = "ACUTE",
                                          "ICU"= "ICU",
                                          "OTHER"= "OTHER",
                                          "PSYCHIATRIC"= "PSYCHIATRIC"),multiple = TRUE),
                          plotlyOutput(outputId = "RoomType3"),
                          plotlyOutput(outputId = "RoomType4"),
                          plotlyOutput(outputId = "RoomType5")
                 ),
                 tabPanel(title = "CA, NY, FL Information",
                          plotlyOutput(outputId = "RoomType6"),
                          plotlyOutput(outputId = "RoomType7"),
                          plotOutput(outputId = "RoomType8")
                 ),
                 tabPanel(title = "Animations",
                          imageOutput("plot9"),
                          br(),
                          br(),
                          imageOutput("plot10")
                 )
                 
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    ## leaflet map
    output$Trimap <- renderLeaflet({
        leaflet() %>% 
            addTiles() %>% 
            addCircleMarkers(data = Trimap, ~unique(Longitude), ~unique(Latitude), 
                             layerId = ~unique(Site), 
                             popup = ~unique(Site)) 
    })
    
    # generate data in reactive
    ggplot_data <- reactive({
        site <- input$wsmap_marker_click$id
        Trimap[Trimap$Site %in% site,]
    })
    
    #-------------------------------------------------------------------------------------------------------------------
    
    
    output$RoomType2 <- renderPlotly({
      states <- map_data("state")
      CA <- subset(states, region == "california")
      
      counties <- map_data("county")
      CA_county <- subset(counties, region == "california")
      
      # Data Frame of points(2)
      CAlabs <- data.frame(
        long = -122.064873,
        lat = 36.951968,
        names = "CA",
        stringsAsFactors = FALSE)
      
      ggplot(data = CA, mapping = aes(x = long, y = lat)) +
        geom_polygon(color = "black", fill = "hotpink") +
        coord_fixed(1) +
        geom_point(data = CAlabs, aes(x = long, y = lat), color = "red", size = 4) +
        geom_point(data = CAlabs, aes(x = long, y = lat), color = "blue", size = 3) + 
        geom_polygon(color = "black", fill = NA) +
        theme(legend.position = 'none') +
        labs(title = "Hospital Beds in  California States",
             x = "Longitude",
             y = "Latitude")
      guides(fill = FALSE) # do this to leave off the color legend 
    }) 
    #-------------------------------------------------------------------------------------------------------------------
    
    output$RoomType3 <- renderPlotly({
        California <- subset (ByStatetotal,state == "CA")  
        
        option <- subset(California,
                         type %in% input$SelectRoomType)
        ggplot(option, 
               aes(x = type,y = TotalBeds,fill = type)) +
            geom_bar(stat = "identity") +
            theme(legend.position = 'none') +
            labs(title = "Room Type VS. Availability",
                 subtitle = "Acute Unit have the widest range concerning the availability in State of California",
                 x = "Room Type",
                 y = "Total beds in California per 1000 HAB") 
    })
    
    #-------------------------------------------------------------------------------------------------------------------
    
    
    output$RoomType4 <- renderPlotly({
        NewYork <- subset (ByStatetotal,state == "NY")
        
        option <- subset(NewYork,type %in% input$SelectRoomType)
        ggplot(option, 
               aes(x = type,y = TotalBeds, fill = type)) +
            geom_bar(stat = "identity") +
            theme(legend.position = 'none') +
            labs(title = "Room Type VS. Availability",
                 subtitle = "Acute Unit  have the widest range concerning the availability in State of New York",
                 x = "Room Type",
                 y = "Total beds in New York per 1000 HAB") 
        
    })
    
    #-------------------------------------------------------------------------------------------------------------------    
    
    output$RoomType5 <- renderPlotly({
        Florida <- subset (ByStatetotal,state == "FL")
        
        option <- subset(Florida,type %in% input$SelectRoomType)
        ggplot(option, 
               aes(x = type,y = TotalBeds, fill = type)) +
            geom_bar(stat = "identity") +
            theme(legend.position = 'none') +
            labs(title = "Room Type VS. Availability",
                 subtitle = "Acute Unit  have the widest range concerning the availability in State of Florida",
                 x = "Room Type",
                 y = "Total beds in Florida per 1000 HAB") 
    })
    
    
    #-------------------------------------------------------------------------------------------------------------------
    
    output$RoomType6 <- renderPlotly({
        ByStatetotal$state <- as.factor(ByStatetotal$state)
        SelectStates<-c("CA","NY","FL")
        #Select CA, NY, FL
        
        TriStates<-subset(ByStatetotal, subset = state%in%SelectStates)
        
        option <- subset(TriStates)
        ggplot(TriStates, 
               aes(x = type,y = TotalBeds, fill = type)) +
            geom_bar(stat = "identity") +
            facet_wrap(~ state)  +
            theme(legend.position = 'none',axis.text.x = element_text(angle = 45,size=8)) +
            labs(title = "Room Type VS. Availability",
                 subtitle = "Acute Unit  have the widest range concerning the availability in State of CA,NY,FL",
                 x = "Room Type",
                 y = "Total beds in CA,NY,FL per 1000 HAB") 
    })
    
    #-------------------------------------------------------------------------------------------------------------------
    
    output$RoomType7 <- renderPlotly({
        Acute <- subset(USHospitalBeds, type == "ACUTE")
        AcuteTriStates <- subset(Acute, subset = state%in%SelectStates)
        
        option <- subset(AcuteTriStates)
        ggplot(option, 
               aes(x = type,y = beds)) +
            geom_boxplot(mapping = aes(color = state)) +
            theme(legend.position = 'none') +
            labs(title = "Room Type VS. Availability",
                 subtitle = "Acute Unit  have the widest range concerning the availability in State of CA,NY,FL",
                 x = "ACUTE",
                 y = "Total beds in CA,NY,FL per 1000 HAB") 
        
    })   

    
    #-------------------------------------------------------------------------------------------------------------------
    

    output$RoomType8 <- renderPlot({
        StatePercentage <- TriStates %>% count(TotalBeds) 
        
        p8 <- ggplot(StatePercentage, 
                     aes(x = "",y = n, fill = TotalBeds)) +
          geom_bar(stat="identity", width=1) 
        
        pie =  p8+coord_polar("y",start=0)
        pie
        
    })
    
    #-------------------------------------------------------------------------------------------------------------------    
    
    output$plot9 <- renderImage({
        # A temp file to save the output.
        # This file will be removed later by renderImage
        outfile <- tempfile(fileext='.gif')
        
        # now make the animation
        #option <- subset(TriStates, type %in% input$AnimationSelection)
        p9 <- ggplot(TriStates, 
                     aes(x = type,y = TotalBeds,fill = type)) +
            geom_boxplot() +
            theme(legend.position = 'none') +
            labs(title = "Room Type VS. Availability",
                 subtitle = "Acute Unit  have the widest range concerning the availability in State of CA,NY,FL",
                 x = "Room Type",
                 y = "Total Beds in CA,NY,FL per 1000 HAB") +
            #Here comes the gganimate code
            transition_states(type, transition_length = 1, state_length = 2) +
            enter_grow() + enter_drift(x_mod = -1) + 
            exit_shrink() + exit_drift(x_mod = 6)
        ease_aes('sine-in-out')
        p9 # New
        
        anim_save("outfile.gif", animate(p9)) # New
        
        # Return a list containing the filename
        list(src = "outfile.gif",
             contentType = 'image/gif'
             # width = 400,
             # height = 300,
             # alt = "This is alternate text"
        )}, deleteFile = TRUE)
    
    #-------------------------------------------------------------------------------------------------------------------
    output$plot10 <- renderImage({
        # A temp file to save the output.
        # This file will be removed later by renderImage
        outfile <- tempfile(fileext='.gif')
        
        # now make the animation
        p10 <- ggplot(TriStates, 
                      aes(x = type,y = TotalBeds, fill = type)) +
            geom_bar(stat = "identity") +
            facet_wrap(~ state)  +
            theme(legend.position = 'none',axis.text.x = element_text(angle = 45,size=8)) +
            labs(title = "Room Type VS. Availability",
                 subtitle = "Acute Unit  have the widest range concerning the availability in State of CA,NY,FL",
                 x = "Room Type",
                 y = "Total beds in CA,NY,FL per 1000 HAB") +
            #Here comes the gganimate code
            transition_states(type, transition_length = 1, state_length = 2) +
            enter_grow() +
            exit_shrink() +
            ease_aes('sine-in-out')
        p10 # New
        
        anim_save("outfile.gif", animate(p10)) # New
        
        # Return a list containing the filename
        list(src = "outfile.gif",
             contentType = 'image/gif'
             # width = 400,
             # height = 300,
             # alt = "This is alternate text"
        )}, deleteFile = TRUE)
    
}

# Run the application 
shinyApp(ui = ui, server = server)
