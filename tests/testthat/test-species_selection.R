library(shiny)
test_data_1 <- list(scientificName=c("Formica sanguinea", "Polyergus rufescens",
                                         "Lasius niger", "Formica picea"),
                        vernacularName=c("Red-blood ant", "Amazon ant",
                                         "Black garden ant"))
test_data_2 <- list(scientificName=c("Formica sanguinea", "Polyergus rufescens",
                                   "Lasius niger", "Formica picea",
                                   "Atta columbica"),
                  vernacularName=c("Red-blood ant", "Amazon ant",
                                   "Black garden ant", "Leaf-cutting ant"))
regions<-list()
regions$Poland<-list()
regions$Poland$species_names <- test_data_1

regions$World$species_names <- test_data_2

test_that("server creates right species list", {
  testServer(selectionServer,args=list(regions = regions),{
    session$setInputs(scientific=TRUE, vernacular=TRUE, geo="Poland")
    expect_setequal(unlist(choices_list()), c("Formica sanguinea", "Polyergus rufescens",
                                            "Lasius niger", "Formica picea",
                                            "Red-blood ant", "Amazon ant",
                                            "Black garden ant"))

    session$setInputs(scientific=TRUE, vernacular=FALSE, geo="Poland")
    expect_setequal(unlist(choices_list()), c("Formica sanguinea", "Polyergus rufescens",
                                                      "Lasius niger", "Formica picea"))

    session$setInputs(scientific=FALSE, vernacular=TRUE, geo="Poland")
    expect_setequal(unlist(choices_list()), c("Red-blood ant", "Amazon ant",
                                                      "Black garden ant"))

    session$setInputs(scientific=TRUE, vernacular=TRUE, geo="World")
    expect_setequal(unlist(choices_list()), c("Formica sanguinea", "Polyergus rufescens",
                                                      "Lasius niger", "Formica picea",
                                                      "Red-blood ant", "Amazon ant",
                                                      "Black garden ant",
                                                      "Leaf-cutting ant",
                                                      "Atta columbica"))
  })
})



