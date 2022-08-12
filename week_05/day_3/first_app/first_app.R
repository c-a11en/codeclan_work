
library(tidyverse)
library(ggplot2)
library(shiny)
library(bslib)

olympic_overall_medals <- read_csv("data/olympics_overall_medals.csv") %>% 
  mutate(medal = factor(medal, c("Gold", "Silver", "Bronze")))

# all_teams <- unique(olympic_overall_medals$team)
# all_seasons <- unique(olympic_overall_medals$season)

ui <- fluidPage(
  
  theme = bs_theme(bootswatch = "darkly"),
  
  titlePanel(h1("Olympic Medals")),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      p("Sidebar"),
      p("Some other text in the side bar"),
      radioButtons(inputId = "season_input",
                   label = em("Summer or Winter Olympics?"),
                   choices = unique(olympic_overall_medals$season)
                   ),
      selectInput(inputId = "team_input",
                  label = "Which team?",
                  choices = unique(olympic_overall_medals$team)
                  )
    ),
    mainPanel = mainPanel(
      "Main panel",
      # br(),
      # br(),
      HTML("<br/>"),
      HTML("<br/>"),
      "Some other text in the main section",
      plotOutput("medal_plot"),
      
      #html = Hyper Text Markup Language
      tags$a("The olympics website", href = "https://www.olympic.org")
    )
  )
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
