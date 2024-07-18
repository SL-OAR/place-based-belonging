

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




# Anwesha's  UI
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
                    reactableOutput("table"))
                
        ),
        
        tabItem(tabName = "emu",
                
                fluidRow(
                  column(4, uiOutput("typeSelect"), selectInput("typeSelect", "Select Type:", choices = c("Undergraduate", "International", "Graduate"))),
                  column(4, uiOutput("yearSelect")),
                  column(4, uiOutput("cohortSelect")),
                  column(4, uiOutput("floorSelect"))),
                column(4, uiOutput("dynamicFilter")),
                fluidRow(box(imageOutput("emuImage"))),
                fluidRow(
                  reactableOutput("table"))
                
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



# ChatGPT's UI that did kind of work for the filter
# ui <- fluidPage(
#   titlePanel("Dynamic Filters"),
  # sidebarLayout(
  #   sidebarPanel(
  #     selectInput("typeSelect", "Select Type:",
  #                 choices = c("Undergraduate", "International", "Graduate")),
  #     uiOutput("dynamicFilter")
  #   ),
    # mainPanel(
    #   reactableOutput("reactTable"),
    #   uiOutput("emuImage")
#       )
#   )
# )


# Tony's original UI that doesn't work
# ui <- dashboardBody(
#   tabItem(tabName = "table",
#           fluidRow(
#             column(3, uiOutput("dynamicFilter")),
#             column(6, reactableOutput("table") %>% withSpinner(color = "navy")),
#             column(3, plotOutput("emuImage"))
#           )
#   )
# )


#####################################################

########################################

## Functions ##

########################################

#function for interactive reactables
reactable_fun<- function(dat) {
  options(
    reactable.theme = reactableTheme(
      color = "hsl(233, 9%, 87%)",
      backgroundColor = "hsl(233, 9%, 19%)",
      borderColor = "hsl(233, 9%, 22%)",
      stripedColor = "hsl(233, 12%, 22%)",
      highlightColor = "hsl(233, 12%, 24%)",
      inputStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
      selectStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
      pageButtonHoverStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
      pageButtonActiveStyle = list(backgroundColor = "hsl(233, 9%, 28%)")
    )
  )
  rt<- dat %>%
    reactable(
      .,
      groupBy = "agg_place",
      showPageSizeOptions = T,
      paginateSubRows = T,
      defaultSorted = c("agg_place", "full_place"),
      sortable = T,
      showSortable = T,
      striped = T,
      highlight = T,
      bordered = T,
      defaultColDef = colDef(
        vAlign = "center",
        headerVAlign = "bottom"
      ),
      columns = list(
        agg_place = colDef(
          name = "Aggregated Place",
          filterable = T,
          align = "left",
          minWidth = 240
        ),
        full_place = colDef(
          name = "Place",
          align = "left",
          minWidth = 215
        ),
        n_b = colDef(
          aggregate = "sum",
          align = "center",
          format = colFormat(separators = T, digits = 0),
          html = T,
          header = JS(
            'function(column) {
              return `<div style="font-style: italic">n</div>` + "Belong"
            }'
          )
        ),
        n_db = colDef(
          aggregate = "sum",
          align = "center",
          format = colFormat(separators = T, digits = 0),
          html = T,
          header = JS(
            'function(column) {
              return `<div style="font-style: italic">n</div>` + "Don\'t" +
              "<br>Belong"
            }'
          )
        ),
        perc_click_b = colDef(
          aggregate = "sum",
          align = "center",
          format = colFormat(percent = T, digits = 1),
          html = T,
          header = JS(
            'function(column) {
              return "Click" + "<br>Belong"
            }'
          )
        ),
        perc_click_db = colDef(
          aggregate = "sum",
          align = "center",
          format = colFormat(percent = T, digits = 1),
          html = T,
          header = JS(
            'function(column) {
              return "Click" + "<br>Don\'t" + "<br>Belong"
            }'
          )
        ),
        perc_stud_b = colDef(
          aggregate = "sum",
          align = "center",
          format = colFormat(percent = T, digits = 1),
          html = T,
          header = JS(
            'function(column) {
              return "Student" + "<br>Belong"
            }'
          )
        ),
        perc_stud_db = colDef(
          aggregate = "sum",
          align = "center",
          format = colFormat(percent = T, digits = 1),
          html = T,
          header = JS(
            'function(column) {
              return "Student" + "<br>Don\'t" + "<br>Belong"
            }'
          )
        ),
        incl = colDef(
          aggregate = "mean",
          name = "Inclusive",
          align = "center",
          format = colFormat(percent = T, digits = 1)
        )
      )
    )
  return(rt)
}


#######################

# Function for tree map

inclusive_tree_fun <- function(dat) {
  df <- dat
  cp <- as.vector(if_else(df$incl > 75, "#30313A", "#FCFFA4"))
  plot <- dat %>%
    ggplot(aes(area = tot, fill = incl, label = place)) +
    geom_treemap() +
    geom_treemap_text(place = "center", grow = TRUE, reflow = TRUE, color = cp) +
    scale_fill_viridis_c(name = "Inclusiveness", option = "inferno", limits = c(0, 100)) +
    theme(
      panel.background = element_rect(fill = "#30313A"),
      plot.background = element_rect(color = "#30313A", fill = "#30313A"),
      legend.background = element_rect(fill = "#30313A"),
      legend.title = element_text(color = "#FCFFA4"),
      legend.text = element_text(color = "#FCFFA4"),
      plot.margin = margin(0.5, 0.5, 0.5, 0.5, "cm")
    )
  return(plot)
}


