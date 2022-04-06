speciesInput<-function(id){
  tagList(
    selectizeInput(NS(id,"species"), "Enter species name", choices = list(""),
                   selected=""),
    checkboxInput(NS(id,"vernacular"),"Vernacular name", value=TRUE),
    checkboxInput(NS(id,"scientific"),"Scientific name", value=TRUE),
    radioButtons(NS(id,"geo"), "Select area", choices = list("Poland", "World"),
                 selected = "Poland")
  )
}

selectionServer<-function(id, regions){
  moduleServer(id, function(input, output, session){
    region <- reactive(regions[input$geo][[1]])
    # create species choice list for updateSelectizeInput
    choices_list <- reactive({
      name_types <- c("vernacularName", "scientificName")[c(input$vernacular,
                                                          input$scientific)]
      choices<-list()
      for(name_type in name_types){
        choices <- c(choices, region()$species_names[name_type][[1]])
      }
      choices
    })
  observeEvent({
    input$scientific
    input$vernacular
    input$geo},
    {
      updateSelectizeInput(session, "species", selected = "",
      choices = choices_list(), server=TRUE)
    }
  )
    plot_data <- eventReactive(input$species,
      prepare_plot_data(region(), input$species, input$geo))
    return(plot_data)
  })
}
