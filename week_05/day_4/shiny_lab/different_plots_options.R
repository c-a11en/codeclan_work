

# load in libraries -------------------------------------------------------

library(shiny)
library(tidyverse)


# read in data ------------------------------------------------------------

students_big <- read_csv("data/students_big.csv")

plot_types <- c("Bar", "Horizontal Bar", "Stacked Bar")

# ui ----------------------------------------------------------------------



ui <- fluidPage(
  
      radioButtons("plot_type_input",
                   "Plot Type",
                   choices = plot_types),
      
      plotOutput("plot")
    )

server <- function(input, output) {

  output$plot <- renderPlot({
    
    #read control flow notes
    
    if(input$plot_type_input == "Bar") {
        students_big %>% 
        ggplot(aes(x = handed, fill = gender)) +
        geom_bar(position = "dodge")
    } else {
      
      if(input$plot_type_input == "Horizontal Bar") {
        
        students_big %>%
          ggplot(aes(x = handed, fill = gender)) +
          geom_bar(position = "dodge") +
          coord_flip()
        
      } else {
        
        students_big %>%
          ggplot(aes(x = handed, fill = gender)) +
          geom_bar(position = "stack")
      }
    }
  })
}

# run app -----------------------------------------------------------------

shinyApp(ui = ui, server = server)