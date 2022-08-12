
library(tidyverse)
library(ggplot2)
library(shiny)
library(bslib)

olympic_overall_medals <- read_csv("data/olympics_overall_medals.csv") %>% 
  mutate(medal = factor(medal, c("Gold", "Silver", "Bronze")))

ui <- fluidPage(

  titlePanel(tags$h1("Olympic Medals")),
  
  tabsetPanel(
    
    tabPanel("Plot",
             plotOutput('medal_plot'),
    ),
    
    tabPanel("Which season?",
             radioButtons(inputId = 'season_input',
                          label = tags$i('Summer or Winter Olympics?'),
                          choices = unique(olympic_overall_medals$season)
             )
    ),
    
    tabPanel("Which team?",
             selectInput(inputId = 'team_input',
                         label = 'Which team?',
                         choices = unique(olympic_overall_medals$team)
             )
    )
  ),
  
  # HTML: HyperText Markup Language
  tags$a('The Olympics website', href = 'https://www.Olympic.org')
)
  


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$medal_plot <- renderPlot({
    olympic_overall_medals %>%
      filter(team == input$team_input,
             season == input$season_input) %>%
      ggplot(aes(x = medal, y = count, fill = medal)) +
      geom_col()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)