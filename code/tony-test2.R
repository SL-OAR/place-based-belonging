
library(shiny)
library(reactable)
library(htmltools)
library(treemapify)
library(tidyverse)
library(rvest)
library(leaflet.extras)
library(shinydashboard)
library(shinycssloaders)
library(here)

# Set working directory
path <- here::here()
setwd(path)

# Reading in data
# tree maps
pbb_tables_for_tm <- readRDS(here::here("data/separated/pbb_tables_for_tm.rds"))
pbb_tables_for_tm_names <- names(pbb_tables_for_tm)
for (name in pbb_tables_for_tm_names) {
  assign(paste0("tm_", name), pbb_tables_for_tm[[name]])
}

# reactable tables
pbb_tables_for_rt <- readRDS(here::here("data/separated/pbb_tables_for_rt.rds"))
pbb_tables_for_rt_names <- names(pbb_tables_for_rt)
for (name in pbb_tables_for_rt_names) {
  assign(paste0("rt_", name), pbb_tables_for_rt[[name]])
}

# bar plots
pbb_tables_for_bp <- readRDS(here::here("data/separated/pbb_tables_for_bp.rds"))
pbb_tables_for_bp_names <- names(pbb_tables_for_bp)
for (name in pbb_tables_for_bp_names) {
  assign(paste0("bp_", name), pbb_tables_for_bp[[name]])
}

# bar_plot_list <- list.files(path = "code/www/bars", pattern = "ebar_.*\\.png", full.names = TRUE)
# bar_plot_info <- lapply(strsplit(basename(bar_plot_list), "_|\\.png"), function(x) {
#  list(building_name = x[2], belong_status = x[3], group = x[4])
#   })
# bar_plot_df <- do.call(rbind, lapply(bar_plot_info, as.data.frame))
# colnames(bar_plot_df) <- c("building_name", "belong_status", "group")
# building_names <- unique(bar_plot_df$building_name)
# belong_statuses <- unique(bar_plot_df$belong_status)
# groups <- unique(bar_plot_df$group)



source("code/helpers.R")

available_maps <- c(
  "map_emu_b_gr_ay2122.png",
  "map_emu_db_us_ug_ay2122_c2122.png",
  "map_emu_db_us_ug_ay2122_c2021.png",
  "map_emu_db_us_ug_ay2122_c1920.png",
  "map_emu_db_us_ug_ay2122_c1819.png",
  "map_emu_db_us_ug_ay2122.png",
  "map_emu_db_us_ug_ay1920_c1920.png",
  "map_emu_db_us_ug_ay1920_c1819.png",
  "map_emu_db_us_ug_ay1920_c1718.png",
  "map_emu_db_us_ug_ay1920_c1617.png",
  "map_emu_db_us_ug_ay1920.png",
  "map_emu_db_us_ug_ay1819_c1819.png",
  "map_emu_db_us_ug_ay1819_c1718.png",
  "map_emu_db_us_ug_ay1819_c1617.png",
  "map_emu_db_us_ug_ay1819_c1516.png",
  "map_emu_db_us_ug_ay1819.png",
  "map_emu_db_us_ug_ay1718.png",
  "map_emu_db_i_ug_ay1920.png",
  "map_emu_db_i_ay2122.png",
  "map_emu_db_gr_ay2122.png",
  "map_emu_b_us_ug_ay2122_c2122.png",
  "map_emu_b_us_ug_ay2122_c2021.png",
  "map_emu_b_us_ug_ay2122_c1920.png",
  "map_emu_b_us_ug_ay2122_c1819.png",
  "map_emu_b_us_ug_ay2122.png",
  "map_emu_b_us_ug_ay1920_c1920.png",
  "map_emu_b_us_ug_ay1920_c1819.png",
  "map_emu_b_us_ug_ay1920_c1718.png",
  "map_emu_b_us_ug_ay1920_c1617.png",
  "map_emu_b_us_ug_ay1920.png",
  "map_emu_b_us_ug_ay1819_c1819.png",
  "map_emu_b_us_ug_ay1819_c1718.png",
  "map_emu_b_us_ug_ay1819_c1617.png",
  "map_emu_b_us_ug_ay1819_c1516.png",
  "map_emu_b_us_ug_ay1819.png",
  "map_emu_b_us_ug_ay1718.png",
  "map_emu_b_i_ug_ay1920.png",
  "map_emu_b_i_ay2122.png",
  # Add campus maps
  "map_cam_db_us_ug_ay2122_c2122.png",
  "map_cam_db_us_ug_ay2122_c2021.png",
  "map_cam_db_us_ug_ay2122_c1920.png",
  "map_cam_db_us_ug_ay2122_c1819.png",
  "map_cam_db_us_ug_ay2122.png",
  "map_cam_db_us_ug_ay1920_c1920.png",
  "map_cam_db_us_ug_ay1920_c1819.png",
  "map_cam_db_us_ug_ay1920_c1718.png",
  "map_cam_db_us_ug_ay1920_c1617.png",
  "map_cam_db_us_ug_ay1920.png",
  "map_cam_db_us_ug_ay1819_c1819.png",
  "map_cam_db_us_ug_ay1819_c1718.png",
  "map_cam_db_us_ug_ay1819_c1617.png",
  "map_cam_db_us_ug_ay1819_c1516.png",
  "map_cam_db_us_ug_ay1819.png",
  "map_cam_db_us_ug_ay1718.png",
  "map_cam_db_us_ug_ay1617.png",
  "map_cam_db_i_ug_ay1920.png",
  "map_cam_db_i_ay2122.png",
  "map_cam_db_gr_ay2122.png",
  "map_cam_b_us_ug_ay2122_c2122.png",
  "map_cam_b_us_ug_ay2122_c2021.png",
  "map_cam_b_us_ug_ay2122_c1920.png",
  "map_cam_b_us_ug_ay2122_c1819.png",
  "map_cam_b_us_ug_ay2122.png",
  "map_cam_b_us_ug_ay1920_c1920.png",
  "map_cam_b_us_ug_ay1920_c1819.png",
  "map_cam_b_us_ug_ay1920_c1718.png",
  "map_cam_b_us_ug_ay1920_c1617.png",
  "map_cam_b_us_ug_ay1920.png",
  "map_cam_b_us_ug_ay1819_c1819.png",
  "map_cam_b_us_ug_ay1819_c1718.png",
  "map_cam_b_us_ug_ay1819_c1617.png",
  "map_cam_b_us_ug_ay1819_c1516.png",
  "map_cam_b_us_ug_ay1819.png",
  "map_cam_b_us_ug_ay1718.png",
  "map_cam_b_us_ug_ay1617.png",
  "map_cam_b_i_ug_ay1920.png",
  "map_cam_b_i_ay2122.png",
  "map_cam_b_gr_ay2122.png"
)


