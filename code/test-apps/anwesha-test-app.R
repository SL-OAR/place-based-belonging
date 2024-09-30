#

library(shiny)
library(shinydashboard)
library(tidyverse)
library(rvest)
library(leaflet.extras)
library(reactable)
library(here)
library(bslib)

library(leaflet)
library(shinydashboard)
library(collapsibleTree)
library(shinycssloaders)
library(DT)
library(tigris)
library(reactable)
library(markdown)
packrat::on()
reticulate::use_condaenv("oar_pbb", required = TRUE)
# packrat::snapshot()

path <- here::here()
setwd(path)

pbb_tables_for_tm <- readRDS(here::here("data/separated/pbb_tables_for_tm.rds"))

pbb_tables_for_tm_names <- names(pbb_tables_for_tm)

for (name in pbb_tables_for_tm_names) {
  assign(name, pbb_tables_for_tm[[name]])
}

source("code/helpers.R")




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
    dashboardHeader(title="University of Oregon Place Based Belonging", 
                    titleWidth = 500),
    dashboardSidebar(width = 300,
                     sidebarMenu(
                       tags$a(href="https://studentlife.uoregon.edu/research",
                                 tags$img(src="uo_stacked_gray.png", 
                                         title="Example Image Link",
                                         width="250", 
                                         height="300")),
                    #   img(src = "uo_stacked_gray.png", height="50%", width="50%",
                    #       href='https://studentlife.uoregon.edu/research'),
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
                     
    ), # end dashboardSidebar
    
    dashboardBody( #startdashboardBody
      
      tabItems( #start all tabItems
        
        tabItem(tabName = "about",
                
                # about section
                # uiOutput("aboutContent")
                includeMarkdown("www/pbb-about.md")
                # I am losing my mind with this section
                
        ),
        
        tabItem(tabName = "summary",
                
                # summary section
                includeMarkdown("www/summary.md")
                
        ),
        
        tabItem(tabName = "campus",
                
                fluidRow(
                  column(4, uiOutput("typeSelect")),
                  column(4, uiOutput("yearSelect")),
                  column(4, uiOutput("cohortSelect"))),
                fluidRow(box(width = NULL, title = "Belong", solidHeader = TRUE),
                         box(width = NULL, title = "Don't Belong", solidHeader = TRUE)) %>% 
                fluidRow(
                  reactableOutput("table") %>% withSpinner(color = "green"))
                
        ),
        
        tabItem(tabName = "emu",
                
                fluidRow(
                  column(4, uiOutput("typeSelect")),
                  column(4, uiOutput("yearSelect")),
                  column(4, uiOutput("cohortSelect"))),
                fluidRow(box(imageOutput("emuImage"))),
                # fluidRow(box(width = NULL, title = "Belong", solidHeader = TRUE),
                #          box(width = NULL, title = "Don't Belong", solidHeader = TRUE)),
                fluidRow(
                  reactableOutput("table") %>% withSpinner(color = "green"))
               
        ),
        
        tabItem(tabName = "inclusiveness",
                fluidRow(
                  column(width = 6,
                         box(width = 12, style = "height:400px;", title = "Campus Inclusiveness - Aggregate", solidHeader = TRUE,
                             plotOutput("campusBar")),
                         box(width = 12, style = "height:400px;", title = "Campus Inclusiveness - Disaggregated", solidHeader = TRUE,
                             plotOutput("campusTree"))
                  ),
                  column(width = 6,
                         box(width = 12, style = "height:400px;", title = "EMU Inclusiveness - Aggregate", solidHeader = TRUE,
                             plotOutput("emuBar")),
                         box(width = 12, style = "height:400px;", title = "EMU Inclusiveness - Disaggregated", solidHeader = TRUE,
                             plotOutput("emuTree"))
                  )
                ),
                fluidRow(
                  column(width = 4, uiOutput("typeSelect")),
                  column(width = 4, uiOutput("yearSelect")),
                  column(width = 4, uiOutput("cohortSelect"))
                )
        ),
        
        tabItem(tabName = "words",
                
                fluidRow(column(width = 12,
                                uiOutput("dynamicFilter"))
                         ),
                fluidRow(
                  column(width = 6,
                         box(width = NULL, style = "height:400px;", title = "Belong - Wordnet", solidHeader = FALSE),
                         box(width = NULL, style = "height:400px;", title = "Belong - Wordcloud", solidHeader = FALSE)),
                column(width = 6,
                       box(width = NULL, style = "height:400px;", title = "Don't Belong - Wordnet", solidHeader = FALSE),
                       box(width = NULL, style = "height:400px;", title = "Don't Belong - Wordcloud", solidHeader = FALSE))
                )                
        ),
        
        tabItem(tabName = "emotions",
                
                fluidRow(
                  column(width = 6,
                         box(width = NULL, title = "Plutchik's Wheel of Emotions", solidHeader = TRUE),
                         box(width = NULL, background = "black", "text about emo."))),
                column(width = 6,
                       box(width = NULL, uiOutput("dynamicFilter")),
                       box(width = NULL, background = "black",
                           "Bar graphs here."))
                
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

#########################################################
### Server                                            ###
#########################################################
server <- function(input, output, session) {
  
  
  # Dynamic UI for additional filters
  output$typeSelect <- renderUI({
    selectInput("typeSelect", "Select Type:", 
                choices = c("Undergraduate", "International", "Graduate"))
  })
  
  output$yearSelect <- renderUI({
    req(input$typeSelect)
    if (input$typeSelect == "Undergraduate") {
      selectInput("yearSelect", "Select Year:", 
                  choices = c("2018", "2019", "2020", "2022", "Overall"))
    } else if (input$typeSelect == "International") {
      selectInput("yearSelect", "Select Year:", 
                  choices = c("Undergrad 2020", "Overall"))
    } else if (input$typeSelect == "Graduate") {
      selectInput("yearSelect", "Select Year:",
                  choices = c("Overall", "2022"))
    }
  })
  
  output$cohortSelect <- renderUI({
    req(input$typeSelect)
    if (input$typeSelect == "Undergraduate") {
      selectInput("cohortSelect", "Select Cohort:", 
                  choices = c("1st Year", "2nd Year", "3rd Year", "4th Year", "All Years"))
    } else {
      selectInput("cohortSelect", "No cohort available.")
    }
  })
  
  output$dynamicFilter <- renderUI({
    req(input$typeSelect, input$yearSelect)
    
    if(input$typeSelect == "Undergraduate" && input$yearSelect %in% c("2018", "2019")) {
      selectInput("floorSelect", "Select Floor:", 
                  choices = c("Full Building", "Level 1", "Level 2"))
    }
  })
  
  output$placeSelect <- renderUI ({
    req(input$typeSelect)
    if (input$typeSelect == "Undergraduate") {
    selectInput("placeSelect", "Select Location:",
                choices = c("Allen", "Autzen Stadium", "Cemetery", "Chapman", "Erb Memorial Union (EMU)",
                            "Frohnmayer", "Hayward Field", "HEDCO", "Jaqua", "Knight Law", "Lawrence",
                            "Knight Library", "Lillis Business Complex", "Lokey Science Complex",
                            "Matthew Knight Arena", "McKenzie", "Oregon", "Straub", "Student Rec Complex",
                            "Tykeson", "University Health Services", "University Housing"))
    } else if (input$typeSelect == "International") {
      selectInput("placeSelect", "Select Location:", 
                  choices = c("Erb Memorial Union (EMU)", "Knight Library", "Lokey Science Complex",
                              "Student Rec Complex", "University Housing"))
    } else if (input$typeSelect == "Graduate") {
      selectInput("placeSelect", "Select Location:",
                  choices = c("Knight Library", "Student Rec Complex"))
    }
  })
  
  output$place2Select <- renderUI ({
    req(input$placeSelect)
   if (input$placeSelect == "Erb Memorial Union (EMU)") {
    selectInput("place2Select", "Select Location:",
                choices = c("Overall","Atrium East", "Courtyard", "Craft", "Duck Nest", "Falling Sky", 
                            "Fishbowl", "Fresh Market", "LGBTQIA3", "Mills Center", 
                            "Multicultural Center", "O Lounge", "Taylor Lounge",
                            "Women's Center"))
  } else if (input$placeSelect == "Lokey Science Complex") {
    selectInput("place2Select", "Select Location:",
                choices = c("Overall", "Columbia", "Klamath", "Lewis", "Science Commons", "Willamette"))
  } else if (input$placeSelect == "University Housing") {
    selectInput("place2Select", "Select Location:",
                choices = c("Overall", "Barnhart", "Bean", "Carson", "Earl", "Global Scholars",
                            "Hamilton", "Kalapuya Ilihi", "Living Learning", "Unthank", "Walton"))
  }
  }) 


## Table  
  # Render the correct table based on the input selection
  output$table <- renderReactable({
    req(input$typeSelect)  # Ensure input$typeSelect has a value
    
    table_to_display <- NULL
    
    if(input$typeSelect == "Undergraduate") {
      year <- input$yearSelect
      cohort <- input$cohortSelect
      
      if(is.null(year) || year == "Overall") {
        table_to_display <- reactable_fun(tables_rt$us_ug)
      } else {
        table_name <- paste0("us_ug_ay", year)
        if (year %in% c("2018", "2019") && !is.null(cohort) && cohort != "All Cohorts") {
          table_name <- paste0(table_name, "_c", gsub("/", "", cohort))
        }
        table_to_display <- reactable_fun(tables_rt[[table_name]])
      }
      
    } else if(input$typeSelect == "International") {
      if (input$intSelect == "Overall") {
        table_to_display <- reactable_fun(tables_rt$i)
      } else if (input$intSelect == "Undergrad and Grad 2022") {
        table_to_display <- reactable_fun(tables_rt$i_ay2122)
      } else if (input$intSelect == "Undergrad 2020") {
        table_to_display <- reactable_fun(tables_rt$i_ug_ay1920)
      }
    } else if(input$typeSelect == "Graduate" && input$yearSelect == "2022") {
      table_to_display <- reactable_fun(tables_rt$gr_ay2122)
    }
    
    # Render the table if it has been set
    if (!is.null(table_to_display)) {
      table_to_display
    } else {
      HTML("<p>No data available for the selected options.</p>")
    }
  })

## Treemap  
  # Render treemaps
  output$campusTree <- renderPlot({
    renderCampusTree(input)
  })

  output$emuTree <- renderPlot({
    renderEmuTree(input)
  })  

## Bars  
  # Render inclusiveness bars
  output$campusBar <- renderPlot({
    renderCampusBar(input)
  })
  
  output$emuBar <- renderPlot({
    renderEmuBar(input)
  })  
  
  
  # Render the correct images based on the input selection
  output$emuImage <- renderUI({
    base_path <- "maps/"
    image_src_belonging <- ""
    image_src_not_belonging <- ""
    
    if(input$typeSelect == "Undergraduate") {
      year <- input$yearSelect
      cohort <- input$cohortSelect
      floor <- input$floorSelect
      
      if (is.null(year) || year == "Overall") {
        image_src_belonging <- ""
        image_src_not_belonging <- ""
      } else if (year == "2022") {
        if (cohort == "All Cohorts") {
          image_src_belonging <- paste0(base_path, "b_map_emu_us_ug_ay2122.png")
          image_src_not_belonging <- paste0(base_path, "db_map_emu_us_ug_ay2122.png")
        } else if (cohort %in% c("1819", "1920", "2021", "2122")) {
          cohort <- gsub("/", "", cohort)  # Remove '/' from cohort name
          image_src_belonging <- paste0(base_path, "b_map_emu_us_ug_ay2122_c", cohort, ".png")
          image_src_not_belonging <- paste0(base_path, "db_map_emu_us_ug_ay2122_c", cohort, ".png")
        }
      } else if (year == "2019") {
        if (cohort == "All Cohorts") {
          image_src_belonging <- paste0(base_path, "b_map_emu_us_ug_ay1920.png")
          image_src_not_belonging <- paste0(base_path, "db_map_emu_us_ug_ay1920.png")
        } else if (cohort %in% c("1617", "1718", "1819", "1920")) {
          cohort <- gsub("/", "", cohort)
          image_src_belonging <- paste0(base_path, "b_map_emu_us_ug_ay1920_c", cohort, ".png")
          image_src_not_belonging <- paste0(base_path, "db_map_emu_us_ug_ay1920_c", cohort, ".png")
        }
      } else if (year == "2018") {
        if (floor == "Level 1") {
          if (cohort == "All Cohorts") {
            image_src_belonging <- paste0(base_path, "b_map_emu1_us_ug_ay1819.png")
            image_src_not_belonging <- paste0(base_path, "db_map_emu1_us_ug_ay1819.png")
          } else {
            cohort <- gsub("/", "", cohort)  # Clean cohort name if necessary
            image_src_belonging <- paste0(base_path, "b_map_emu1_us_ug_ay1819_c", cohort, ".png")
            image_src_not_belonging <- paste0(base_path, "db_map_emu1_us_ug_ay1819_c", cohort, ".png")
          }
        } else if (floor == "Level 2") {
          if (cohort == "All Cohorts") {
            image_src_belonging <- paste0(base_path, "b_map_emu2_us_ug_ay1819.png")
            image_src_not_belonging <- paste0(base_path, "db_map_emu2_us_ug_ay1819.png")
          } else {
            cohort <- gsub("/", "", cohort)  # Clean cohort name if necessary
            image_src_belonging <- paste0(base_path, "b_map_emu2_us_ug_ay1819_c", cohort, ".png")
            image_src_not_belonging <- paste0(base_path, "db_map_emu2_us_ug_ay1819_c", cohort, ".png")
          }
        }
      } else if (year == "1718") {
        if (floor == "Level 1") {
          image_src_belonging <- paste0(base_path, "b_map_emu1_us_ug_ay1718.png")
          image_src_not_belonging <- paste0(base_path, "db_map_emu1_us_ug_ay1718.png")
        } else if (floor == "Level 2") {
          image_src_belonging <- paste0(base_path, "b_map_emu2_us_ug_ay1718.png")
          image_src_not_belonging <- paste0(base_path, "db_map_emu2_us_ug_ay1718.png")
        }
      }
    } else if(input$typeSelect == "International") {
      if (input$intSelect == "Overall") {
        image_src_belonging <- ""
        image_src_not_belonging <- ""
      } else if (input$intSelect == "Undergrad and Grad 2022") {
        image_src_belonging <- paste0(base_path, "b_map_emu_b_i_ug_ay2122.png")
        image_src_not_belonging <- paste0(base_path, "db_map_emu_b_i_ug_ay2122.png")
      } else if (input$intSelect == "Undergrad 2020") {
        image_src_belonging <- paste0(base_path, "b_map_emu_b_i_ug_ay1920.png")
        image_src_not_belonging <- paste0(base_path, "db_map_emu_b_i_ug_ay1920.png")
      }
    } else if(input$typeSelect == "Graduate" && input$yearSelect == "2022") {
      image_src_belonging <- paste0(base_path, "b_map_emu_b_gr_ay2122.png")
      image_src_not_belonging <- paste0(base_path, "db_map_emu_b_gr_ay2122.png")
    }
    
    tagList(
      img(src = image_src_belonging, height = "500px"),
      img(src = image_src_not_belonging, height = "500px")
    )
  })
  
  
  
## Word images
  # Wordnet & wordcloud image code, adapted from Tony's Heat Maps for EMU
  output$mapsDisplayWordnet <- renderUI({
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
  
  
  
  
}

#########################################################
### Run App                                           ###
#########################################################
shinyApp(ui = ui, server = server)
