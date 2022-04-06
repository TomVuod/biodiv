pointSizeInput<-function(id){
  tagList(
    sliderInput(NS(id,"size_factor"),"Change point size",min = 1,max = 10, value = 2),
    checkboxInput(NS(id, "increase"),"Augmentation",value=TRUE)
  )
}

pointSizeServer<-function(id){
  moduleServer(id, function(input, output, session){
    reactive({
      size_factor<-input$size_factor
      # increase or decrease point size
      if (!input$increase) size_factor<-1/size_factor
      size_factor
    })
  })
}