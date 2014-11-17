library(ggplot2)

setwd("/Users/Moritz/github/shiny_ebola")
options(stringsAsFactors = FALSE)
ebola_data <- read.csv(file = 'country_timeseries.csv', header = TRUE)
ebola_data$Date <- as.Date(ebola_data$Date, "%m/%d/%Y")

country_list = c('Guinea', 'Liberia', 'Sierra Leone')

country = country_list[as.integer(input$country_number)]
cases = cases_list[as.integer(input$country_number)]
deaths = deaths_list[as.integer(input$country_number)]

ggplot(ebola_data, aes_string(x = 'Date', y = cases)) +
        geom_point() + stat_smooth() +
        labs(x = "Date", y = paste("Ebola cases in", 
                                   country))

library(reshape2)

eb_guinea = subset(ebola_data, select = c(Date, Cases_Guinea, Deaths_Guinea))
colnames(eb_guinea) <- c('Date', 'Cases', 'Deaths')
eb_liberia = subset(ebola_data, select = c(Date, Cases_Liberia, Deaths_Liberia))
colnames(eb_liberia) <- c('Date', 'Cases', 'Deaths')
eb_sierra = subset(ebola_data, 
                    select = c(Date, Cases_SierraLeone, Deaths_SierraLeone))
colnames(eb_sierra) <- c('Date', 'Cases', 'Deaths')

ggplot(melt(eb_guinea, id = 'Date'), 
       aes(x = Date, y = value, colour = variable)) +
    geom_point() + stat_smooth() +
    labs(x = "Date", y = paste("Ebola cases in", 
                               'Country'))