library(shiny)
library(tidyverse)
library(DT)

# read in and prep data ---------------------------------------------------

students_big <- read_csv("data/students_big.csv")

handed_choices <- students_big %>% 
  distinct(handed) %>% 
  pull()

region_choices <- students_big %>%
  group_by(region) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count)) %>% 
  pull(region)

gender_choices <- students_big %>% 
  distinct(gender) %>% 
  pull()

colour_choices <- c("Red", "Blue")

# addin two plots to the ui, underneath the buttons, above the table
# add in the code to the server to makes these plots appear

# ui ----------------------------------------------------------------------

ui <- fluidPage(

  fluidRow(
    
    column(width = 4,
           radioButtons("handed_input",
                        "Handedness",
                        choices = handed_choices,
                        inline = TRUE)
    ),
    
    column(width = 4,
           selectInput("region_input",
                       "Select Region",
                       choices = region_choices)
    ),
    
    column(width = 4,
           selectInput("gender_input",
                       "Select Gender",
                       choices = gender_choices)
    )
  ),
  
  fluidRow(
    
    column(width = 2,
           radioButtons("colour_input",
                        "Colour",
                        choices = colour_choices,
                        inline = TRUE)
    ),
    
    column(width = 2, offset = 2,
           actionButton("update", "Update dashboard"))
    
  ),
  
  fluidRow(
    
    column(6, 
           plotOutput("travel_barplot")),
    
    column(6,
           plotOutput("spoken_barplot"))
  ),
  
  DT::dataTableOutput("table_output")
  
)


# server ------------------------------------------------------------------

server <- function(input, output) {
  
  filtered_data <- eventReactive(input$update,{
    students_big %>%
    filter(handed == input$handed_input &
           region == input$region_input &
           gender == input$gender_input)
  }) 
  
  
  output$table_output <- DT::renderDataTable({
    filtered_data()
  })
  
  output$travel_barplot <- renderPlot({
    filtered_data() %>% 
      ggplot(aes(x = travel_to_school)) +
      geom_bar(fill = input$colour_input)
    
  })
  
  output$spoken_barplot <- renderPlot({
    filtered_data() %>% 
      ggplot(aes(x = languages_spoken)) +
      geom_bar(fill = input$colour_input)
  })

}


# run app -----------------------------------------------------------------

shinyApp(ui = ui, server = server)
