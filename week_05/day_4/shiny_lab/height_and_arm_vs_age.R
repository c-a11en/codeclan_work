

# load in libraries -------------------------------------------------------

library(shiny)
library(tidyverse)


# read in data ------------------------------------------------------------

students_big <- read_csv("data/students_big.csv")

age_choice <- students_big %>% 
  distinct(ageyears) %>% 
  arrange(ageyears) %>% 
  pull()




# ui ----------------------------------------------------------------------



ui <- fluidPage(
  
  radioButtons("age_input",
               "Age",
               choices = age_choice,
               inline = TRUE),

  fluidRow(
    
    column(width = 6,
           plotOutput("height_plot")
    ),
    
    column(width = 6,
           plotOutput("arm_plot")
    )
  )
)


server <- function(input, output) {
  
  filtered_students <- reactive({
    students_big %>% 
      filter(ageyears == input$age_input)
    
  })
  
  
  
  output$height_plot <- renderPlot({
    filtered_students() %>% 
      ggplot(aes(height)) +
      geom_histogram(bins = 30)
  })
  
  output$arm_plot <- renderPlot({
    filtered_students() %>% 
      ggplot(aes(arm_span)) +
      geom_histogram(bins = 30)
    
  })
}

# run app -----------------------------------------------------------------

shinyApp(ui = ui, server = server)