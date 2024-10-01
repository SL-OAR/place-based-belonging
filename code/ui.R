##################################
# Place Based Belonging App.     #
# by OAR Extern team             #
# ui.R file                      #
##################################


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
library(reticulate)
library(markdown)
library(bslib)
library(fastmap)


library(conflicted)
conflicts_prefer(
  shinydashboard::box(),
  dplyr::filter(),
  rvest::guess_encoding(),
  dplyr::lag(),
  bslib::page(),
  markdown::rpubsUpload(),
  rsconnect::serverInfo()
)


# Set working directory
path <- here::here()
setwd(path)
# packrat::on()

# Use reticulate to activate the conda environment
# use_condaenv("oar_pbb", required = TRUE)
# print("Environment successfully activated and libraries loaded.")


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
        tabItem(tabName = "words", 
                fluidRow(
                  column(width = 6, 
                         selectInput("typeSelectWords", "Select Type:", 
                                     choices = c("Undergraduate", "International", "Graduate"), 
                                     selected = "Undergraduate" # Default to "Undergrad"
                         ),
                         uiOutput("placeSelect"),  # place select input for both word clouds and word nets
                         uiOutput("place2Select"),  # second place select input for word clouds and word nets i.e. Buildings within complexes
                         # Can I add radio buttons to the inclusiveness page??
                         radioButtons("belongStatus", "Select Belonging Status:", 
                                      choices = c("Belong" = "b", "Don't Belong" = "db"), 
                                      selected = "b"  # Default to "Belong"
                         )
                  ),
                  column(width = 6,
                         imageOutput("wordCloudImage"),  
                         imageOutput("wordNetImage")  
                  )
                )
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
