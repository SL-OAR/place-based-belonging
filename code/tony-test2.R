library(shiny)
library(reactable)
library(htmltools)
library(treemapify)
library(tidyverse)
library(rvest)
library(leaflet.extras)
library(shinydashboard)
library(shinycssloaders)

path <- here::here()
setwd(path)

# Reading in data
pbb_tables_for_tm <- readRDS(here::here("data/separated/pbb_tables_for_tm.rds"))
pbb_tables_for_rt <- readRDS(here::here("data/separated/pbb_tables_for_rt.rds"))
pbb_tables_for_bp <- readRDS(here::here("data/separated/pbb_tables_for_bp.rds"))
source("code/helpers.R")

# List of available map file names
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
  "map_emu_b_i_ay2122.png"
)


# Define the UI
ui <- fluidPage(
  titlePanel("Emu belonging Shiny App"),
  sidebarLayout(
    sidebarPanel(
      fluidRow(
        column(width = 6,
               box(width = NULL, uiOutput("typeSelect")),
               box(width = NULL, uiOutput("yearSelect")),
               box(width = NULL, uiOutput("cohortSelect"))
        )
      )
    ),
    mainPanel(
      textOutput("selectedType"),
      uiOutput("mapsDisplay"),
      reactableOutput("table")
    )
  )
)


