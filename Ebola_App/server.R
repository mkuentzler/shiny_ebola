library(shiny)
library(reshape2)
library(ggplot2)

# Read in the Ebola data
options(stringsAsFactors = FALSE)
ebola_data <- read.csv(file = 'country_timeseries.csv', header = TRUE)
ebola_data$Date <- as.Date(ebola_data$Date, "%m/%d/%Y")

# Subset country data for the three different countries
eb_guinea = subset(ebola_data, 
                   select = c(Date, Cases_Guinea, Deaths_Guinea))
colnames(eb_guinea) <- c('Date', 'Cases', 'Deaths')
eb_liberia = subset(ebola_data, 
                    select = c(Date, Cases_Liberia, Deaths_Liberia))
colnames(eb_liberia) <- c('Date', 'Cases', 'Deaths')
eb_sierra = subset(ebola_data, 
                   select = c(Date, Cases_SierraLeone, Deaths_SierraLeone))
colnames(eb_sierra) <- c('Date', 'Cases', 'Deaths')

# Create mortality data frames for the three countries
mort_guinea <- data.frame(eb_guinea$Date, 
                          eb_guinea$Deaths / eb_guinea$Cases * 100)
colnames(mort_guinea) <- c('Date', 'Mortality')
mort_liberia <- data.frame(eb_liberia$Date,
                           eb_liberia$Deaths / eb_liberia$Cases * 100)
colnames(mort_liberia) <- c('Date', 'Mortality')
mort_sierra <- data.frame(eb_sierra$Date,
                          eb_sierra$Deaths / eb_sierra$Cases * 100)
colnames(mort_sierra) <- c('Date', 'Mortality')

# Group the three countries in a list. This is used for dynamic country
# selection in the plotting routine.
country_names = list('Guinea', 'Liberia', 'Sierra Leone')
country_list = list(eb_guinea, eb_liberia, eb_sierra)
mort_list = list(mort_guinea, mort_liberia, mort_sierra)

# Reshape data for ggplotting multiple lines in one panel.
mymelt <- function (df) { return(melt(df, id = 'Date')) }
country_list <- lapply(country_list, mymelt)
mort_list <- lapply(mort_list, mymelt)

# Clean up: Remove now unused variables from workspace.
rm(ebola_data, eb_guinea, eb_liberia, eb_sierra,
   mort_guinea, mort_liberia, mort_sierra, mymelt)

# Define server logic
shinyServer(function(input, output) {
    
    output$ebolaPlot <- renderPlot({
        # Country is picked via the radio buttons in ui.R
        country_num = as.integer(input$country_number)
        country = country_names[[country_num]]
        country_data = country_list[[country_num]]
        
        # Do the plot.
        ggplot(country_data, aes(x = Date, y = value, colour = variable)) +
               geom_point() + stat_smooth() +
               labs(x = "Date", y = paste("Ebola cases in", country))
    })
    
    output$mortalityPlot <- renderPlot({
        # Country is picked via the radio buttons in ui.R
        country_num = as.integer(input$country_number)
        country = country_names[[country_num]]
        country_data = mort_list[[country_num]]
        
        # Do the plot.
        ggplot(country_data, aes(x = Date, y = value, colour = variable)) +
               geom_point() + stat_smooth() +
               labs(x = "Date", y = paste("Ebola mortality [%] in", country))
    })
})