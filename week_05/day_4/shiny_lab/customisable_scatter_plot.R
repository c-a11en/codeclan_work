

# load in libraries -------------------------------------------------------

library(shiny)
library(tidyverse)


# read in data ------------------------------------------------------------

students_big <- read_csv("data/students_big.csv")

colour_choices <- c(Blue = "#3891A6", Yellow = "#FDE74C",
                              Red = "#E3655B")

shape_choices <- c(Square = 15, Circle = 16, Triangle = 17)

# ui ----------------------------------------------------------------------



ui <- fluidPage(
  
  titlePanel(title = "Reaction Time vs. Memory Game"),
  
  sidebarLayout(
    
    sidebarPanel = sidebarPanel(
      
      radioButtons("colour_input",
                   "Colour of points",
                   choices = colour_choices),
      
      sliderInput("transparency_input",
                  "Transparency of points",
                  min = 0,
                  max = 1,
                  value = 0.5),
      
      selectInput("shape_input",
                  "Shape of Points",
                  choices = shape_choices),
      
      textInput("title_input",
                "Title of Graph",
                value = "")
    ),
    mainPanel = mainPanel(
      plotOutput("scatter_plot")
    )
  )
)


server <- function(input, output) {
  
  output$scatter_plot <- renderPlot({
    students_big %>%
      ggplot(aes(x = reaction_time,
                 y = score_in_memory_game)) +
      geom_point(colour = input$colour_input,
                 alpha = input$transparency_input,
                 shape = as.numeric(input$shape_input)) +
      labs(title = input$title_input)
  })

}

# run app -----------------------------------------------------------------

shinyApp(ui = ui, server = server)