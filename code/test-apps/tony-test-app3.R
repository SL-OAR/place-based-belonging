
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
  assign(name, pbb_tables_for_tm[[name]])
}

# reactable tables
pbb_tables_for_rt <- readRDS(here::here("data/separated/pbb_tables_for_rt.rds"))
pbb_tables_for_rt_names <- names(pbb_tables_for_rt)
for (name in pbb_tables_for_rt_names) {
  assign(name, pbb_tables_for_rt[[name]])
}

# bar plots
pbb_tables_for_bp <- readRDS(here::here("data/separated/pbb_tables_for_bp.rds"))
pbb_tables_for_bp_names <- names(pbb_tables_for_bp)
for (name in pbb_tables_for_bp_names) {
  assign(name, pbb_tables_for_bp[[name]])
}

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

#########################################################
### UI                                                ###
#########################################################
ui <- shinyUI(fluidPage(
  
  includeCSS("www/style.css"),
  
  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
  ),
  
  # load page layout
  dashboardPage(
    skin = "blue",
    dashboardHeader(title = "University of Oregon Place Based Belonging", 
                    titleWidth = 500),
    dashboardSidebar(width = 300,
                     sidebarMenu(
                       tags$a(href = "https://studentlife.uoregon.edu/research",
                              tags$img(src = "uo_stacked_gray.png", 
                                       title = "Example Image Link",
                                       width = 250, 
                                       height = 300)),
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
    ), # end dashboardSidebar
    
    dashboardBody( #start dashboardBody
      tabItems( #start all tabItems
        
        tabItem(tabName = "about",
                includeMarkdown("www/pbb-about.md")
        ),
        
        tabItem(tabName = "summary",
                includeMarkdown("www/summary.md")
        ),
        
        tabItem(tabName = "campus",
                fluidRow(
                  column(4, uiOutput("typeSelectCampus")),
                  column(4, uiOutput("yearSelectCampus")),
                  column(4, uiOutput("cohortSelectCampus"))
                ),
                fluidRow(
                  column(width = 6,
                    box(width = NULL, title = "Belong/Don't Belong", solidHeader = TRUE), 
                    uiOutput("mapsDisplayCampus"),
                ),
                column(width =12,
                  box(width = NULL, tutle = "Reactable Table", solidHeader = TRUE), 
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
                         box(width = NULL, title = "Belong/Don't Belong", solidHeader = TRUE),
                         uiOutput("mapsDisplayEmu")
                         ),
                  column(width = 12,
                         box(width = NULL, title = "Reactable Table", solidHeader = TRUE), 
                         reactableOutput("tableEmu"))
                )
        ),
        
        tabItem(tabName = "inclusiveness",
                fluidRow(
                  column(4, uiOutput("typeSelectInclusiveness")),
                  column(4, uiOutput("yearSelectInclusiveness")),
                  column(4, uiOutput("cohortSelectInclusiveness"))
                ),
                fluidRow(
                  column(width = 6,
                         box(width = 12, style = "height:400px;", title = "Campus Inclusiveness - Aggregate", solidHeader = TRUE,
                             uiOutput("campusBar")),
                         box(width = 12, style = "height:400px;", title = "Campus Inclusiveness - Disaggregated", solidHeader = TRUE,
                             uiOutput("campusTree"))
                  ),
                  column(width = 6,
                         box(width = 12, style = "height:400px;", title = "EMU Inclusiveness - Aggregate", solidHeader = TRUE,
                             uiOutput("emuBar")),
                         box(width = 12, style = "height:400px;", title = "EMU Inclusiveness - Disaggregated", solidHeader = TRUE,
                             uiOutput("emuTree"))
                  )
                )
        ),
        
        tabItem(tabName = "words",
                fluidRow(uiOutput("dynamicFilter")),
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
        
        tabItem(tabName = "whom",
                includeMarkdown("www/whom.md")
        ),
        tabItem(tabName = "between",
                includeMarkdown("www/between.md")
        ),
        
        tabItem(tabName = "method",
                includeMarkdown("www/method.md")
        )
      ) #end tabItems
    ) # end dashboardBody
  )# end dashboardPage
))


######################
### Server ####
######################

server <- function(input, output, session) {
  

## Campus Selection Filter
  # Type Select Campus
  output$typeSelectCampus <- renderUI({
    selectInput("typeSelectCampus", "Select Type:", 
                choices = c("Undergraduate", "International", "Graduate"))
  })
  
  # Year Select Campus
  output$yearSelectCampus <- renderUI({
    req(input$typeSelectCampus)
    if (input$typeSelectCampus == "Undergraduate") {
      selectInput("yearSelectCampus", "Select Year:", 
                  choices = c("2018", "2019", "2020", "2022", "Overall"))
    } else if (input$typeSelectCampus == "International") {
      selectInput("yearSelectCampus", "Select Year:", 
                  choices = c("Undergrad 2020", "Overall"))
    } else if (input$typeSelectCampus == "Graduate") {
      selectInput("yearSelectCampus", "Select Year:",
                  choices = c("Overall", "2022"))
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
  
  
  
## Selection for EMU Tab  
  
  # Type Select EMU
  output$typeSelectEmu <- renderUI({
    selectInput("typeSelectEmu", "Select Type:", 
                choices = c("Undergraduate", "International", "Graduate"))
  })
  
  # Year Select EMU
  output$yearSelectEmu <- renderUI({
    req(input$typeSelectEmu)
    if (input$typeSelectEmu == "Undergraduate") {
      selectInput("yearSelectEmu", "Select Year:", 
                  choices = c("2018", "2019", "2020", "2022", "Overall"))
    } else if (input$typeSelectEmu == "International") {
      selectInput("yearSelectEmu", "Select Year:", 
                  choices = c("Undergrad 2020", "Overall"))
    } else if (input$typeSelectEmu == "Graduate") {
      selectInput("yearSelectEmu", "Select Year:",
                  choices = c("Overall", "2022"))
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
  
## Filters for Inclusiveness tab
  # Type Select for Inclusiveness
    output$typeSelectInclusiveness <- renderUI({
    selectInput("typeSelectInclusiveness", "Select Type:", 
                choices = c("Undergraduate", "International", "Graduate"))
  })
  
  # Year Select for Inclusiveness  
  output$yearSelectInclusiveness <- renderUI({
    req(input$typeSelectInclusiveness)
    if (input$typeSelectInclusiveness == "Undergraduate") {
      selectInput("yearSelectInclusiveness", "Select Year:", 
                  choices = c("2018", "2019", "2020", "2022", "Overall"))
    } else if (input$typeSelectInclusiveness == "International") {
      selectInput("typeSelectInclusiveness", "Select Year:", 
                  choices = c("Undergrad 2020", "Overall"))
    } else if (input$typeSelectInclusiveness == "Graduate") {
      selectInput("typeSelectInclusiveness", "Select Year:",
                  choices = c("Overall", "2022"))
    }
  })
  
  # Cohort Select for Inclusiveness
  output$cohortSelectInclusiveness <- renderUI({
    req(input$typeSelectInclusiveness)
    if (input$typeSelectInclusiveness == "Undergraduate") {
      selectInput("cohortSelectInclusiveness", "Select Cohort:", 
                  choices = c("1st Year", "2nd Year", "3rd Year", "4th Year", "All Years"))
    } else {
      selectInput("cohortSelectInclusiveness", "No cohort available.")
    }
  })
  
  
  # Dynamic Filter:
    # Not sure if this is needed
  
  output$dynamicFilter <- renderUI({
    req(input$typeSelect, input$yearSelect)
    
    if(input$typeSelect == "Undergraduate" && input$yearSelect %in% c("2018", "2019")) {
      selectInput("floorSelect", "Select Floor:", 
                  choices = c("Full Building", "Level 1", "Level 2"))
    }
  })
  

  
  
  # Render tree maps
  # Campus Tree Maps
  output$campusTree <- renderPlot({
    renderCampusTree(input)
  })
  
  # EMU Tree Maps (Does not currently work)
  output$emuTree <- renderPlot({
    renderEmuTree(input)
  })  
  
  # Render inclusiveness bars
  # Campus Bar Plots
  output$campusBar <- renderPlot({
    renderCampusBar(input)
  })
  
  # EMU Bar plots
  output$emuBar <- renderPlot({
    renderEmuBar(input)
  })  
  
  # This is old and can be removed
  # output$selectedType <- renderText({
  #   req(input$typeSelect, input$yearSelect, input$cohortSelect)
  #   paste("You have selected:", input$typeSelect, "Year:", input$yearSelect, "Cohort:", input$cohortSelect)
  # })
  
## Reactable Table for Campus Maps
  # Tables for Campus
  
  output$tableCampus <- renderReactable({
    req(input$typeSelectCampus, input$yearSelectCampus)
    
    table_to_display <- NULL
    
    if (input$typeSelectCampus == "Undergraduate") {
      year <- input$yearSelectCampus
      cohort <- input$cohortSelectCampus
      
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
      
    } else if (input$typeSelectCampus == "International") {
      if (input$yearSelectCampus == "Overall") {
        table_to_display <- reactable_fun(pbb_tables_for_rt$i)
      } else if (input$yearSelectCampus == "Undergrad 2020") {
        table_to_display <- reactable_fun(pbb_tables_for_rt$i_ug_ay1920)
      } else if (input$yearSelectCampus == "2022") {
        table_to_display <- reactable_fun(pbb_tables_for_rt$i_ay2122)
      }
      
    } else if (input$typeSelectCampus == "Graduate" && input$yearSelectCampus == "2022") {
      table_to_display <- reactable_fun(pbb_tables_for_rt$gr_ay2122)
    }
    
    if (!is.null(table_to_display)) {
      table_to_display
    } else {
      HTML("<p>No data available for the selected options.</p>")
    }
  })
  
  
## Reactable Tables for EMU
  # EMU Table
  output$tableEmu <- renderReactable({
    req(input$typeSelectEmu, input$yearSelectEmu)
    
    table_to_display <- NULL
    
    if (input$typeSelectEmu == "Undergraduate") {
      year <- input$yearSelectEmu
      cohort <- input$cohortSelectEmu
      
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
      
    } else if (input$typeSelectEmu == "International") {
      if (input$yearSelectEmu == "Overall") {
        table_to_display <- reactable_fun(pbb_tables_for_rt$i)
      } else if (input$yearSelectEmu == "Undergrad 2020") {
        table_to_display <- reactable_fun(pbb_tables_for_rt$i_ug_ay1920)
      } else if (input$yearSelectEmu == "2022") {
        table_to_display <- reactable_fun(pbb_tables_for_rt$i_ay2122)
      }
      
    } else if (input$typeSelectEmu == "Graduate" && input$yearSelectEmu == "2022") {
      table_to_display <- reactable_fun(pbb_tables_for_rt$gr_ay2122)
    }
    
    if (!is.null(table_to_display)) {
      table_to_display
    } else {
      HTML("<p>No data available for the selected options.</p>")
    }
  })
  
  
## Heat Maps EMU
  # EMU Heat maps
  
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
        mapped_year <- switch(year,
                              "2018" = "1718",
                              "2019" = "1819",
                              "2020" = "1920",
                              "2022" = "2122")
        
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
        img(src = paste0(base_path, image_src_belonging), height = "500px", style = "margin-bottom: 20px; padding-right: 20px;"),
        tags$h3("Not Belonging Map"),
        img(src = paste0(base_path, image_src_not_belonging), height = "500px", style = "margin-bottom: 20px; padding-right: 20px;"),
        tags$p(paste("Selected Type:", input$typeSelectEmu, "Year:", input$yearSelectEmu, "Cohort:", input$cohortSelectEmu))
      )
    } else {
      tagList(
        tags$h3("No map available for the selected options."),
        tags$p(paste("Selected Type:", input$typeSelectEmu, "Year:", input$yearSelectEmu, "Cohort:", input$cohortSelectEmu))
      )
    }
  })
  
  
# Campus Heat Maps
  
  output$mapsDisplayCampus <- renderImage({
    req(input$typeSelectCampus, input$yearSelectCampus, input$cohortSelectCampus)
    
    base_path <- "maps/"
    image_src_belonging <- ""
    image_src_not_belonging <- ""
    
    # Debugging messages to check input values
    print(paste("typeSelectCampus:", input$typeSelectCampus))
    print(paste("yearSelectCampus:", input$yearSelectCampus))
    print(paste("cohortSelectCampus:", input$cohortSelectCampus))
    
    # Ensure all necessary inputs are available
    if (is.null(input$typeSelectCampus) || is.null(input$yearSelectCampus) || is.null(input$cohortSelectCampus)) {
      return(list(src = "", contentType = 'image/png', alt = "No map available for the selected options."))
    }
    
    if (input$typeSelectCampus == "Undergraduate") {
      year <- input$yearSelectCampus
      
      if (year == "Overall") {
        image_src_belonging <- paste0(base_path, "map_cam_b_us_ug.png")
        image_src_not_belonging <- paste0(base_path, "map_cam_db_us_ug.png")
      } else {
        mapped_year <- switch(year,
                              "2018" = "1718",
                              "2019" = "1819",
                              "2020" = "1920",
                              "2022" = "2122",
                              "Unknown")
        
        if (mapped_year == "Unknown") {
          return(list(src = "", contentType = 'image/png', alt = "No map available for the selected year."))
        }
        
        cohort <- input$cohortSelectCampus
        if (cohort == "All Cohorts" || cohort == "No cohort available") {
          image_src_belonging <- paste0(base_path, "map_cam_b_us_ug_ay", mapped_year, ".png")
          image_src_not_belonging <- paste0(base_path, "map_cam_db_us_ug_ay", mapped_year, ".png")
        } else {
          cohort <- gsub("/", "", cohort)
          image_src_belonging <- paste0(base_path, "map_cam_b_us_ug_ay", mapped_year, "_c", cohort, ".png")
          image_src_not_belonging <- paste0(base_path, "map_cam_db_us_ug_ay", mapped_year, "_c", cohort, ".png")
        }
      }
      
    } else if (input$typeSelectCampus == "International") {
      if (input$yearSelectCampus == "Overall") {
        image_src_belonging <- paste0(base_path, "map_cam_b_i.png")
        image_src_not_belonging <- paste0(base_path, "map_cam_db_i.png")
      } else if (input$yearSelectCampus == "Undergrad 2020") {
        image_src_belonging <- paste0(base_path, "map_cam_b_i_ug_ay1920.png")
        image_src_not_belonging <- paste0(base_path, "map_cam_db_i_ug_ay1920.png")
      } else if (input$yearSelectCampus == "2022") {
        image_src_belonging <- paste0(base_path, "map_cam_b_i_ay2122.png")
        image_src_not_belonging <- paste0(base_path, "map_cam_db_i_ay2122.png")
      }
      
    } else if (input$typeSelectCampus == "Graduate" && input$yearSelectCampus == "2022") {
      image_src_belonging <- paste0(base_path, "map_cam_b_gr_ay2122.png")
      image_src_not_belonging <- paste0(base_path, "map_cam_db_gr_ay2122.png")
    }
    
    print(paste("Belonging image source:", image_src_belonging))
    print(paste("Not belonging image source:", image_src_not_belonging))
    
    if (image_src_belonging %in% available_maps && image_src_not_belonging %in% available_maps) {
      return(list(src = image_src_belonging, contentType = 'image/png', alt = "Belonging Map"))
    } else {
      return(list(src = "", contentType = 'image/png', alt = "No map available for the selected options."))
    }
  }, deleteFile = FALSE)
  
}

shinyApp(ui = ui, server = server)
