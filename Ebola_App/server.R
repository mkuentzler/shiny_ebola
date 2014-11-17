library(shiny)
library(reshape2)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    # Read in the Ebola data, impute missing values by averaging
    options(stringsAsFactors = FALSE)
    ebola_data <- read.csv(file = 'country_timeseries.csv', header = TRUE)
    ebola_data$Date <- as.Date(ebola_data$Date, "%m/%d/%Y")
    
    # Subset country data
    eb_guinea = subset(ebola_data, 
                       select = c(Date, Cases_Guinea, Deaths_Guinea))
    colnames(eb_guinea) <- c('Date', 'Cases', 'Deaths')
    eb_liberia = subset(ebola_data, 
                        select = c(Date, Cases_Liberia, Deaths_Liberia))
    colnames(eb_liberia) <- c('Date', 'Cases', 'Deaths')
    eb_sierra = subset(ebola_data, 
                       select = c(Date, Cases_SierraLeone, Deaths_SierraLeone))
    colnames(eb_sierra) <- c('Date', 'Cases', 'Deaths')
    
    country_names = list('Guinea', 'Liberia', 'Sierra Leone')
    country_list = list(eb_guinea, eb_liberia, eb_sierra)
    
    output$ebolaPlot <- renderPlot({
        country = country_names[[as.integer(input$country_number)]]
        country_data = country_list[[as.integer(input$country_number)]]
        
        ggplot(melt(country_data, id = 'Date'), 
               aes(x = Date, y = value, colour = variable)) +
            geom_point() + stat_smooth() +
            labs(x = "Date", y = paste("Ebola cases in", 
                                       country))
    })
    
    output$mortalityPlot <- renderPlot({
        country = country_names[[as.integer(input$country_number)]]
        country_data = country_list[[as.integer(input$country_number)]]
        country_data$Mortality <- country_data$Deaths / country_data$Cases * 100
        country_data$Cases <- NULL
        country_data$Deaths <- NULL
        
        ggplot(melt(country_data, id = 'Date'), 
               aes(x = Date, y = value, colour = variable)) +
            geom_point() + stat_smooth() +
            labs(x = "Date", y = paste("Ebola mortality (in %) in", 
                                       country))
    })
})