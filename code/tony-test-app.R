

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
        tabItem(tabName = "about",
                includeMarkdown("www/pbb-about.md")
        ),
        tabItem(tabName = "summary",
                includeMarkdown("www/summary.md")
        ),
        tabItem(tabName = "campus",
                fluidRow(
                  column(4, uiOutput("typeSelect")),
                  column(4, uiOutput("yearSelect")),
                  column(4, uiOutput("cohortSelect"))),
                fluidRow(
                  box(width = NULL, title = "Belong", solidHeader = TRUE),
                  box(width = NULL, title = "Don't Belong", solidHeader = TRUE)),
                fluidRow(
                  reactableOutput("table"))
        ),
        tabItem(tabName = "emu",
                    fluidRow(
                      column(width = 6,
                             box(width = 4, uiOutput("typeSelect")),
                             box(width = 4, uiOutput("yearSelect")),
                             box(width = 4, uiOutput("cohortSelect")))),
                  fluidRow(
                    column(width = 6,
                        box(width = NULL, title = "Belong/Don't Belong", solidHeader = TRUE),
                    uiOutput("mapsDisplay"),
                    box(width = NULL, title = "Reactable Table", solidHeader = TRUE), reactableOutput("table")),
                  )),
        
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
      )
    )
  )
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
