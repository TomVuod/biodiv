library(xts)
library(sf)
load(file="data/Poland_shape.rda")
load(file="data/World_shape.rda")

prepare_regional_data<-function(biodiversity_data){
  species_names <- list()
  species_names$scientificName <- biodiversity_data %>% pull(scientificName) %>%
    setdiff("") %>% sort() %>% as.list()
  species_names$vernacularName <- biodiversity_data %>% pull(vernacularName) %>%
    setdiff("") %>% sort() %>% as.list()
  World<-list(biodiversity_data = biodiversity_data, shape = World_shape,
              species_names = species_names)
  biodiversity_data <- filter(biodiversity_data, country=="Poland")
  species_names$scientificName <- biodiversity_data %>% pull(scientificName) %>%
    setdiff("") %>% sort() %>% as.list()
  species_names$vernacularName <- biodiversity_data %>% pull(vernacularName) %>%
    setdiff("") %>% sort() %>% as.list()
  Poland<-list(biodiversity_data = biodiversity_data, shape = Poland_shape,
              species_names = species_names)
  list(Poland = Poland, World = World)
}

prepare_plot_data<-function(region, species_name, region_name){
  if (species_name == ""){
    if (region_name == "Poland") return(list(mid_x = 19, mid_y = 52.3,
                                        selected_species="",
                                        shape=region$shape))
    return(list(mid_x=0, mid_y = 0, selected_species="", shape=region$shape))
  }
  filtered_dataset <- region$biodiversity_data %>% filter(scientificName==species_name|
           vernacularName==species_name)
  points_data <- filtered_dataset %>% select(individualCount, longitudeDecimal, latitudeDecimal) %>%
    group_by(longitudeDecimal, latitudeDecimal) %>%
    summarise(individualCount = sum(individualCount))
  plot_title <- compose_plot_title(species_name, dataset = filtered_dataset)
  time_series_data <- prepare_ts_data(filtered_dataset, species_name)
  list(points_data = points_data, plot_title = plot_title,
       time_series = time_series_data, selected_species = species_name,
       shape=region$shape)
}

prepare_ts_data<-function(dataset, species_name){
  # filter the time series data on selected species
  # sum up the observations by days
  if (!is.data.frame(dataset)) stop("A data frame object should be passed in.")
  if (!all(c("scientificName", "vernacularName", "individualCount","eventDate")
           %in% colnames(dataset)))
    stop("Not all required columns are present in the data frame.")
  filtered_data<-filter(dataset,scientificName==species_name|
           vernacularName==species_name) %>% select(individualCount, eventDate)
  if(nrow(filtered_data)==0) stop("Empty tibble after filtering")
  time_span<-seq(min(filtered_data$eventDate)-5,
                 max(filtered_data$eventDate)+5, by="day")
  filtered_data<-rbind(filtered_data, data.frame(eventDate = time_span,
                                                 individualCount = 0))
  ts_data <- xts(filtered_data$individualCount, order.by = filtered_data$eventDate) %>%
    apply.daily(sum)
  colnames(ts_data)<-"count"
  ts_data
}

get_name_pairs<-function(selected_name, dataset){
  # return all scientific names which match a given
  # scientific name and vice versa
  if (!is.data.frame(dataset)) stop("A data frame object should be passed in.")
  if (!all(c("scientificName", "vernacularName")
           %in% colnames(dataset)))
    stop("Not all required columns are present in the data frame.")
  filter(dataset,scientificName==selected_name|
                 vernacularName==selected_name) %>%
    select(vernacularName, scientificName) %>%
    distinct()
}

compose_plot_title<-function(selected_name, ...){
  name_pairs<-get_name_pairs(selected_name, ...)
  plot_title<-"Geographical distribution of\n"
  for(i in 1:nrow(name_pairs)){
    plot_title<-paste0(plot_title, name_pairs[i,]$vernacularName, " (",
           name_pairs[i,]$scientificName,")\n")
  }
  plot_title
}
