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

path <- here::here()
setwd(path)

col1 <- c(rep("Undergraduate", 17), rep("International", 2), rep("Graduate", 2))
col2 <- c(rep("2022",5), rep("2020",5), rep("2019",5), "2018", "Overall",
          "Undergrad and Grad 2022", "Undergrad 2020",
          "2022", "Overall")
col3 <- c(rep(c("All Years", "4th Year", "3rd Year", "2nd Year", "1st Year"),3), #2022-2019
          "All Years", #2018
          NA, #Overall UG
          rep(NA, 4)
          )

dynamic_filter <- data.frame(col1, col2, col3)

###########
# LOAD UI #
###########

ui <- fluidPage(

  # load custom stylesheet
  includeCSS("www/style.css"),

  # load google analytics script -- this is so you can track who is viewing the dashboard. cool! but will hold off
  #  tags$head(includeScript("www/google-analytics-bioNPS.js")),

  # remove shiny "red" warning messages on GUI
  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
  ),

  # load page layout
  dashboardPage(

    skin = "blue",

    dashboardHeader(title="University of Oregon Place Based Belonging", titleWidth = 200),

    dashboardSidebar(width = 300,
                     sidebarMenu(
                       HTML(paste0(
                         "<br>",
                         "<a href='https://studentlife.uoregon.edu/research' target='_blank'><img style = 'display: block; margin-left: auto; margin-right: auto;' src='uo_stacked_gray.svg' width = '186'></a>",
                         "<br>"
                       )),
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
        # where: campus belonging heat maps 
                fluidRow(
                  column(width = 6,
                         box(width = NULL, uiOutput("dynamicFilter")),
                         box(width = NULL, background = "black",
                             "Some text here.")),
                  column(width = 6,
                         box(width = NULL, title = "Belong", solidHeader = TRUE),
                         imageOutput("campusHeatMaps") %>% withSpinner(color = "green"),
                         box(width = NULL, title = "Don't Belong", solidHeader = TRUE),
                         imageOutput("ggplot2Group1") %>% withSpinner(color = "green")))

        ),

        tabItem(tabName = "emu",

                fluidRow(
                  column(4, uiOutput("typeSelect")),
                  column(4, uiOutput("yearSelect")),
                  column(4, uiOutput("cohortSelect"))),
                fluidRow(
                  reactableOutput("table") %>% withSpinner(color = "green"))

                # fluidRow(
                #   column(width = 6,
                #          box(width = NULL, uiOutput("dynamicFilter")),
                #          box(width = NULL, background = "black",
                #              "Some text here.")),
                #   column(width = 6,
                #          box(width = NULL, title = "Belong", solidHeader = TRUE),
                #          box(width = NULL, title = "Don't Belong", solidHeader = TRUE)))
        ),

        tabItem(tabName = "inclusiveness",
          # where: campus inclusiveness tree maps AND tables collectively
                fluidRow(
                  column(width = 6,
                         box(width = NULL, title = "Campus Inclusiveness", solidHeader = TRUE),
                         box(width = NULL, title = "EMU Inclusiveness", solidHeader = TRUE))),
                  column(width = 6,
                       box(width = NULL, uiOutput("dynamicFilter")),
                       box(width = NULL, background = "black",
                           "Some text here."))

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

)


###############
# BRIAN'S CODE #
###############
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
#function for inclusiveness treemaps
inclusive_tree_fun<- function(dat) {
  df<- dat
  cp<- as.vector(
    if_else(df$incl > 75, "#30313A", "#FCFFA4")
  )
  plot<- dat %>%
    ggplot(
      .,
      aes(
        area = tot,
        fill = incl,
        label = place
      )
    ) +
    geom_treemap() +
    geom_treemap_text(
      place = "center",
      grow = T,
      reflow = T,
      color = cp
    ) +
    scale_fill_viridis_c(
      name = "Inclusiveness",
      option = "inferno",
      limits = c(0, 100)
    ) +
    theme(
      panel.background = element_rect(fill = "#30313A"),
      plot.background = element_rect(color = "#30313A", fill = "#30313A"),
      legend.background = element_rect(fill = "#30313A"),
      legend.title = element_text(color = "#FCFFA4"),
      legend.text = element_text(color = "#FCFFA4"),
      plot.margin = margin(0.5, 0.5, 0.5, 0.5, "cm")
      #top, right, bottom, left, units
    )
  return(plot)
}
#function for inclusiveness bar plots
inclusive_bar_fun<- function(dat, b_cp, e_cp) {
  plot<- dat %>%
    ggplot(
      .,
      aes(
        x = agg_place,
        y = incl,
        fill = agg_place
      )
    ) +
    geom_bar(
      stat = "identity",
      position = "dodge"
    ) +
    xlab("") +
    ylab("Inclusiveness") +
    scale_y_continuous(
      breaks = c(0, 25, 50, 75, 100),
      limits = c(0, 125)
    ) +
    scale_fill_viridis_d(
      option = "inferno",
      begin = b_cp,
      end = e_cp
    ) +
    coord_flip() +
    geom_text(
      aes(label = sprintf("%0.1f", incl)),
      hjust = -0.5,
      size = 5,
      color = "#FCFFA4"
    ) +
    guides(fill = "none") +
    theme(
      panel.background = element_rect(fill = "#30313A"),
      plot.background = element_rect(color = "#30313A", fill = "#30313A"),
      panel.grid = element_blank(),
      axis.title = element_text(size = 13, color = "#FCFFA4", hjust = 0.375),
      axis.text = element_text(size = 12, color = "#FCFFA4"),
      axis.ticks.y = element_blank()
    )
  return(plot)
}

###############
# DATA TABLES #
###############
# bar plots
tables_bp <- readRDS("/Users/daragon/Library/CloudStorage/OneDrive-UniversityOfOregon/OAR EXTERN/SWaSI/place-based belonging/pbb_tables_for_bp.rds")
# tree maps
tables_tm <- readRDS("/Users/daragon/Library/CloudStorage/OneDrive-UniversityOfOregon/OAR EXTERN/SWaSI/place-based belonging/pbb_tables_for_tm.rds")
# reactable tables
tables_rt <- readRDS("/Users/daragon/Library/CloudStorage/OneDrive-UniversityOfOregon/OAR EXTERN/SWaSI/place-based belonging/pbb_tables_for_rt.rds")


################
# SERVER LOGIC #
################
server <- function(input, output) {
  # Dynamic UI for additional filters
  output$dynamicFilter <- renderUI({
    if(input$typeSelect == "US Undergraduate") { # added US for clarity
      selectInput("yearSelect", "Select Year:",
                  choices = c("2018", "2019", "2020", "2022", "Overall"))
    } else if(input$typeSelect == "International") {
      selectInput("intSelect", "Select Category:",
                  choices = c("Overall", "Undergrad and Grad 2022", "Undergrad 2020"))
     }  else {
      return()
    }})
  ###########################
  ## CAMPUS SUMMARY TABLES ##
  ###########################
  output$table <- renderReactable({
    if(input$typeSelect == "Undergraduate" && input$yearSelect == "Overall") {
      reactable_fun(us_ug)
    } else if(input$typeSelect == "Undergraduate" && input$yearSelect == "2022") {
      reactable_fun(us_ug_ay2122)
    } else if(input$typeSelect == "Undergraduate" && input$yearSelect == "2020") {
      reactable_fun(us_ug_ay1920)
    } else if(input$typeSelect == "Undergraduate" && input$yearSelect == "2019") {
      reactable_fun(us_ug_ay1819)
    } else if(input$typeSelect == "Undergraduate" && input$yearSelect == "2018") {
      reactable_fun(us_ug_ay1718)
    } else if(input$typeSelect == "International" && input$intSelect == "Overall") {
      reactable_fun(i)
    } else if(input$typeSelect == "International" && input$intSelect == "Undergrad and Grad 2022") {
      reactable_fun(i_ay2122)
    } else if(input$typeSelect == "International" && input$intSelect == "Undergrad 2020") {
      reactable_fun(i_ug_ay1920)
    } else if(input$typeSelect == "Graduate") {
      reactable_fun(gr_ay2122)
    }
  })
  ######################
  ## CAMPUS HEAT MAPS ##
  ######################
  output$campusHeatMaps <- renderImage({
    if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2022" && input$yearSelect == "AllYears") {
      tags$div(
        tags$img(src = "maps/map_cam_b_us_ug_ay2122.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_us_ug_ay2122.png", style = "display:inline-block;")
      )
    } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2022" && input$yearSelect == "4th-Year") {
      tags$div(
        tags$img(src = "maps/map_cam_b_us_ug_ay2122_c2122.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_us_ug_ay2122_c2122.png", style = "display:inline-block;")
      )
    } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2022" && input$yearSelect == "3th-Year") {
      tags$div(
        tags$img(src = "maps/map_cam_
                 b_us_ug_ay2122_c2021.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_us_ug_ay2122_c2021.png", style = "display:inline-block;")
      )
    } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2022" && input$yearSelect == "2th-Year") {
      tags$div(
        tags$img(src = "maps/map_cam_b_us_ug_ay2122_c1920.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_us_ug_ay2122_c1920.png", style = "display:inline-block;")
      )
    } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2022" && input$yearSelect == "1th-Year") {
      tags$div(
        tags$img(src = "maps/map_cam_b_us_ug_ay2122_c1819.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_us_ug_ay2122_c1819.png", style = "display:inline-block;")
      )
      #### spring 2020, 2021 was skipped
    } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2020" && input$yearSelect == "1st-through-5th-Year") {
      tags$div(
        tags$img(src = "maps/map_cam_b_us_ug_ay1920.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_us_ug_ay1920.png", style = "display:inline-block;")
      )
    } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2020" && input$yearSelect == "4th-Year") {
      tags$div(
        tags$img(src = "maps/map_cam_b_us_ug_ay1920_c1920.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_us_ug_ay1920_c1920.png", style = "display:inline-block;")
      )
    } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2020" && input$yearSelect == "3th-Year") {
      tags$div(
        tags$img(src = "maps/map_cam_b_us_ug_ay1920_c1819.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_us_ug_ay1920_c1819.png", style = "display:inline-block;")
      )
    } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2020" && input$yearSelect == "2th-Year") {
      tags$div(
        tags$img(src = "maps/map_cam_b_us_ug_ay1920_c1718.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_us_ug_ay1920_c1718.png", style = "display:inline-block;")
      )
    } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2020" && input$yearSelect == "1th-Year") {
      tags$div(
        tags$img(src = "maps/map_cam_b_us_ug_ay1920_c1617.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_us_ug_ay1920_c1617.png", style = "display:inline-block;")
      )
      #### spring 2019
    } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2019" && input$yearSelect == "1st-through-4th-Year") {
      tags$div(
        tags$img(src = "maps/map_cam_b_us_ug_ay2122_c2122.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_us_ug_ay2122_c2122.png", style = "display:inline-block;")
      )
    } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2019" && input$yearSelect == "4th-Year") {
      tags$div(
        tags$img(src = "maps/map_cam_b_us_ug_ay1819_c2122.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_us_ug_ay1819_c2122.png", style = "display:inline-block;")
      )
    } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2019" && input$yearSelect == "3th-Year") {
      tags$div(
        tags$img(src = "maps/map_cam_b_us_ug_ay1819_c2122.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_us_ug_ay1819_c2122.png", style = "display:inline-block;")
      )
    } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2019" && input$yearSelect == "2th-Year") {
      tags$div(
        tags$img(src = "maps/map_cam_b_us_ug_ay1819_c2122.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_us_ug_ay1819_c2122.png", style = "display:inline-block;")
      )
    } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2019" && input$yearSelect == "1th-Year") {
      tags$div(
        tags$img(src = "maps/map_cam_b_us_ug_ay1819_c2122.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_us_ug_ay1819_c2122.png", style = "display:inline-block;")
      )
      #### spring 2018
    } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2018" && input$yearSelect == "1st-through-3th-Year") {
      tags$div(
        tags$img(src = "maps/map_cam_b_us_ug_ay1718.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_us_ug_ay1718.png", style = "display:inline-block;")
      )
      ### international
    } else if(input$typeSelect == "International" && input$intSelect == "Undergrad and Grad Spring 2022") {
      tags$div(
        tags$img(src = "maps/map_cam_b_i_ay2122.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_i_ay2122.png", style = "display:inline-block;")
      )
    } else if(input$typeSelect == "International" && input$intSelect == "Undergrad Spring 2020") {
      tags$div(
        tags$img(src = "maps/map_cam_db_i_ug_ay1920.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_i_ug_ay1920.png", style = "display:inline-block;")
      )
      ### graduate student
    } else if(input$typeSelect == "Graduate") { # no other option needed here
      tags$div(
        tags$img(src = "maps/map_cam_b_gr_ay2122.png", style = "display:inline-block;margin-right:10px;"),
        tags$img(src = "maps/map_cam_db_gr_ay2122.png", style = "display:inline-block;")
      )
    }
  })
