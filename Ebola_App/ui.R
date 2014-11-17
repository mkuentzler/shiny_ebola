library(shiny)

# Define UI
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Ebola: cases, deaths, and mortality in 
                Western African countries"),
    
    fluidRow( p("This Shiny app shows the (accumulated) number of Ebola cases and
                deaths for the three west African countries mostly affected by its
                outbreak, as well as calculating and plotting mortality rates.
                 Original data from",
                a(href='https://github.com/cmrivers/ebola/blob/master/country_timeseries.csv',
                  'here.'))
        ),
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
        sidebarPanel(
            radioButtons("country_number", label = h3("Select a country"),
                         choices = list("Guinea" = 1, "Liberia" = 2, 
                                        "Sierra Leone" = 3), 
                         selected = 1)
        ),
        
        # Show a plot of the generated distributions
        mainPanel(
            plotOutput("ebolaPlot"),
            plotOutput("mortalityPlot")
        )
    )
))