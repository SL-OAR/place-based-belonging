##################################
# Place Based Belonging App.     #
# by OAR Intern team             #
# ui.R file                      #
##################################
# renv::snapshot() # use to update packages
renv::restore() # if your project code isn't working. This probably implies that you have the wrong package versions installed and you need to restore from known good state in the lockfile.

packages <- c("shiny", "reactable", "htmltools", 
              "treemapify", "tidyverse", "rvest",
              "leaflet.extras", "shinydashboard", 
              "shinycssloaders", "here", "reticulate",
              "markdown", "fastmap", "bslib", 
              "shinyalert", "shinyBS", "farver", 
              "labeling", "crayon", "cli", "viridisLite",
              "remotes", "fastmap", "conflicted", 
              "rsconnect"
)

# Function to handle errors
handle_error <- function(step, err) {
  cat(paste0("ERROR during ", step, ": ", conditionMessage(err), "\n"))
  stop("Script execution halted due to an error.")
}

# Install missing packages with error handling
tryCatch({
  installed_packages <- packages %in% rownames(installed.packages())
  if (any(!installed_packages)) {
    install.packages(packages[!installed_packages])
  }
}, error = function(e) handle_error("package installation", e))

# Load packages with error handling
tryCatch({
  invisible(lapply(packages, function(pkg) {
    library(pkg, character.only = TRUE)
  }))
}, error = function(e) handle_error("package loading", e))

# Set package conflicts preference
tryCatch({
  conflicts_prefer(
    shinydashboard::box(),
    dplyr::filter(),
    rvest::guess_encoding(),
    dplyr::lag(),
    bslib::page(),
    markdown::rpubsUpload(),
    rsconnect::serverInfo()
  )
}, error = function(e) handle_error("conflict resolution", e))

# Set working directory
tryCatch({
  path <- here::here()
  setwd(path)
}, error = function(e) handle_error("setting working directory", e))

# Activate the Conda environment using reticulate
tryCatch({
  use_condaenv("oar_pbb", required = TRUE)
}, error = function(e) handle_error("Conda environment activation", e))

# If everything runs successfully
cat("✅ Environment successfully activated and libraries loaded\n")


# 
# library(shiny)
# library(reactable)
# library(htmltools)
# library(treemapify)
# library(tidyverse)
# library(rvest)
# library(leaflet.extras)
# library(shinydashboard)
# library(shinycssloaders)
# library(here)
# library(reticulate)
# library(markdown)
# library(bslib)
# library(fastmap)
# ## New Addition for Shiny features
# library(bslib)
# #library(shinyalert)
# library(shinyBS)


#library(conflicted)
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