#######################
## CAMPUS TREE PLOTS ##
#######################
#### may be computationally expensive
# output$campusTreeMaps <- renderPlotly({
#   # Ensure yearSelect and classSelect are not null
#   if (is.null(input$yearSelect) || is.null(input$classSelect) || input$yearSelect == "Overall") {
#     return(NULL)
#   }
#   # Mapping the years to their codes
#   yearMapping <- list(
#     "Spring 2018" = "ay1718",
#     "Spring 2019" = "ay1819",
#     "Spring 2020" = "ay1920",
#     "Spring 2021" = "ay2021",
#     "Spring 2022" = "ay2122"
#   )
#   # Mapping the class to their codes
#   classMapping <- list(
#     "1st-Year" = "c1",
#     "2nd-Year" = "c2",
#     "3rd-Year" = "c3",
#     "4th-Year" = "c4"
#   )
#   yearCode <- yearMapping[[input$yearSelect]]
#   classCode <- classMapping[[input$classSelect]]
#   # Generate the data for the tree map
#   dat <- your_data_preparation_function(yearCode, classCode)  # Assuming you have a function for this
#   # Call the inclusive_tree_fun function to generate the tree map
#   tree_map <- inclusive_tree_fun(dat)
#   # Return the plotly object
#   tree_map
#   
# })
#### code if the computational cost of creating the maps is too much and we need to use already developed images
    output$campusImage <- renderImage({
        # Ensure yearSelect and classSelect are not null
        if (is.null(input$yearSelect) || is.null(input$classSelect) || input$yearSelect == "Overall") {
            return("Select year breakdown :)")
        }

        # Mapping the years to their codes
        yearMapping <- list(
            "Spring 2018" = "ay1718",
            "Spring 2019" = "ay1819",
            "Spring 2020" = "ay1920",
            "Spring 2021" = "ay2021",
            "Spring 2022" = "ay2122"
        )

        # Mapping the class to their codes
        classMapping <- list(
            "AllYears" = "c_all", # would require that those without class add "c_all" in png image name
            "1st-Year" = "c2122",
            "2nd-Year" = "c2021",
            "3rd-Year" = "c1920",
            "4th-Year" = "c1819"
        )

        yearCode <- yearMapping[[input$yearSelect]]
        classCode <- classMapping[[input$classSelect]]

        belongImage <- ""
        dontBelongImage <- ""

        # Constructing the image paths based on the typeSelect
        if (input$typeSelect == "US Undergraduate") {
            belongImage <- paste0("maps/map_cam_b_us_ug_", yearCode, "_", classCode, ".png")
            dontBelongImage <- paste0("maps/map_cam_db_us_ug_", yearCode, "_", classCode, ".png")
        } else if (input$typeSelect == "International") {
            belongImage <- paste0("maps/map_cam_b_i_", yearCode, "_", classCode, ".png")
            dontBelongImage <- paste0("maps/map_cam_db_i_", yearCode, "_", classCode, ".png")
        } else if (input$typeSelect == "Graduate") {
            belongImage <- paste0("maps/map_cam_b_gr_", yearCode, "_", classCode, ".png")
            dontBelongImage <- paste0("maps/map_cam_db_gr_", yearCode, "_", classCode, ".png")
        }

        # Rendering both images
        tags$div(
            tags$img(src = belongImage, style = "display:inline-block;margin-right:10px;"),
            tags$img(src = dontBelongImage, style = "display:inline-block;")
        )
    })

