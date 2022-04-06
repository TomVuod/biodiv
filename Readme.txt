The application to show on the map the distribution of selected species and observation timing. Module species_selection.R handles input from species, region and name type selection widgets and processes them to return a reactive object storing data which is later used to render plots. Separate module map_point_size.R handles input from point size selection and returns numeric reactive value which is used to re-render the plot. After the user changes the name type or geographical region the species selection is set to an empty string through the "select" parameter of the updateSelectizeInput function in the species_selection.R module. Data folder contains shapes for drawing world and Poland maps as well as biodiversity data.

Current selectionServer logic assumes that a scientific name cannot be a vernacular of different species. The cases where there is no vernacular name for a scientific name or many scientific names have the same vernacular equivalent are handled.

The application is available at twobrickets.shinyapps.io/biodivmap. 1/10 of the original dataset provided for the task is used (rows chosen randomly). 

App version available on Github loads the full dataset from the .csv file, which is a more efficient solution as compared to loading from the .rda file. The original character encoding used in .csv file has been changed from cp1252 (which caused some minor issues on my Windows platform) to UTF-8. 

The application created with R version 4.1.3 (2022-03-10)
More details on the environment:
Platform: x86_64-w64-mingw32/x64 (64-bit)
OS: Windows 10 x64 (build 19044)
R packages:
shiny_1.7.1
ggplot2_3.3.5           
dplyr_1.0.8             
sf_1.0-7                       
xts_0.12.1    
lubridate_1.8.0       

EXTRAS:
To increase the app performance I used profvis to see which functions are the most resource consuming. Based on the results, I decided to shift some operations outside the server function. They are now executed once on the app startup. Moreover, search matching is performed on the server by setting the server argument of updateSelectizeInput to TRUE. Data is loaded more efficiently by using vroom::vroom function instead of read.csv. The initialization time can be reduced by fetching data directly from .csv file with vroom::vroom function. This method has not been implemented due to the file size limit on the Github. 

Additional feature: slider input enabling dynamic control of the point size on the map with proportions among points preserved. This helps spot the points which are too small to be detected immediately. The additional checkbox "augmentation" when unchecked allows for point size reduction which is useful in the case of large overlapping points. 