# UI
ui <- shinyUI(fluidPage(
  includeCSS("www/style.css"),
  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
  ),
  dashboardPage(
    skin = "blue",
    dashboardHeader(title = "University of Oregon Place Based Belonging", titleWidth = 500),
    dashboardSidebar(width = 300,
                     sidebarMenu(
                       tags$a(href = "https://studentlife.uoregon.edu/research",
                              tags$img(src = "uo_stacked_gray.png", title = "Example Image Link", width = 250, height = 300)),
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
                       )
                     )
    ), # end dashboard Sidebar
    
    dashboardBody(
      tabItems(
        tabItem(tabName = "about", includeMarkdown("www/pbb-about.md")),
        tabItem(tabName = "summary", includeMarkdown("www/summary.md")),
        tabItem(tabName = "campus",
                fluidRow(
                  column(4, uiOutput("typeSelectCampus")),
                  column(4, uiOutput("yearSelectCampus")),
                  column(4, uiOutput("cohortSelectCampus"))
                ),
                fluidRow(
                  column(width = 6,
                         uiOutput("mapsDisplayCampus")),
                  column(width = 12,
                         reactableOutput("tableCampus"))
                )
        ),
        tabItem(tabName = "emu",
                fluidRow(
                  column(4, uiOutput("typeSelectEmu")),
                  column(4, uiOutput("yearSelectEmu")),
                  column(4, uiOutput("cohortSelectEmu"))
                ),
                fluidRow(
                  column(width = 6,
                         uiOutput("mapsDisplayEmu")),
                  column(width = 12,
                         reactableOutput("tableEmu"))
                )
        ),
        tabItem(
          tabName = "inclusiveness",
          fluidRow(
            column(12, 
                   selectInput("locationSelect", "Select Campus Location:", choices = c("Full Campus", "EMU Student Union"))
            )
          ),
          conditionalPanel(
            condition = "input.locationSelect == 'Full Campus'",
            fluidRow(
              column(12, 
                     selectInput("visualizationType", "Select Visualization Type:", choices = c("Disaggregated - Tree Maps", "Aggregated - Bar Plot"))
              )
            ),
            fluidRow(
              column(4, uiOutput("typeSelectInclusiveBar")),
              column(4, uiOutput("yearSelectInclusiveBar")),
              column(4, uiOutput("cohortSelectInclusiveBar"))
            ),
            conditionalPanel(
              condition = "input.visualizationType == 'Aggregated - Bar Plot'",
              fluidRow(
                column(width = 12,
                       box(width = 12, style = "height:400px;", title = "Inclusiveness", solidHeader = TRUE, uiOutput("inclusiveBar"))
                )
              )
            ),
            conditionalPanel(
              condition = "input.visualizationType == 'Disaggregated - Tree Maps'",
              fluidRow(
                column(4, uiOutput("typeSelectCampusTreeMap")),
                column(4, uiOutput("yearSelectCampusTreeMap")),
                column(4, uiOutput("cohortSelectCampusTreeMap"))
              ),
              fluidRow(
                column(width = 12,
                       box(width = 12, style = "height:400px;", title = "Campus Inclusiveness Tree Map", solidHeader = TRUE, plotOutput("campusTree"))
                )
              )
            )
          ),
          conditionalPanel(
            condition = "input.locationSelect == 'EMU Student Union'",
            fluidRow(
              column(4, uiOutput("typeSelectEmuTreeMap")),
              column(4, uiOutput("yearSelectEmuTreeMap")),
              column(4, uiOutput("cohortSelectEmuTreeMap"))
            ),
            fluidRow(
              column(width = 12,
                     box(width = 12, style = "height:400px;", title = "EMU Inclusiveness Tree Map", solidHeader = TRUE, plotOutput("emuTree"))
              )
            )
          )
        ),
        tabItem(tabName = "words", fluidRow(uiOutput("dynamicFilter")),
                fluidRow(
                  column(width = 6,
                         box(width = NULL, title = "Campus Inclusiveness", solidHeader = FALSE),
                         box(width = NULL, title = "EMU Inclusiveness", solidHeader = FALSE))
                ),
                column(width = 6,
                       box(width = NULL, title = "Campus Inclusiveness", solidHeader = FALSE),
                       box(width = NULL, title = "EMU Inclusiveness", solidHeader = FALSE))
        ),
        tabItem(tabName = "emotions",
                fluidRow(
                  column(width = 6,
                         box(width = NULL, title = "Plutchik's Wheel of Emotions", solidHeader = TRUE),
                         box(width = NULL, background = "black", "text about emo.")),
                  column(width = 6,
                         box(width = NULL, uiOutput("dynamicFilter")),
                         box(width = NULL, background = "black", "Bar graphs here."))
                )
        ),
        tabItem(tabName = "whom", includeMarkdown("www/whom.md")),
        tabItem(tabName = "between", includeMarkdown("www/between.md")),
        tabItem(tabName = "method", includeMarkdown("www/method.md"))
      ) # end tabItems
    ) # end dashboardBody
  ) # end dashboardPage
))


