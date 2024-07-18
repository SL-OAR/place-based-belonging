##################################
# Place Based Belonging App.     #
# by OAR Extern team             #
# ui.R file                      #
##################################

library(leaflet)
library(shinydashboard)
library(collapsibleTree)
library(shinycssloaders)
library(DT)
library(tigris)
library(reactable)
library(markdown)
library(treemapify)

# Load data
path <- here::here()
setwd(path)
pbb_tables_for_tm <- readRDS(here::here("code/www/pbb_tables_for_tm.rds"))
pbb_tables_for_tm_names <- names(pbb_tables_for_tm)
for (name in pbb_tables_for_tm_names) {
  assign(name, pbb_tables_for_tm[[name]])
}

# UI
ui <- fluidPage(
  includeCSS("www/style.css"),
  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
  ),
  dashboardPage(
    skin = "blue",
    dashboardHeader(title="University of Oregon Place Based Belonging", titleWidth = 200),
    dashboardSidebar(width = 300,
                     sidebarMenu(
                       tags$a(href="https://studentlife.uoregon.edu/research",
                              tags$img(src="uo_stacked_gray.png", title="Example Image Link", width="250", height="300")),
                       menuItem("Who is SWaSI?", tabName = "about", icon = icon("users")),
                       menuItem("Summary", tabName = "summary", icon = icon("thumbtack")),
                       menuItem("Where? Campus Belonging", tabName = "campus", icon = icon("table")),
                       menuItem("Where? EMU Belonging", tabName = "emu", icon = icon("random", lib = "glyphicon")),
                       menuItem("Where? Inclusiveness", tabName = "inclusiveness", icon = icon("stats", lib = "glyphicon")),
                       menuItem("Why There? Wordnets & Wordclouds", tabName = "words", icon = icon("dashboard")),
                       menuItem("Why There? Emotions", tabName = "emotions", icon = icon("dashboard")),
                       menuItem("Where for Whom?", tabName = "whom", icon = icon("question")),
                       menuItem("Between Here and Where?", tabName = "between", icon = icon("question")),
                       menuItem("Supplemental Method", tabName = "method", icon = icon("question")),
                       HTML(paste0("<br>",
                                   "<br>",
                                   "<script>",
                                   "var today = new Date();",
                                   "var yyyy = today.getFullYear();",
                                   "</script>",
                                   "<p style = 'text-align: center;'><small>&copy; - <a href='https://github.com/UOSLAR' target='_blank'>https://github.com/UOSLAR</a> - <script>document.write(yyyy);</script></small></p>")
                       ))
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "about", includeMarkdown("www/pbb-about.md")),
        tabItem(tabName = "summary", includeMarkdown("www/summary.md")),
        tabItem(tabName = "campus",
                fluidRow(
                  column(width = 6,
                         box(width = NULL, uiOutput("typeSelect")),
                         box(width = NULL, uiOutput("yearSelect")),
                         box(width = NULL, uiOutput("cohortSelect")),
                         box(width = NULL, background = "black", "Some text here."),
                         fluidRow(reactableOutput("table") %>% withSpinner(color = "green"))),
                  column(width = 6,
                         box(width = NULL, title = "Belong", solidHeader = TRUE),
                         uiOutput("campusHeatMaps") %>% withSpinner(color = "green"),
                         box(width = NULL, title = "Don't Belong", solidHeader = TRUE),
                         uiOutput("ggplot2Group1") %>% withSpinner(color = "green"))))
      )
    )
  )
)
######################
#### Server logic ####
######################
server <- shinyServer(function(input, output, session) {
  
  output$typeSelect <- renderUI({
    selectInput("typeSelect", "Select Type:", choices = c("Undergraduate", "International", "Graduate"))
  })
  
  output$yearSelect <- renderUI({
    req(input$typeSelect)
    choices <- switch(input$typeSelect,
                      "Undergraduate" = c("2018", "2019", "2020", "2022", "Overall"),
                      "International" = c("Undergrad 2020", "Overall"),
                      "Graduate" = c("Overall", "2022"))
    selectInput("yearSelect", "Select Year:", choices = choices)
  })
  
  output$cohortSelect <- renderUI({
    req(input$typeSelect, input$yearSelect)
    if (input$typeSelect == "Undergraduate") {
      selectInput("cohortSelect", "Select Cohort:", 
                  choices = c("1st Year", "2nd Year", "3rd Year", "4th Year", "All Years"))
    } else {
      selectInput("cohortSelect", "No cohort available.")
    }
  })
  
  output$table <- renderReactable({
    req(input$typeSelect, input$yearSelect)
    table_to_display <- switch(input$typeSelect,
                               "Undergraduate" = switch(input$yearSelect,
                                                        "Overall" = us_ug,
                                                        "2022" = us_ug_ay2122,
                                                        "2020" = us_ug_ay1920,
                                                        "2019" = us_ug_ay1819,
                                                        "2018" = us_ug_ay1718),
                               "International" = switch(input$yearSelect,
                                                        "Overall" = i,
                                                        "Undergrad 2020" = i_ug_ay1920),
                               "Graduate" = gr_ay2122)
    reactable_fun(table_to_display)
  })
  
  output$campusHeatMaps <- renderImage({
    base_path <- "/Users/daragon/Dropbox (University of Oregon)/projects/place-based-belonging/code/www/maps/"
    image_src_belonging <- ""
    image_src_not_belonging <- ""
    
    if (input$typeSelect == "Undergraduate" && input$yearSelect == "2022") {
      image_src_belonging <- "maps/map_cam_b_us_ug_ay2122.png"
      image_src_not_belonging <- "maps/map_cam_db_us_ug_ay2122.png"
    }
    list(src = image_src_belonging, contentType = 'image/png', alt = "Belonging Heat Map")
  }, deleteFile = FALSE)
})

shinyApp(ui = ui, server = server)

