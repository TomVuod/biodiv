library(dplyr)
library(lubridate)

test_data<-list()
test_data$biodiversity_data<-data.frame(scientificName=c(rep("Lycaena dispar",3),
                                       "Lycaena dispar rutila"),
                      vernacularName=rep("Large Copper",4),
                      longitudeDecimal=c(20, 20, 21, 20),
                      latitudeDecimal=c(50, 50, 49, 50),
                      individualCount=c(10,5,2,20),
                      eventDate=as_date(c(18000,18000,18001,18000))
)
test_that("prepare_plot_data() correctly summarizes individual counts", {
  function_output<-prepare_plot_data(test_data,species_name="Lycaena dispar",
                                     region_name="Poland")
  counts<-function_output$points_data$individualCount
  expect_setequal(counts,c(2,15))

  function_output<-prepare_plot_data(test_data,species_name="Large Copper",
                                     region_name="World")
  counts<-function_output$points_data$individualCount
  expect_setequal(counts,c(2,35))

  function_output<-prepare_plot_data(test_data,species_name="Lycaena dispar rutila",
                                     region_name="Poland")
  counts<-function_output$points_data$individualCount
  expect_setequal(counts,c(20))

  function_output<-prepare_plot_data(test_data,species_name="Lycaena dispar",
                                     region_name="Poland")
  count<-as.numeric(function_output$time_series[as_date(18000),])
  expect_equal(count, 15)

  function_output<-prepare_plot_data(test_data,species_name="Large Copper",
                                     region_name="Poland")
  count<-as.numeric(function_output$time_series[as_date(18000),])
  expect_equal(count, 35)

  function_output<-prepare_plot_data(test_data,species_name="Lycaena dispar rutila",
                                     region_name="World")
  count<-as.numeric(function_output$time_series[as_date(18000),])
  expect_equal(count, 20)

  expect_true(!("eventDate" %in% colnames(function_output$points_data)))

  expect_true(("latitudeDecimal" %in% colnames(function_output$points_data)))
})

