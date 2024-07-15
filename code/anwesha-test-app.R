#

library(shiny)
library(tidyverse)
library(rvest)
library(leaflet.extras)
library(reactable)
library(here)

path <- here::here()
setwd(path)

pbb_tables_for_tm <- readRDS(here::here("data/separated/pbb_tables_for_tm.rds"))

pbb_tables_for_tm_names <- names(pbb_tables_for_tm)

for (name in pbb_tables_for_tm_names) {
  assign(name, pbb_tables_for_tm[[name]])
}


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
                         box(width = NULL, title = "Campus Inclusiveness - Aggregate", solidHeader = TRUE)),
                         box(width = NULL, title = "Campus Inclusiveness - Disaggregated", solidHeader = TRUE,
                             plotOutput("campusTree"))),
                  column(width = 6,
                         box(width = NULL, title = "EMU Inclusiveness - Aggregate", solidHeader = TRUE),
                         box(width = NULL, title = "EMU Inclusiveness - Disaggregated", solidHeader = TRUE)),
                fluidRow(
                  column(4, uiOutput("typeSelect")),
                  column(4, uiOutput("yearSelect")),
                  column(4, uiOutput("cohortSelect")))
                
        ),
        
        tabItem(tabName = "words",
                
                fluidRow(uiOutput("dynamicFilter")),
                fluidRow(
                  column(width = 6,
                         box(width = NULL, title = "Campus Inclusiveness", solidHeader = FALSE),
                         box(width = NULL, title = "EMU Inclusiveness", solidHeader = FALSE))),
                column(width = 6,
                       box(width = NULL, title = "Campus Inclusiveness", solidHeader = FALSE),
                       box(width = NULL, title = "EMU Inclusiveness", solidHeader = FALSE))
                
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
    } else if (input$typeSelect == "Graduate") {
      selectInput("yearSelect", "Select Year:", 
                  choices = c("2022", "Overall"))
    }
  })
  
  output$cohortSelect <- renderUI({
    req(input$typeSelect)
    if (input$typeSelect == "Undergraduate") {
      selectInput("cohortSelect", "Select Cohort:", 
                  choices = c("15/16", "16/17", "17/18", "18/19", "19/20", "20/21", "21/22", "All Cohorts"))
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
  
  # Render treemaps
  output$campusTree <- renderPlot({
    # Undergrad
    if(input$typeSelect == "Undergraduate") {
      year <- input$yearSelect
      
      if(input$yearSelect == "Overall") {
        inclusive_tree_fun(cam_us_ug)
      } else if (input$yearSelect == "2022") {
        if(input$cohortSelect == "All Years") { 
          inclusive_tree_fun(cam_us_ug)
        } else if(input$cohortSelect == "4th Year") { 
          reactable_fun(us_ug_ay2122_c2122)
        } else if(input$cohortSelect == "3rd Year") { 
          reactable_fun(us_ug_ay2122_c2021)
        } else if(input$cohortSelect == "2nd Year") { 
          reactable_fun(us_ug_ay2122_c1920)
        } else if(input$cohortSelect == "1st Year") { 
          reactable_fun(us_ug_ay2122_c1819)
        }
      } else if (input$yearSelect == "2020") {
        if(input$cohortSelect == "All Years") {
          reactable_fun(us_us_ay1920)
        } else if(input$cohortSelect == "4th Year") { 
          reactable_fun(us_ug_ay1920_c1920)
        } else if(input$cohortSelect == "3rd Year") { 
          reactable_fun(us_ug_ay1920_c1819)
        } else if(input$cohortSelect == "2nd Year") { 
          reactable_fun(us_ug_ay1920_c1718)
        } else if(input$cohortSelect == "1st Year") { 
          reactable_fun(us_ug_ay1920_c1617)
        }
      } else if (input$yearSelect == "2019") {
        if(input$cohortSelect == "All Years") {
          reactable_fun(us_us_ay1819)
        } else if(input$cohortSelect == "4th Year") { 
          reactable_fun(us_ug_ay1819_c1819)
        } else if(input$cohortSelect == "3rd Year") { 
          reactable_fun(us_ug_ay1819_c1718)
        } else if(input$cohortSelect == "2nd Year") { 
          reactable_fun(us_ug_ay1819_c1617)
        } else if(input$cohortSelect == "1st Year") { 
          reactable_fun(us_ug_ay1819_c1516)
        }
      }
    }
    # International
    else if(input$typeSelect == "International") {
      if (input$yearSelect == "Overall") {
        reactable_fun(i)
      } else if (input$yearSelect == "Undergrad and Grad 2022") {
        reactable_fun(i_ay2122)
      } else if (input$yearSelect == "Undergrad 2020") {
        reactable_fun(i_ug_ay1920)
      }
    }
    # Graduate
    else if(input$typeSelect == "Graduate") {
      if (input$yearSelect == "2022") {
        reactable_fun(gr_ay2122)
      } else if (input$yearSelect == "Overall") {
        box("Idk")
      }
    } else {
      HTML("<p>No data available for the selected options.</p>")
    }
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
}

#########################################################
### Run App                                           ###
#########################################################
shinyApp(ui = ui, server = server)
