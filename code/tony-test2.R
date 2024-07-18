library(shiny)
library(reactable)

ui <- fluidPage(
  titlePanel("Basic Shiny App"),
  sidebarLayout(
    sidebarPanel(
      selectInput("typeSelect", "Select Type:", choices = c("Undergraduate", "International", "Graduate"))
    ),
    mainPanel(
      textOutput("selectedType"),
      reactableOutput("table"),
      uiOutput("emuImage")
    )
  )
)

server <- function(input, output) {
  print(getwd())  # Add this line to check the working directory
  
  output$selectedType <- renderText({
    paste("You have selected:", input$typeSelect)
  })
  
  output$table <- renderReactable({
    data.frame(A = 1:10, B = 11:20) %>% reactable()
  })
  
  output$emuImage <- renderUI({
    tagList(
      tags$img(src = "maps/map_emu_db_us_ug_ay2122.png", height = "500px"),
      tags$img(src = "maps/map_emu_b_us_ug_ay2122.png", height = "500px")
    )
  })
}

shinyApp(ui = ui, server = server)