# Define the server logic
server <- function(input, output, session) {
  
  output$typeSelect <- renderUI({
    selectInput("typeSelect", "Select Type:", choices = c("Undergraduate", "International", "Graduate"))
  })
  
  output$yearSelect <- renderUI({
    req(input$typeSelect)
    choices <- switch(input$typeSelect,
                      "Undergraduate" = c("Overall", "2018", "2019", "2020", "2022"),
                      "International" = c("Overall", "Undergrad 2020", "2022"),
                      "Graduate" = c("2022"))
    selectInput("yearSelect", "Select Year:", choices = choices)
  })
  
  output$cohortSelect <- renderUI({
    req(input$typeSelect, input$yearSelect)
    
    # Determine if cohorts should be displayed based on the selected year
    show_cohort <- switch(input$typeSelect,
                          "Undergraduate" = input$yearSelect %in% c("2019", "2020", "2022"),
                          "International" = FALSE,
                          "Graduate" = FALSE)
    
    if (show_cohort) {
      choices <- switch(input$yearSelect,
                        "2019" = c("All Cohorts", "15/16", "16/17", "17/18", "18/19"),
                        "2020" = c("All Cohorts", "16/17", "17/18", "18/19", "19/20"),
                        "2022" = c("All Cohorts", "18/19", "19/20", "20/21", "21/22"))
      selectInput("cohortSelect", "Select Cohort:", choices = choices)
    } else {
      selectInput("cohortSelect", "Select Cohort:", choices = c("No cohort available"))
    }
  })
  
  output$selectedType <- renderText({
    req(input$typeSelect, input$yearSelect, input$cohortSelect)
    paste("You have selected:", input$typeSelect, "Year:", input$yearSelect, "Cohort:", input$cohortSelect)
  })
  
  output$table <- renderReactable({
    req(input$typeSelect, input$yearSelect)
    
    table_to_display <- NULL
    
    if (input$typeSelect == "Undergraduate") {
      year <- input$yearSelect
      cohort <- input$cohortSelect
      
      if (year == "Overall") {
        table_to_display <- reactable_fun(pbb_tables_for_rt$us_ug)
      } else {
        mapped_year <- switch(year,
                              "2018" = "1718",
                              "2019" = "1819",
                              "2020" = "1920",
                              "2022" = "2122")
        if (cohort == "All Cohorts" || cohort == "No cohort available") {
          table_name <- paste0("us_ug_ay", mapped_year)
        } else {
          cohort <- gsub("/", "", cohort)
          table_name <- paste0("us_ug_ay", mapped_year, "_c", cohort)
        }
        table_to_display <- tryCatch({
          reactable_fun(pbb_tables_for_rt[[table_name]])
        }, error = function(e) {
          NULL
        })
      }
      
    } else if (input$typeSelect == "International") {
      if (input$yearSelect == "Overall") {
        table_to_display <- reactable_fun(pbb_tables_for_rt$i)
      } else if (input$yearSelect == "Undergrad 2020") {
        table_to_display <- reactable_fun(pbb_tables_for_rt$i_ug_ay1920)
      } else if (input$yearSelect == "2022") {
        table_to_display <- reactable_fun(pbb_tables_for_rt$i_ay2122)
      }
      
    } else if (input$typeSelect == "Graduate" && input$yearSelect == "2022") {
      table_to_display <- reactable_fun(pbb_tables_for_rt$gr_ay2122)
    }
    
    if (!is.null(table_to_display)) {
      table_to_display
    } else {
      HTML("<p>No data available for the selected options.</p>")
    }
  })
  
  output$mapsDisplay <- renderUI({
    req(input$typeSelect, input$yearSelect, input$cohortSelect)
    base_path <- "maps/"
    image_src_belonging <- ""
    image_src_not_belonging <- ""
    
    if (input$typeSelect == "Undergraduate") {
      year <- input$yearSelect
      
      if (year == "Overall") {
        image_src_belonging <- "map_emu_b_us_ug.png"
        image_src_not_belonging <- "map_emu_db_us_ug.png"
      } else {
        mapped_year <- switch(year,
                              "2018" = "1718",
                              "2019" = "1819",
                              "2020" = "1920",
                              "2022" = "2122")
        
        cohort <- input$cohortSelect
        if (cohort == "All Cohorts" || cohort == "No cohort available") {
          image_src_belonging <- paste0("map_emu_b_us_ug_ay", mapped_year, ".png")
          image_src_not_belonging <- paste0("map_emu_db_us_ug_ay", mapped_year, ".png")
        } else {
          cohort <- gsub("/", "", cohort)
          image_src_belonging <- paste0("map_emu_b_us_ug_ay", mapped_year, "_c", cohort, ".png")
          image_src_not_belonging <- paste0("map_emu_db_us_ug_ay", mapped_year, "_c", cohort, ".png")
        }
      }
      
    } else if (input$typeSelect == "International") {
      if (input$yearSelect == "Overall") {
        image_src_belonging <- "map_emu_b_i.png"
        image_src_not_belonging <- "map_emu_db_i.png"
      } else if (input$yearSelect == "Undergrad 2020") {
        image_src_belonging <- "map_emu_b_i_ug_ay1920.png"
        image_src_not_belonging <- "map_emu_db_i_ug_ay1920.png"
      } else if (input$yearSelect == "2022") {
        image_src_belonging <- "map_emu_b_i_ay2122.png"
        image_src_not_belonging <- "map_emu_db_i_ay2122.png"
      }
      
    } else if (input$typeSelect == "Graduate" && input$yearSelect == "2022") {
      image_src_belonging <- "map_emu_b_gr_ay2122.png"
      image_src_not_belonging <- "map_emu_db_gr_ay2122.png"
    }
    
    print(paste("Belonging image source:", image_src_belonging))
    print(paste("Not belonging image source:", image_src_not_belonging))
    
    if (image_src_belonging %in% available_maps && image_src_not_belonging %in% available_maps) {
      tagList(
        tags$h3("Belonging Map"),
        img(src = paste0(base_path, image_src_belonging), height = "500px", style = "margin-bottom: 20px; padding-right: 20px;"),
        tags$h3("Not Belonging Map"),
        img(src = paste0(base_path, image_src_not_belonging), height = "500px", style = "margin-bottom: 20px; padding-right: 20px;"),
        tags$p(paste("Selected Type:", input$typeSelect, "Year:", input$yearSelect, "Cohort:", input$cohortSelect))
      )
    } else {
      tagList(
        tags$h3("No map available for the selected options."),
        tags$p(paste("Selected Type:", input$typeSelect, "Year:", input$yearSelect, "Cohort:", input$cohortSelect))
      )
    }
  })
}

shinyApp(ui = ui, server = server)