library(shiny)
library(dplyr)
library(ggplot2)
library(vroom)
library(lubridate)

load(file="data/biodiversity_data.rda")
biodiversity_data$eventDate<-as_date(biodiversity_data$eventDate)
regions <- prepare_regional_data(biodiversity_data)

iu<-fluidPage(
  titlePanel("Biodiversity data"),
  sidebarLayout(
    sidebarPanel(
      speciesInput("species_name"),
      pointSizeInput("map_points"),
    ),
    mainPanel(
      fluidRow(plotOutput("distribution", width = "1000px", height = "800px")),
      fluidRow(plotOutput("time"))
    )
  )
)

server<-function(input,output,session){
  plot_data<-selectionServer("species_name", regions)
  # multiplier of the map point size
  size_factor<-pointSizeServer("map_points")
  output$distribution<-renderPlot({
    if (plot_data()$selected_species==""){
      ggplot(data = plot_data()$shape) +
        geom_sf(col=rgb(0.8,0.8,0.8))+
        geom_text(aes(x=plot_data()$mid_x,y=plot_data()$mid_y),
                  label="No species selected",cex=10)+
        xlab("Longitude")+
        ylab("Latitude")
    }
    else{
      ggplot(data = plot_data()$shape) +
        geom_sf()+
        geom_point(aes(x = longitudeDecimal,y = latitudeDecimal),
                   data = plot_data()$points_data,
                   # sqrt makes point surface proportional to the individual count
                   cex = sqrt(plot_data()$points_data$individualCount)*2*size_factor(),
                   col = rgb(0,0.502,0,0.4))+
        xlab("Longitude")+
        ylab("Latitude")+
        ggtitle(plot_data()$plot_title)+
        theme(plot.title = element_text(hjust = 0.5, size = 26),
              axis.title = element_text(size=18),
              axis.text = element_text(size=16))
    }
  })
  output$time<-renderPlot({
    if (plot_data()$selected_species=="") {
      NULL
    }
    else{
      ggplot(data=plot_data()$time_series,aes(x=Index,y=count))+
        geom_line(lwd=1)+
        scale_x_date(date_labels = "%B %d %Y")+
        xlab("Observation time")+
        ylab("Number of individuals")+
        ggtitle("Time series of observations")+
        theme(plot.title = element_text(hjust = 0.5, size = 26),
              axis.title = element_text(size=18),
              axis.text = element_text(size=16))
    }
  })
}
shinyApp(iu, server)