# Code for shinyBS Popover
# bsPopover(id=" ", title = " ", content = " ", trigger = "hover", 
# placement = "right", options = list(container = "body"))
## Most of these are self explanatory: 
### id is the name of the object to use as a trigger
### title is the title of the popover box
### content is the text content of the popover box
### trigger is the trigger mechanism (hover, click, )
### placement determines where the popover appears (right, left, auto)
### options 
## The code goes in the dashboardBody in the desired section


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
                       menuItem("Summary", tabName = "about", icon = icon("users")),
                       menuItem("Where? Campus Belonging", tabName = "campus", icon = icon("table")),
                       menuItem("Where? EMU Belonging", tabName = "emu", icon = icon("random", lib = "glyphicon")),
                       menuItem("Where? Inclusiveness", tabName = "inclusiveness", icon = icon("stats", lib = "glyphicon")),
                       menuItem("Why There? Wordnets & Wordclouds", tabName = "words", icon = icon("dashboard")),
                       menuItem("Why There? Emotions", tabName = "emotions", icon = icon("dashboard")),
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
        tabItem(tabName = "about", includeMarkdown("www/pbb_about.md")),
        
        
        tabItem(tabName = "campus",
                
                fluidRow(
                  column(4, uiOutput("typeSelectCampus")),
                  column(4, uiOutput("yearSelectCampus")),
                  column(4, uiOutput("cohortSelectCampus"))
                ),
                
                fluidRow(
                  column(6, 
                         tags$h3("Belonging Map"),
                             uiOutput("belongingMapCampus"),
                         bsPopover(id = "belongingMapCampus", title = "Campus Belonging Map", 
                                   content = "Number equals the number of clicks. Color equals density of clicks.", 
                                   trigger = "hover", placement = "right", options = list(container = "body"))
                  )
                ),
                
                fluidRow(
                  column(6, 
                         tags$h3("Not Belonging Map"),
                             uiOutput("notBelongingMapCampus"),
                         bsPopover(id = "notBelongingMapCampus", title = "Campus Don't Belong Map", 
                                   content = "Number equals the number of clicks. Color equals density of clicks.", 
                                   trigger = "hover", placement = "right", options = list(container = "body"))
                  )
                ),
                
                fluidRow(
                  column(width = 12, uiOutput("CampusMapCaption"))
                ),
                
                fluidRow(
                  column(6, reactableOutput("tableCampus"))
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
                         tags$h3("Belonging Map"),
                         uiOutput("belongingMapEmu"),
                         bsPopover(id = "belongingMapEmu", title = "Emu Belonging Map", 
                                   content = "Number equals the number of clicks. Color equals density of clicks. Full information below.", 
                                   trigger = "hover", placement = "right", options = list(container = "body"))
                  )
                ),
                
                fluidRow(
                  column(width = 6,
                         tags$h3("Not Belonging Map"),
                         uiOutput("notBelongingMapEmu"),
                         bsPopover(id = "notBelongingMapEmu", title = "Emu Don't Belong Map", 
                                   content = "Number equals the number of clicks. Color equals density of clicks. Full information below.", 
                                   trigger = "hover", placement = "right", options = list(container = "body"))
                  )
                ),
                
                fluidRow(
                  column(width = 12, uiOutput("EmuMapCaption"))
                ),
                
            fluidRow(
                  column(width = 12,
                         reactableOutput("tableEmu"))
                 )
            ),
        
        
        tabItem(tabName = "inclusiveness",
                fluidRow(
                  column(12, 
                         selectInput("locationSelect", "Select Campus Location:", 
                                     choices = c("Full Campus", "EMU Student Union"))
                  )
                ),
                
                conditionalPanel(
                  condition = "input.locationSelect == 'Full Campus'",
                  fluidRow(
                    column(12, 
                           selectInput("visualizationType", "Select Visualization Type:", 
                                       choices = c("Disaggregated - Tree Maps", "Aggregated - Bar Plot"))
                    )
                  ),
                  
                  
                  conditionalPanel(
                    condition = "input.visualizationType == 'Aggregated - Bar Plot'",
                    fluidRow(
                      column(4, uiOutput("typeSelectInclusiveBar")),
                      column(4, uiOutput("yearSelectInclusiveBar")),
                      column(4, uiOutput("cohortSelectInclusiveBar"))
                    ),
                    
                    fluidRow(
                      column(width = 12,
                             box(width = 12, style = "height:400px;", title = "Inclusiveness", solidHeader = TRUE, 
                                 uiOutput("inclusiveBar"))
                      )
                    ),
                    fluidRow(
                      column(width = 12, uiOutput("AggBarCaption"))
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
                             box(width = 12, style = "height:400px;", title = "Campus Inclusiveness Tree Map", solidHeader = TRUE, 
                                 plotOutput("campusTree"))
                      )
                    ), 
                    fluidRow(
                      column(width = 12, uiOutput("DisaggTreeCaption"))
                    )
                   ) # Disaggregate Tree Maps Condition
                ), #End Full Campus
                
                conditionalPanel(
                  condition = "input.locationSelect == 'EMU Student Union'",
                  fluidRow(
                    column(4, uiOutput("typeSelectEmuTreeMap")),
                    column(4, uiOutput("yearSelectEmuTreeMap")),
                    column(4, uiOutput("cohortSelectEmuTreeMap"))
                  ),
                  
                  fluidRow(
                    column(width = 12,
                           box(width = 12, style = "height:400px;", title = "EMU Inclusiveness Tree Map", solidHeader = TRUE, 
                               plotOutput("emuTree")) # Fix Nothing_to_see.png 
                    )
                  ), 
                  fluidRow(
                    column(width = 12, uiOutput("EmuTreeCaption"))
                  )
                ) #EMU conditional panel
        ), #End of Inclusive tab
        
        
        tabItem(tabName = "words", 
                fluidRow(
                  column(width = 12, 
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
                  fluidRow(
                  column(width = 6,
                         imageOutput("wordCloudImage", width = "100%", height = "auto")),
                  
                    column(width = 12, uiOutput("CloudCaption"))
                  ),  
                  
                  fluidRow(
                    column(width = 6,
                         imageOutput("wordNetImage", width = "100%", height = "auto")),
                    column(width = 12, uiOutput("NetCaption"))
                  )
                )
        ), # End words tab
      
      
        tabItem(tabName = "emotions",
                fluidRow(
                  column(width = 4,
                          selectInput("typeSelectEmotion", "Select Type",
                                      choices = c("Undergraduate", "International", "Graduate"),
                                      selected = "Undergraduate" # default selection
                                      ),
                         uiOutput("buildingSelect"),
                         uiOutput("building2Select"),
                         radioButtons("belongStatus", "Select Belonging Status",
                                      choices = c("Belong" = "b", "Don't Belong" = "db"),
                                      selected = "b")
                  ),
                  column(width = 8,
                         div(style = "max-width: 800px; margin: 0 auto;",  # Limit width and center it
                         imageOutput("emotionImage", width = "100%", height = "auto")
                )
              ),
              column(width = 12, uiOutput("EmotionCaption"))
          )
        ), # End emotions tab
      
      
        tabItem(tabName = "whom", 
                includeMarkdown("www/whom.md"),
                fluidRow(
                  box(width = NULL, title = "Plutchik's Wheel of Emotions", solidHeader = TRUE),
                  imageOutput("code/www/wheel.png"),
                  box(width = NULL, background = "black", "text about emo.")
                  )
                ),
      
      
        tabItem(tabName = "method", includeMarkdown("www/pbb_method.md"))
      ) # end tabItems
    ) # end dashboardBody
  ) # end dashboardPage
))