########################################

## Server Logic ##

########################################

# Dynamic UI for additional filters



server <- function(input, output, session) {
  
  
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
  
  # Dynamic UI for additional filters
  # output$typeSelect <- renderUI({
  #   print("Rendering typeSelect")
  #   selectInput("typeSelect", "Select Type:", 
  #               choices = c("Undergraduate", "International", "Graduate"))
  # })
  # 
  # output$yearSelect <- renderUI({
  #   req(input$typeSelect)
  #   print(paste("Rendering yearSelect for type:", input$typeSelect))
  #   if (input$typeSelect == "Undergraduate") {
  #     selectInput("yearSelect", "Select Year:", 
  #                 choices = c("2018", "2019", "2020", "2022", "Overall"))
  #   } else if (input$typeSelect == "Graduate") {
  #     selectInput("yearSelect", "Select Year:", 
  #                 choices = c("2022", "Overall"))
  #   }
  # })
  # 
  # output$cohortSelect <- renderUI({
  #   req(input$typeSelect)
  #   print(paste("Rendering cohortSelect for type:", input$typeSelect))
  #   if (input$typeSelect == "Undergraduate") {
  #     selectInput("cohortSelect", "Select Cohort:", 
  #                 choices = c("15/16", "16/17", "17/18", "18/19", "19/20", "20/21", "21/22", "All Cohorts"))
  #   }
  # })
  
  # Dynamic UI for additional filters
  # observeEvent(input$typeSelect, {
  #   type_selected <- input$typeSelect
  #   if (type_selected == "Undergraduate") {
  #     updateSelectInput(session, "yearSelect", choices = c("2018", "2019", "2020", "2022", "Overall"))
  #     updateSelectInput(session, "cohortSelect", choices = c("15/16", "16/17", "17/18", "18/19", "19/20", "20/21", "21/22", "All Cohorts"))
  #     updateSelectInput(session, "floorSelect", choices = c("Full Building", "Level 1", "Level 2"))
  #   } else if (type_selected == "Graduate") {
  #     updateSelectInput(session, "yearSelect", choices = c("2022", "Overall"))
  #     updateSelectInput(session, "cohortSelect", choices = NULL)
  #     updateSelectInput(session, "floorSelect", choices = NULL)
  #   } else if (type_selected == "International") {
  #     updateSelectInput(session, "yearSelect", choices = NULL)
  #     updateSelectInput(session, "cohortSelect", choices = c("Overall", "Undergrad and Grad 2022", "Undergrad 2020"))
  #     updateSelectInput(session, "floorSelect", choices = NULL)
  #   }
  # })
  
  
  output$selectedType <- renderText({
    paste("You have selected:", input$typeSelect)
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

# 
# server <- function(input, output) {
#   
#   # Dynamic UI for additional filters
#   output$dynamicFilter <- renderUI({
#     req(input$typeSelect)  # Ensure input$typeSelect has a value
#     
#     if(input$typeSelect == "Undergraduate") {
#       filters <- tagList(
#         selectInput("yearSelect", "Select Year:", 
#                     choices = c("2018", "2019", "2020", "2022", "Overall")),
#         selectInput("cohortSelect", "Select Cohort:", 
#                     choices = c("15/16", "16/17", "17/18", "18/19", "19/20", "20/21", "21/22", "All Cohorts"))
#       )
#       
#       # floor selection for specific years
#       if (!is.null(input$yearSelect) && input$yearSelect %in% c("2018", "2019")) {
#         filters <- tagList(
#           filters,
#           selectInput("floorSelect", "Select Floor:", 
#                       choices = c("Full Building", "Level 1", "Level 2"))
#         )
#       }
#       
#       return(filters)
#     } else if(input$typeSelect == "International") {
#       # Filters for International
#       return(tagList(
#         selectInput("intSelect", "Select Category:", 
#                     choices = c("Overall", "Undergrad and Grad 2022", "Undergrad 2020"))
#       ))
#     } else if(input$typeSelect == "Graduate") {
#       # Filters for Graduate
#       return(tagList(
#         selectInput("yearSelect", "Select Year:", 
#                     choices = c("2022", "Overall"))
#       ))
#     }
#   })
#   
# }


# Belonging
# undergrad full year belonging maps emu: 1920, 2122
# undergrad cohort specific belonging maps emu: Year: 1920 level: Full building
# cohort: 1617, 1718, 1819, 1920
# undergrad cohort specific belonging maps emu: Year: 2122 level: Full building
# cohort: 1819, 1920, 2021, 2122
# undergrad belonging map emu: 1718
# level 1 & level 2
# undergrad belonging map emu: 1819
# level 1 & level 2
# cohort: 1516, 1617, 1718, 1819
# grad full year belonging map emu: 2122
# international full year belonging map emu: 2122
# international undergrad full year belonging map: 1920

# Don't belong
# undergrad full year don't belong maps emu: 1920, 2122
# undergrad cohort specific dont belong emu: Year: 1920
# cohort: 1617, 1718, 1819, 1920
# undergrad cohort specific dont belong emu: Year: 2122
# cohort: 1819, 1920, 2021, 2122
# undergrad cohort specific dont belong emu: Year: 1718
# level: level 1, level 2
# undergrad cohort specific dont belong emu: Year: 1819
# level: level 1, level 2
# cohort: 1516, 1617, 1718, 1819
# grad full year dont belong emu: 2122
# international dont belong emu: 2122
# international undergrad dont belong emu: 1920


# Run the application 
shinyApp(ui = ui, server = server)