######################
## CAMPUS BAR PLOTS ##
######################
output$campusBarPlots <- renderReactable({
  if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Overall") {
    reactable_fun(cam_us_ug)
  } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2022" && input$yearSelect == "AllYears") {
    inclusive_bar_fun(cam_us_ug_ay2122)
  } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2022" && input$yearSelect == "4th-Year") {
    inclusive_bar_fun(cam_us_ug_ay2122_c2122)
  } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2022" && input$yearSelect == "3th-Year") {
    inclusive_bar_fun(cam_us_ug_ay2122_c2021)
  } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2022" && input$yearSelect == "2th-Year") {
    inclusive_bar_fun(cam_us_ug_ay2122_c1920)
  } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2022" && input$yearSelect == "1th-Year") {
    inclusive_bar_fun(cam_us_ug_ay2122_c1819)
    #### spring 2020, 2021 was skipped
  } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2020" && input$yearSelect == "1st-through-5th-Year") {
    inclusive_bar_fun(cam_us_ug_ay1920)
  } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2022" && input$yearSelect == "4th-Year") {
    inclusive_bar_fun(us_ug_ay1920_1920)
  } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2022" && input$yearSelect == "3th-Year") {
    inclusive_bar_fun(us_ug_ay1920_c1819)
  } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2022" && input$yearSelect == "2th-Year") {
    inclusive_bar_fun(us_ug_ay1920_c1718)
  } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2022" && input$yearSelect == "1th-Year") {
    inclusive_bar_fun(us_ug_ay2122_c1617)
    #### spring 2019
  } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2019" && input$yearSelect == "1st-through-4th-Year") {
    inclusive_bar_fun(cam_us_ug_ay1819)
  } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2019" && input$yearSelect == "4th-Year") {
    inclusive_bar_fun(us_ug_ay1819_1819)
  } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2019" && input$yearSelect == "3th-Year") {
    inclusive_bar_fun(us_ug_ay1819_c1718)
  } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2019" && input$yearSelect == "2th-Year") {
    inclusive_bar_fun(us_ug_ay1819_c1617)
  } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2019" && input$yearSelect == "1th-Year") {
    inclusive_bar_fun(us_ug_ay1819_c1516)
    #### spring 2018
  } else if(input$typeSelect == "US Undergraduate" && input$yearSelect == "Spring2018" && input$yearSelect == "1st-through-3th-Year") {
    inclusive_bar_fun(cam_us_ug_ay1718)
  } else if(input$typeSelect == "International" && input$intSelect == "Overall") {
    inclusive_bar_fun(i) # where is this one??
  } else if(input$typeSelect == "International" && input$intSelect == "Undergrad and Grad Spring 2022") {
    inclusive_bar_fun(cam_i_ay2122)
  } else if(input$typeSelect == "International" && input$intSelect == "Undergrad Spring 2020") {
    inclusive_bar_fun(cam_i_ug_ay1920)
  } else if(input$typeSelect == "Graduate") { # no other option needed here
    inclusive_bar_fun(cam_gr_ay2122)
  }
})
}
# Run the application 
shinyApp(ui = ui, server = server)