###################################################################


# Server
server <- function(input, output, session) {
  # Ensure all required inputs are available before proceeding
  check_inputs <- function(...) {
    inputs <- list(...)
    for (input in inputs) {
      if (is.null(input)) return(FALSE)
    }
    return(TRUE)
  }
  

  
  # Type Select Campus
  output$typeSelectCampus <- renderUI({
    selectInput("typeSelectCampus", "Select Type:", choices = c("Undergraduate", "International", "Graduate"))
  })
  
  # Year Select Campus
  output$yearSelectCampus <- renderUI({
    req(input$typeSelectCampus)
    if (input$typeSelectCampus == "Undergraduate") {
      selectInput("yearSelectCampus", "Select Year:", choices = c("2018", "2019", "2020", "2022", "Overall"))
    } else if (input$typeSelectCampus == "International") {
      selectInput("yearSelectCampus", "Select Year:", choices = c("Undergrad 2020", "Overall"))
    } else if (input$typeSelectCampus == "Graduate") {
      selectInput("yearSelectCampus", "Select Year:", choices = c("Overall", "2022"))
    }
  })
  
  # Cohort Select Campus
  output$cohortSelectCampus <- renderUI({
    req(input$typeSelectCampus, input$yearSelectCampus)
    if (input$typeSelectCampus == "Undergraduate" && input$yearSelectCampus %in% c("2019", "2020", "2022")) {
      choices <- switch(input$yearSelectCampus,
                        "2019" = c("All Cohorts", "15/16", "16/17", "17/18", "18/19"),
                        "2020" = c("All Cohorts", "16/17", "17/18", "18/19", "19/20"),
                        "2022" = c("All Cohorts", "18/19", "19/20", "20/21", "21/22"))
      selectInput("cohortSelectCampus", "Select Cohort:", choices = choices)
    } else {
      selectInput("cohortSelectCampus", "Select Cohort:", choices = c("No cohort available"))
    }
  })
  
  # Type Select EMU
  output$typeSelectEmu <- renderUI({
    selectInput("typeSelectEmu", "Select Type:", choices = c("Undergraduate", "International", "Graduate"))
  })
  
  # Year Select EMU
  output$yearSelectEmu <- renderUI({
    req(input$typeSelectEmu)
    if (input$typeSelectEmu == "Undergraduate") {
      selectInput("yearSelectEmu", "Select Year:", choices = c("2018", "2019", "2020", "2022", "Overall"))
    } else if (input$typeSelectEmu == "International") {
      selectInput("yearSelectEmu", "Select Year:", choices = c("Undergrad 2020", "Overall"))
    } else if (input$typeSelectEmu == "Graduate") {
      selectInput("yearSelectEmu", "Select Year:", choices = c("Overall", "2022"))
    }
  })
  
  # Cohort Select EMU
  output$cohortSelectEmu <- renderUI({
    req(input$typeSelectEmu, input$yearSelectEmu)
    if (input$typeSelectEmu == "Undergraduate" && input$yearSelectEmu %in% c("2019", "2020", "2022")) {
      choices <- switch(input$yearSelectEmu,
                        "2019" = c("All Cohorts", "15/16", "16/17", "17/18", "18/19"),
                        "2020" = c("All Cohorts", "16/17", "17/18", "18/19", "19/20"),
                        "2022" = c("All Cohorts", "18/19", "19/20", "20/21", "21/22"))
      selectInput("cohortSelectEmu", "Select Cohort:", choices = choices)
    } else {
      selectInput("cohortSelectEmu", "Select Cohort:", choices = c("No cohort available"))
    }
  })
  
  
  
## Inclusiveness ##
  
  # Dynamically generate the building selection for bar plots (including EMU)
  
  
  # This will be used for Emotion bar plots
  
  # output$buildingSelectBarPlot <- renderUI({
  #   req(input$visualizationType == "Aggregated - Bar Plots")
  #   selectInput("buildingSelectBarPlot", "Select Building:",
  #               choices = c("EMU", "Allen", "Atrium", "Autzen", "Barnhart", "Bean", "Carson",
  #                           "Chapman", "Columbia", "Courtyard", "Craft", "Ducknest",
  #                           "Earl", "Fallingsky", "Fishbowl", "Frohnmayer",
  #                           "GSH", "Hamilton", "Hayward", "Hedco", "Housing", "Jaqua",
  #                           "Kalapuya", "Klamath", "Law", "Lawrence", "LGBTQA3", "Library",
  #                           "Lillis", "LISB", "LLC", "Lokey", "Mattknight", "MCC", "Mckenzie",
  #                           "Mills", "Olounge", "Oregon", "SCICOM", "SRC", "Straub",
  #                           "Taylor", "Tykeson", "UHS", "Unthank", "Walton", "Willamette",
  #                           "Womens"))
  # })
  
 # Inclusive Bar Plots # 
  # Type Select Inclusive Bar
  output$typeSelectInclusiveBar <- renderUI({
    req(input$visualizationType == "Aggregated - Bar Plot")
    selectInput("typeSelectInclusiveBar", "Select Type:", choices = c("Undergraduate", "International", "Graduate"))
  })
  
  # Year Select Inclusive Bar
  output$yearSelectInclusiveBar <- renderUI({
    req(input$visualizationType == "Aggregated - Bar Plot")
    selectInput("yearSelectInclusiveBar", "Select Year:", choices = c("Overall" , "2022", "2020", "2019", "2018"))
  })
  
  # Cohort Select Inclusive Bar
  output$cohortSelectInclusiveBar <- renderUI({
    req(input$visualizationType == "Aggregated - Bar Plot")
    selectInput("cohortSelectInclusiveBar", "Select Cohort:", 
                choices = c("All Years", "1st Year", "2nd Year", "3rd Year", "4th Year"))
  })
  
  # Tree Maps Inclusiveness #
  # Campus #
  # Type Select Campus Tree Map
  output$typeSelectCampusTreeMap <- renderUI({
    selectInput("typeSelectCampusTreeMap", "Select Type:", choices = c("Undergraduate", "International", "Graduate"))
  })
  
  # Year Select Campus Tree Map
  output$yearSelectCampusTreeMap <- renderUI({
    req(input$typeSelectCampusTreeMap)
    if (input$typeSelectCampusTreeMap == "Undergraduate") {
      selectInput("yearSelectCampusTreeMap", "Select Year:", choices = c("Overall", "2018", "2019", "2020", "2022"))
    } else if (input$typeSelectCampusTreeMap == "International") {
      selectInput("yearSelectCampusTreeMap", "Select Year:", choices = c("Overall", "2020"))
    } else if (input$typeSelectCampusTreeMap == "Graduate") {
      selectInput("yearSelectCampusTreeMap", "Select Year:", choices = c("2022"))
    }
  })
  
  # Cohort Select Campus Tree Map
  output$cohortSelectCampusTreeMap <- renderUI({
    req(input$typeSelectCampusTreeMap, input$yearSelectCampusTreeMap)
    if (input$typeSelectCampusTreeMap == "Undergraduate") {
      if (input$yearSelectCampusTreeMap %in% c("2022", "2020", "2019")) {
        choices <- switch(input$yearSelectCampusTreeMap,
                          "2022" = c("All Years", "4th Year", "3rd Year", "2nd Year", "1st Year"),
                          "2020" = c("All Years", "4th Year", "3rd Year", "2nd Year", "1st Year"),
                          "2019" = c("All Years", "4th Year", "3rd Year", "2nd Year", "1st Year"))
        selectInput("cohortSelectCampusTreeMap", "Select Cohort:", choices = choices)
      } else if (input$yearSelectCampusTreeMap == "2018") {
        selectInput("cohortSelectCampusTreeMap", "Select Cohort:", choices = c("1st-3rd Years"))
      } else {
        selectInput("cohortSelectCampusTreeMap", "Select Cohort:", choices = c("No cohort available"))
      }
    } else {
      selectInput("cohortSelectCampusTreeMap", "Select Cohort:", choices = c("No cohort available"))
    }
  })
  
  
  # EMU #
  # Type Select EMU Tree Map
  output$typeSelectEmuTreeMap <- renderUI({
    selectInput("typeSelectEmuTreeMap", "Select Type:", choices = c("Undergraduate", "International", "Graduate"))
  })
  
  # Year Select EMU Tree Map
  output$yearSelectEmuTreeMap <- renderUI({
    req(input$typeSelectEmuTreeMap)
    
    if (input$typeSelectEmuTreeMap == "Undergraduate") {
      selectInput("yearSelectEmuTreeMap", "Select Year:", 
                  choices = c("2018", "2019", "2020", "2022", "Overall"))
    } else if (input$typeSelectEmuTreeMap == "International") {
      selectInput("yearSelectEmuTreeMap", "Select Year:", 
                  choices = c("Overall", "2022", "Spring 2020"))
    } else if (input$typeSelectEmuTreeMap == "Graduate") {
      selectInput("yearSelectEmuTreeMap", "Select Year:", 
                  choices = c("Overall"))
    }
  })
  
  # Cohort Select EMU Tree Map
  output$cohortSelectEmuTreeMap <- renderUI({
    req(input$typeSelectEmuTreeMap, input$yearSelectEmuTreeMap)
    
    if (input$typeSelectEmuTreeMap == "Undergraduate") {
      if (input$yearSelectEmuTreeMap %in% c("2022", "2020", "2019")) {
        choices <- switch(input$yearSelectEmuTreeMap,
                          "2022" = c("All Years", "4th Year", "3rd Year", "2nd Year", "1st Year"),
                          "2020" = c("All Years", "4th Year", "3rd Year", "2nd Year", "1st Year"),
                          "2019" = c("All Years", "4th Year", "3rd Year", "2nd Year", "1st Year"))
        selectInput("cohortSelectEmuTreeMap", "Select Cohort:", choices = choices)
      } else if (input$yearSelectEmuTreeMap == "2018") {
        selectInput("cohortSelectEmuTreeMap", "Select Cohort:", choices = c("1st-3rd Years"))
      } else {
        selectInput("cohortSelectEmuTreeMap", "Select Cohort:", choices = c("No cohort available"))
      }
    } else if (input$typeSelectEmuTreeMap == "International") {
      selectInput("cohortSelectEmuTreeMap", "Select Cohort:", choices = c("No cohort available"))
    } else if (input$typeSelectEmuTreeMap == "Graduate") {
      selectInput("cohortSelectEmuTreeMap", "Select Cohort:", choices = c("No cohort available"))
    }
  })
  
  
  
  ### RenderBarPlot Function ###
  
  # Render Campus Bar Plots 
  output$inclusiveBar <- renderUI({
    req(input$visualizationType == "Aggregated - Bar Plot")
    
    type <- input$typeSelectInclusiveBar
    year <- input$yearSelectInclusiveBar
    cohort <- input$cohortSelectInclusiveBar
    
    print(paste("Year value:", year))
    print(paste("Cohort value:", cohort))
    
    # Ensure that type is a single valid string
    if (length(type) != 1 || is.null(type)) {
      return(HTML("<p>Invalid type selection.</p>"))
    }
    
    # Determine the correct filename based on the selected type, year, and cohort
    if (type == "Undergraduate") {
      filename <- switch(year,
                         "Overall" = "ibar_cam_us_ug.png",
                         "2022" = switch(cohort,
                                         "All Years" = "ibar_cam_us_ug_ay2122.png",
                                         "4th Year" = "ibar_cam_us_ug_ay2122_c2122.png",
                                         "3rd Year" = "ibar_cam_us_ug_ay2122_c2021.png",
                                         "2nd Year" = "ibar_cam_us_ug_ay2122_c1920.png",
                                         "1st Year" = "ibar_cam_us_ug_ay2122_c1819.png"),
                         "2020" = switch(cohort,
                                         "All Years" = "ibar_cam_us_ug_ay1920.png",
                                         "4th Year" = "ibar_cam_us_ug_ay1920_c1920.png",
                                         "3rd Year" = "ibar_cam_us_ug_ay1920_c1819.png",
                                         "2nd Year" = "ibar_cam_us_ug_ay1920_c1718.png",
                                         "1st Year" = "ibar_cam_us_ug_ay1920_c1617.png"),
                         "2019" = switch(cohort,
                                         "All Years" = "ibar_cam_us_ug_ay1819.png",
                                         "4th Year" = "ibar_cam_us_ug_ay1819_c1819.png",
                                         "3rd Year" = "ibar_cam_us_ug_ay1819_c1718.png",
                                         "2nd Year" = "ibar_cam_us_ug_ay1819_c1617.png",
                                         "1st Year" = "ibar_cam_us_ug_ay1819_c1516.png"),
                         "2018" = "ibar_cam_us_ug_ay1718.png")
    } else if (type == "International") {
      filename <- switch(year,
                         "Overall" = "ibar_cam_i.png",
                         "2022" = "ibar_cam_i_ay2122.png",
                         "2020" = "ibar_cam_i_ug_ay1920.png")
    } else if (type == "Graduate") {
      filename <- switch(year,
                         "2022" = "ibar_cam_gr_ay2122.png")
    } else {
      return(HTML("<p>No valid data for the selected options.</p>"))
    }
    
    # Construct the full path to the image file
    full_image_path <- file.path(getwd(), "www", "ibars", filename)
    print(paste("Checking full path:", full_image_path))
    
    # Check if the file exists and then adjust the image path for Shiny
    if (file.exists(full_image_path)) {
      print(paste("File found:", full_image_path))
      image_path <- file.path("ibars", filename)
      return(img(src = image_path, height = "400px"))
    } else {
      print(paste("File not found:", full_image_path))
      return(HTML("<p>No image available for the selected options.</p>"))
    }
  })
  
  
  
  
  
  ### Campus Trees ###
  
  renderCampusTree <- function(type, year, cohort) {
    data <- NULL
    
    # Assign input values, and make sure they are of length 1 - Chat GPT's fix for a warning I was receiving about Null values
    type <- if (!is.null(input$typeSelectCampusTreeMap) && length(input$typeSelectCampusTreeMap) == 1) {
      input$typeSelectCampusTreeMap
    } else {
      NA
    }
    
    year <- if (!is.null(input$yearSelectCampusTreeMap) && length(input$yearSelectCampusTreeMap) == 1) {
      input$yearSelectCampusTreeMap
    } else {
      NA
    }
    
    cohort <- if (!is.null(input$cohortSelectCampusTreeMap) && length(input$cohortSelectCampusTreeMap) == 1) {
      input$cohortSelectCampusTreeMap
    } else {
      NA
    }
    
    # Check if type is "Undergraduate" and if year is valid
    if (!is.na(type) && type == "Undergraduate") {
      data <- switch(year,
                     "Overall" = tm_cam_us_ug,
                     "2022" = switch(cohort,
                                     "All Years" = tm_cam_us_ug_ay2122,
                                     "4th Year" = tm_cam_us_ug_ay2122_c2122,
                                     "3rd Year" = tm_cam_us_ug_ay2122_c2021,
                                     "2nd Year" = tm_cam_us_ug_ay2122_c1920,
                                     "1st Year" = tm_cam_us_ug_ay2122_c1819),
                     "2020" = switch(cohort,
                                     "All Years" = tm_cam_us_ug_ay1920,
                                     "4th Year" = tm_cam_us_ug_ay1920_c1920,
                                     "3rd Year" = tm_cam_us_ug_ay1920_c1819,
                                     "2nd Year" = tm_cam_us_ug_ay1920_c1718,
                                     "1st Year" = tm_cam_us_ug_ay1920_c1617),
                     "2019" = switch(cohort,
                                     "All Years" = tm_cam_us_ug_ay1819,
                                     "4th Year" = tm_cam_us_ug_ay1819_c1819,
                                     "3rd Year" = tm_cam_us_ug_ay1819_c1718,
                                     "2nd Year" = tm_cam_us_ug_ay1819_c1617,
                                     "1st Year" = tm_cam_us_ug_ay1819_c1516),
                     "2018" = tm_cam_us_ug_ay1718
      )
    } else if (!is.na(type) && type == "International") {
      data <- switch(year,
                     "Overall" = tm_cam_i,
                     "2020" = tm_cam_i_ug_ay1920
      )
    } else if (!is.na(type) && type == "Graduate") {
      data <- switch(year,
                     "2022" = tm_cam_gr_ay2122
      )
    }
    
    # Ensure data is not NULL, is a dataframe, and has the 'tot' column
    if (!is.null(data) && is.data.frame(data) && "tot" %in% colnames(data)) {
      inclusive_tree_fun(data)
    } else {
      HTML("<p>No data available or required column 'tot' is missing for the selected options.</p>")
    }
  }
  
    
  
  # Render tree maps for Campus
  output$campusTree <- renderPlot({
    req(input$visualizationType == "Disaggregated - Tree Maps" && input$locationSelect == "Full Campus")
    renderCampusTree(input$typeSelectCampusTreeMap, input$yearSelectCampusTreeMap, input$cohortSelectCampusTreeMap)
  })
  
  
  ### EMU Trees ###
  
  renderEmuTree <- function(type, year, cohort) {
    data <- NULL
    
    # Assign input values, and make sure they are of length 1 - Chat GPT's fix for a warning I was receiving about Null values
    type <- if (!is.null(input$typeSelectEmuTreeMap) && length(input$typeSelectEmuTreeMap) == 1) {
      input$typeSelectEmuTreeMap
    } else {
      NA
    }
    
    year <- if (!is.null(input$yearSelectEmuTreeMap) && length(input$yearSelectEmuTreeMap) == 1) {
      input$yearSelectEmuTreeMap
    } else {
      NA
    }
    
    cohort <- if (!is.null(input$cohortSelectEmuTreeMap) && length(input$cohortSelectEmuTreeMap) == 1) {
      input$cohortSelectEmuTreeMap
    } else {
      NA
    }
    
    img_path <- "www/Nothing_to_see.png"  
    
    # Check conditions for rendering specific tree maps
    if (!is.null(type) && !is.na(type) && type == "Undergraduate") {
      data <- switch(year,
                     "Overall" = tm_emu_us_ug,
                     "2018" = tm_emu_us_ug_ay1718,
                     "2019" = switch(cohort,
                                     "All Years" = tm_emu_us_ug_ay1819,
                                     "1st Year" = tm_emu_us_ug_ay1819_c1819),
                     "2020" = switch(cohort,
                                     "All Years" = tm_emu_us_ug_ay1920,
                                     "1st Year" = tm_emu_us_ug_ay1920_c1920,
                                     "2nd Year" = tm_emu_us_ug_ay1920_c1819),
                     "2022" = switch(cohort,
                                     "All Years" = tm_emu_us_ug_ay2122,
                                     "1st Year" = tm_emu_us_ug_ay2122_c2122))
    } else if (!is.null(type) && !is.na(type) && type == "International") {
      # International doesn't have any tree maps available
      grid::grid.raster(png::readPNG(img_path))
      grid::grid.text("Insufficient data for International tree map to display", 
                      gp = grid::gpar(fontsize = 20, col = "black"), 
                      y = 0.1, just = "bottom")
      return(NULL)
    } else if (!is.null(type) && !is.na(type) && type == "Graduate") {
      # Graduate doesn't have any tree maps available
      grid::grid.raster(png::readPNG(img_path))
      grid::grid.text("Insufficient data for Graduate tree map to display", 
                      gp = grid::gpar(fontsize = 20, col = "black"), 
                      y = 0.1, just = "bottom")
      return(NULL)
    }
    
    # Render the tree map if data exists
    if (!is.null(data)) {
      inclusive_tree_fun(data)
    } else {
      # Fallback: No data available, show "Nothing to See" image
      grid::grid.raster(png::readPNG(img_path))
      grid::grid.text(paste("Insufficient data for", type, year, cohort,"to display"), 
                      gp = grid::gpar(fontsize = 20, col = "black"), 
                      y = 0.1, just = "bottom")
    }
  }
  
  # Render tree maps for EMU
  output$emuTree <- renderPlot({
    req(input$locationSelect == 'EMU Student Union')
    renderEmuTree(input$typeSelectEmuTreeMap, input$yearSelectEmuTreeMap, input$cohortSelectEmuTreeMap)
  })
  
  
  
## Reactable Tables: 
  # Reactable Table for Campus Maps
  output$tableCampus <- renderReactable({
    # Ensure inputs are available
    if (is.null(input$typeSelectCampus) || is.null(input$yearSelectCampus) || is.null(input$cohortSelectCampus)) return()
    
    # Initialize variables
    table_to_display <- NULL
    year <- input$yearSelectCampus
    cohort <- input$cohortSelectCampus
    type <- input$typeSelectCampus
    
    # Mapping years
    year_map <- list("2018" = "1718", "2019" = "1819", "2020" = "1920", "2022" = "2122")
    
    # Helper function to create table name
    create_table_name <- function(type, year, cohort) {
      mapped_year <- year_map[[year]]
      if (is.null(mapped_year)) return(NULL)
      
      if (cohort == "All Cohorts" || cohort == "No cohort available") {
        return(paste0("rt_", type, "_ay", mapped_year))
      } else {
        cohort <- gsub("/", "", cohort)
        return(paste0("rt_", type, "_ay", mapped_year, "_c", cohort))
      }
    }
    
    # Determine the table to display
    if (type == "Undergraduate") {
      if (year == "Overall") {
        table_to_display <- reactable_fun(rt_us_ug)
      } else {
        table_name <- create_table_name("us_ug", year, cohort)
        table_to_display <- tryCatch({ reactable_fun(get(table_name)) }, error = function(e) { NULL })
      }
    } else if (type == "International") {
      if (year == "Overall") {
        table_to_display <- reactable_fun(rt_i)
      } else if (year == "Undergrad 2020") {
        table_to_display <- reactable_fun(rt_i_ug_ay1920)
      } else if (year == "2022") {
        table_to_display <- reactable_fun(rt_i_ay2122)
      }
    } else if (type == "Graduate" && year == "2022") {
      table_to_display <- reactable_fun(rt_gr_ay2122)
    }
    
    # Render the table or a message if no data is available
    if (!is.null(table_to_display)) {
      table_to_display
    } else {
      HTML("<p>No data available for the selected options.</p>")
    }
  })
  
 
## Reactable Tables: 
  # Reactable Tables for EMU
  output$tableEmu <- renderReactable({
    # Ensure inputs are available
    if (is.null(input$typeSelectEmu) || is.null(input$yearSelectEmu) || is.null(input$cohortSelectEmu)) return()
    
    # Initialize variables
    table_to_display <- NULL
    year <- input$yearSelectEmu
    cohort <- input$cohortSelectEmu
    type <- input$typeSelectEmu
    
    # Mapping years
    year_map <- list("2018" = "1718", "2019" = "1819", "2020" = "1920", "2022" = "2122")
    
    # Helper function to create table name
    create_table_name <- function(type, year, cohort) {
      mapped_year <- year_map[[year]]
      if (is.null(mapped_year)) return(NULL)
      
      if (cohort == "All Cohorts" || cohort == "No cohort available") {
        return(paste0("rt_", type, "_ay", mapped_year))
      } else {
        cohort <- gsub("/", "", cohort)
        return(paste0("rt_", type, "_ay", mapped_year, "_c", cohort))
      }
    }
    
    # Determine the table to display
    if (type == "Undergraduate") {
      if (year == "Overall") {
        table_to_display <- reactable_fun(pbb_tables_for_rt$us_ug)
      } else {
        table_name <- create_table_name("us_ug", year, cohort)
        table_to_display <- tryCatch({ reactable_fun(pbb_tables_for_rt[[table_name]]) }, error = function(e) { NULL })
      }
    } else if (type == "International") {
      if (year == "Overall") {
        table_to_display <- reactable_fun(pbb_tables_for_rt$i)
      } else if (year == "Undergrad 2020") {
        table_to_display <- reactable_fun(pbb_tables_for_rt$i_ug_ay1920)
      } else if (year == "2022") {
        table_to_display <- reactable_fun(pbb_tables_for_rt$i_ay2122)
      }
    } else if (type == "Graduate" && year == "2022") {
      table_to_display <- reactable_fun(pbb_tables_for_rt$gr_ay2122)
    }
    
    # Render the table or a message if no data is available
    if (!is.null(table_to_display)) {
      table_to_display
    } else {
      HTML("<p>No data available for the selected options.</p>")
    }
  })
  
## Heat Maps: 
  # Heat Maps for EMU
  output$mapsDisplayEmu <- renderUI({
    req(input$typeSelectEmu, input$yearSelectEmu, input$cohortSelectEmu)
    base_path <- "maps/"
    image_src_belonging <- ""
    image_src_not_belonging <- ""
    if (input$typeSelectEmu == "Undergraduate") {
      year <- input$yearSelectEmu
      if (year == "Overall") {
        image_src_belonging <- "map_emu_b_us_ug.png"
        image_src_not_belonging <- "map_emu_db_us_ug.png"
      } else {
        mapped_year <- switch(year, "2018" = "1718", "2019" = "1819", "2020" = "1920", "2022" = "2122")
        cohort <- input$cohortSelectEmu
        if (cohort == "All Cohorts" || cohort == "No cohort available") {
          image_src_belonging <- paste0("map_emu_b_us_ug_ay", mapped_year, ".png")
          image_src_not_belonging <- paste0("map_emu_db_us_ug_ay", mapped_year, ".png")
        } else {
          cohort <- gsub("/", "", cohort)
          image_src_belonging <- paste0("map_emu_b_us_ug_ay", mapped_year, "_c", cohort, ".png")
          image_src_not_belonging <- paste0("map_emu_db_us_ug_ay", mapped_year, "_c", cohort, ".png")
        }
      }
    } else if (input$typeSelectEmu == "International") {
      if (input$yearSelectEmu == "Overall") {
        image_src_belonging <- "map_emu_b_i.png"
        image_src_not_belonging <- "map_emu_db_i.png"
      } else if (input$yearSelectEmu == "Undergrad 2020") {
        image_src_belonging <- "map_emu_b_i_ug_ay1920.png"
        image_src_not_belonging <- "map_emu_db_i_ug_ay1920.png"
      } else if (input$yearSelectEmu == "2022") {
        image_src_belonging <- "map_emu_b_i_ay2122.png"
        image_src_not_belonging <- "map_emu_db_i_ay2122.png"
      }
    } else if (input$typeSelectEmu == "Graduate" && input$yearSelectEmu == "2022") {
      image_src_belonging <- "map_emu_b_gr_ay2122.png"
      image_src_not_belonging <- "map_emu_db_gr_ay2122.png"
    }
    print(paste("Belonging image source:", image_src_belonging))
    print(paste("Not belonging image source:", image_src_not_belonging))
    if (image_src_belonging %in% available_maps && image_src_not_belonging %in% available_maps) {
      tagList(
        tags$h3("Belonging Map"),
        img(src = paste0(base_path, image_src_belonging), height = "600px", style = "margin-bottom: 20px; padding-right: 20px;"),
        tags$h3("Not Belonging Map"),
        img(src = paste0(base_path, image_src_not_belonging), height = "600px", style = "margin-bottom: 20px; padding-right: 20px;"),
        tags$p(paste("Selected Type:", input$typeSelectEmu, "Year:", input$yearSelectEmu, "Cohort:", input$cohortSelectEmu))
      )
    } else {
      tagList(
        tags$h3("No map available for the selected options."),
        tags$p(paste("Selected Type:", input$typeSelectEmu, "Year:", input$yearSelectEmu, "Cohort:", input$cohortSelectEmu))
      )
    }
  })
  
  
## Heat Maps:
  # Heat Maps for Campus
  output$mapsDisplayCampus <- renderUI({
    req(input$typeSelectCampus, input$yearSelectCampus, input$cohortSelectCampus)
    base_path <- "maps/"
    image_src_belonging <- ""
    image_src_not_belonging <- ""
    
    print(paste("typeSelectCampus:", input$typeSelectCampus))
    print(paste("yearSelectCampus:", input$yearSelectCampus))
    print(paste("cohortSelectCampus:", input$cohortSelectCampus))
    
    if (input$typeSelectCampus == "Undergraduate") {
      year <- input$yearSelectCampus
      if (year == "Overall") {
        image_src_belonging <- "map_cam_b_us_ug.png"
        image_src_not_belonging <- "map_cam_db_us_ug.png"
      } else {
        mapped_year <- switch(year, "2018" = "1718", "2019" = "1819", "2020" = "1920", "2022" = "2122")
        cohort <- input$cohortSelectCampus
        if (cohort == "All Cohorts" || cohort == "No cohort available") {
          image_src_belonging <- paste0("map_cam_b_us_ug_ay", mapped_year, ".png")
          image_src_not_belonging <- paste0("map_cam_db_us_ug_ay", mapped_year, ".png")
        } else {
          cohort <- gsub("/", "", cohort)
          image_src_belonging <- paste0("map_cam_b_us_ug_ay", mapped_year, "_c", cohort, ".png")
          image_src_not_belonging <- paste0("map_cam_db_us_ug_ay", mapped_year, "_c", cohort, ".png")
        }
      }
    } else if (input$typeSelectCampus == "International") {
      if (input$yearSelectCampus == "Overall") {
        image_src_belonging <- "map_cam_b_i.png"
        image_src_not_belonging <- "map_cam_db_i.png"
      } else if (input$yearSelectCampus == "Undergrad 2020") {
        image_src_belonging <- "map_cam_b_i_ug_ay1920.png"
        image_src_not_belonging <- "map_cam_db_i_ug_ay1920.png"
      } else if (input$yearSelectCampus == "2022") {
        image_src_belonging <- "map_cam_b_i_ay2122.png"
        image_src_not_belonging <- "map_cam_db_i_ay2122.png"
      }
    } else if (input$typeSelectCampus == "Graduate" && input$yearSelectCampus == "2022") {
      image_src_belonging <- "map_cam_b_gr_ay2122.png"
      image_src_not_belonging <- "map_cam_db_gr_ay2122.png"
    }
    
    print(paste("Belonging image source:", image_src_belonging))
    print(paste("Not belonging image source:", image_src_not_belonging))
    
    if (image_src_belonging %in% available_maps && image_src_not_belonging %in% available_maps) {
      tagList(
        tags$h3("Belonging Map"),
        img(src = paste0(base_path, image_src_belonging), height = "600px", style = "margin-bottom: 20px; padding-right: 20px;"),
        tags$h3("Not Belonging Map"),
        img(src = paste0(base_path, image_src_not_belonging), height = "600px", style = "margin-bottom: 20px; padding-right: 20px;"),
        tags$p(paste("Selected Type:", input$typeSelectCampus, "Year:", input$yearSelectCampus, "Cohort:", input$cohortSelectCampus))
      )
    } else {
      tagList(
        tags$h3("No map available for the selected options."),
        tags$p(paste("Selected Type:", input$typeSelectCampus, "Year:", input$yearSelectCampus, "Cohort:", input$cohortSelectCampus))
      )
    }
  })
  
}

shinyApp(ui = ui, server = server)

