##################################
# Place Based Belonging App.     #
# by OAR Intern team             #
# ui.R file                      #
##################################
#renv::restore() # if your project code isn't working. This probably implies that you have the wrong package versions installed and you need to restore from known good state in the lockfile.

# For some reason I need to run this separately to get the app to run when I get that remote sha error
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
# conflicts_prefer(
#   shinydashboard::box(),
#   dplyr::filter(),
#   rvest::guess_encoding(),
#   dplyr::lag(),
#   bslib::page(),
#   markdown::rpubsUpload(),
#   rsconnect::serverInfo()
# )
# 
# 
# # Set working directory
# path <- here::here()
# setwd(path)

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
                       menuItem("Introduction", tabName = "intro", icon = icon("compass")),
                       menuItem("Further Project Details", tabName = "about", icon = icon("info-circle")),
                       menuItem("Summary of Findings", tabName = "findings", icon = icon("lightbulb")),
                       menuItem("Where? Campus Belonging", tabName = "campus", icon = icon("table")),
                       menuItem("Where? EMU Belonging", tabName = "emu", icon = icon("random", lib = "glyphicon")),
                       menuItem("Where? Inclusiveness", tabName = "inclusiveness", icon = icon("stats", lib = "glyphicon")),
                       menuItem("Why There? Wordnets & Wordclouds", tabName = "words", icon = icon("comment")),
                       menuItem("Why There? Emotions", tabName = "emotions", icon = icon("face-smile")),
                       menuItem("For Whom?", tabName = "whom", icon = icon("person")), # I am unsure if we need this
                       menuItem("Supplemental Method", tabName = "method", icon = icon("book")),
                       menuItem("In Rememberance of Brian", tabName = "brian", icon = icon("dove")),
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
      tags$head(
        tags$style(HTML("
      .map-container {
      width: 100%;
      max-width: 1400px; /* Adjust max width as needed */
      height: auto; /* Center it */
      margin-bottom: 20px; /* Adds space below */
        }

      .responsive-caption {
      width: 100%;
      max-width: 1400px;
      height: auto;
      display: block;
      padding-top: 30px; /* Adds space above the caption */
      }
                        
      .responsive-plot {
      width: 100%; 
      max-width: 1000px;
      height: auto;
      display: block;
      margin-bottom: 20px;
      }                  
                        ")),
        
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
        ),
  
  # # JavaScript Fix for Resizing
  tags$script(HTML("
      $(document).on('shiny:value', function(event) {
      setTimeout(function() {
        $(window).trigger('resize');
      }, 500);
    });
  "
                        )),
      tabItems(
        tabItem(tabName = "intro", includeMarkdown("www/intro.md")),
        
        tabItem(tabName = "about", includeMarkdown("www/pbb_about.md")),
        
        tabItem(tabName = "findings", includeMarkdown("www/findings.md")),
        
        tabItem(tabName = "campus",
                includeMarkdown("www/campus_summary.md"), # change to correct file
            tabBox(
              id = "campus_tabs", width = 12, 
              tabPanel("Maps",
                fluidRow(
                  column(4, uiOutput("typeSelectCampus")),
                  column(4, uiOutput("yearSelectCampus")),
                  column(4, uiOutput("cohortSelectCampus"))
                ),
                
                fluidRow(
                  column(12, 
                         tags$h3("Belonging Map"),
                         div(class = "map-container",
                             uiOutput("belongingMapCampus", fill = "container")),
                         bsPopover(id = "belongingMapCampus", title = "Campus Belonging Map", 
                                   content = "Number equals the number of clicks. Color equals density of clicks.", 
                                   trigger = "hover", placement = "bottom", options = list(container = "body"))
                  )
                ),
                
                fluidRow(
                  column(12, 
                         tags$h3("Not Belonging Map"),
                         div(class = "map-container",
                             uiOutput("notBelongingMapCampus", fill = "container")),
                         bsPopover(id = "notBelongingMapCampus", title = "Campus Don't Belong Map", 
                                   content = "Number equals the number of clicks. Color equals density of clicks.", 
                                   trigger = "hover", placement = "bottom", options = list(container = "body"))
                  )
                ),
                
                fluidRow(
                  column(width = 12, 
                         div(class = "responsive-caption", includeHTML("www/campus_map_caption.html")) 
                )
              )
              ), # End Campus Maps
        
      tabPanel("Tables",
               fluidRow(
                 column(4, uiOutput("typeSelectCampusTable")),
                 column(4, uiOutput("yearSelectCampusTable")),
                 column(4, uiOutput("cohortSelectCampusTable"))
               ),
                fluidRow(
                  column(12, reactableOutput("tableCampus"))
                  ),
                fluidRow(
                  column(width = 12, 
                         div(class = "responsive-caption", includeHTML("www/campus_table_caption.html"))
                )
              )
          ) # End Campus Tables
        ) # End Campus Box
      ), # End Campus tab
        
        
        tabItem(tabName = "emu",
                includeMarkdown("www/emu_summary.md"), 
                fluidRow(
                  column(4, uiOutput("typeSelectEmu")),
                  column(4, uiOutput("yearSelectEmu")),
                  column(4, uiOutput("cohortSelectEmu"))
                ),
                
                fluidRow(
                  column(width = 10,
                         tags$h3("Belonging Map"),
                         div(class = "map-container",
                         uiOutput("belongingMapEmu", fill = "container")),
                         bsPopover(id = "belongingMapEmu", title = "Emu Belonging Map", 
                                   content = "Number equals the number of clicks. Color equals density of clicks.", 
                                   trigger = "hover", placement = "bottom", options = list(container = "body"))
                  )
                ),
                
                fluidRow(
                  column(width = 10,
                         tags$h3("Not Belonging Map"),
                         div(class = "map-container",
                         uiOutput("notBelongingMapEmu", fill = "container")),
                         bsPopover(id = "notBelongingMapEmu", title = "Emu Don't Belong Map", 
                                   content = "Number equals the number of clicks. Color equals density of clicks.", 
                                   trigger = "hover", placement = "bottom", options = list(container = "body"))
                  )
                ),
                
                fluidRow(
                  column(width = 12, 
                         div(class = "responsive-caption", includeHTML("www/emu_map_caption.html"))
                  )
                )
                
            # fluidRow(
            #       column(width = 12,
            #              reactableOutput("tableEmu"))
            #      )
            ), # End EMU Maps
        
        
        tabItem(tabName = "inclusiveness",
                includeMarkdown("www/test.md"), # change to correct file
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
                      column(width = 6,
                          div(class = "responsive-plot", 
                             h3("Inclusiveness"), 
                                 uiOutput("inclusiveBar")),
                             bsPopover(id = "inclusiveBar", title = "Aggregated Inclusivity", 
                                       content = "Aggregated Percent Inclusion by Place", 
                                       trigger = "hover", placement = "right", options = list(container = "body"))
                      )
                    ),
                    fluidRow(
                      column(width = 12, 
                             div(class = "responsive-caption", includeHTML("www/aggbar_caption.html"))
                      )
                    )
                  ), # End of Aggregated - Bar Plot Conditional
                  
                  conditionalPanel(
                    condition = "input.visualizationType == 'Disaggregated - Tree Maps'",
                    fluidRow(
                      column(4, uiOutput("typeSelectCampusTreeMap")),
                      column(4, uiOutput("yearSelectCampusTreeMap")),
                      column(4, uiOutput("cohortSelectCampusTreeMap"))
                    ),
                    
                    fluidRow(
                      column(width = 12,
                          div(class = "responsive-map",
                             h3("Campus Inclusiveness Tree Map"), 
                                 plotOutput("campusTree")
                          )
                      )
                    ), 
                    
                    fluidRow(
                      column(width = 12, 
                             div(class = "responsive-caption", includeHTML("www/disaggtree_caption.html"))
                      )
                    ) 
                  ) # Disaggregated Tree conditional panel
                ), # End of Full Campus Condition Panel
                
                conditionalPanel(
                  condition = "input.locationSelect == 'EMU Student Union'",
                  fluidRow(
                    column(4, uiOutput("typeSelectEmuTreeMap")),
                    column(4, uiOutput("yearSelectEmuTreeMap")),
                    column(4, uiOutput("cohortSelectEmuTreeMap"))
                  ),
                  
                  fluidRow(
                    column(width = 12,
                        div(class = "responsive-map",
                           h3("EMU Inclusiveness Tree Map"), 
                               plotOutput("emuTree") # Fix Nothing_to_see.png 
                           )
                    )
                  ), 
                  fluidRow(
                    column(width = 12, 
                           div(class = "responsive-caption", includeHTML("www/emutree_caption.html"))
                    )
                  )
                ) #EMU conditional panel
        ), #End of Inclusive tab
        
        
        tabItem(tabName = "words", 
                includeMarkdown("www/words_summary.md"), # change to correct file
              tabBox(
                  id = "words", width = 12, 
                tabPanel("Word Clouds", 
                fluidRow(
                  column(width = 12, 
                         selectInput("typeSelectWordsCloud", "Select Type:", 
                                     choices = c("Undergraduate", "International", "Graduate"), 
                                     selected = "Undergraduate" # Default to "Undergrad"
                         ),
                         uiOutput("placeSelectCloud"),  # place select input for both word clouds and word nets
                         uiOutput("place2SelectCloud"),  # second place select input for word clouds and word nets i.e. Buildings within complexes
                         # Should I add radio buttons to the inclusiveness page?
                         radioButtons("belongStatus", "Select Belonging Status:", 
                                      choices = c("Belong" = "b", "Don't Belong" = "db"), 
                                      selected = "b"  # Default to "Belong" # I am not sure this is working
                         )
                  )
                  ),
                  fluidRow(
                  column(width = 6,
                      div(class = "responsive-plot", 
                         imageOutput("wordCloudImage", width = "100%", height = "auto")),
                     column(width = 12, 
                            div(class = "responsive-caption", includeHTML("www/cloud_caption.html"))
                        )
                      )
                   )
                ),  # End word clouds panel
                
                tabPanel("Word Nets",
                    fluidRow(
                           column(width = 12, 
                                  selectInput("typeSelectWordsNet", "Select Type:", 
                                              choices = c("Undergraduate", "International", "Graduate"), 
                                              selected = "Undergraduate" # Default to "Undergrad"
                                  ),
                                  uiOutput("placeSelectNet"),  # place select input for both word clouds and word nets
                                  uiOutput("place2SelectNet"),  # second place select input for word clouds and word nets i.e. Buildings within complexes
                                  # Should I add radio buttons to the inclusiveness page?
                                  radioButtons("belongStatus", "Select Belonging Status:", 
                                               choices = c("Belong" = "b", "Don't Belong" = "db"), 
                                               selected = "b"  # Default to "Belong" # I am not sure this is working
                                  )
                           )
                         ),
                  fluidRow(
                    column(width = 6,
                        div(class = "responsive-plot", 
                         imageOutput("wordNetImage", width = "100%", height = "auto")),
                    column(width = 12, 
                           div(class = "responsive-caption", includeHTML("www/net_caption.html"))
                      )
                    )
                  )
                ) # End word nets Panel
              ) # End tab box
        ), # End words tab
      
      
        tabItem(tabName = "emotions",
                includeMarkdown("www/emotion_summary.md"), # change to correct file
                fluidRow(
                  column(width = 6,
                          selectInput("typeSelectEmotion", "Select Type",
                                      choices = c("Undergraduate", "International", "Graduate"),
                                      selected = "Undergraduate" # default selection
                                      ),
                         uiOutput("buildingSelect"),
                         uiOutput("building2Select"),
                         radioButtons("belongStatus", "Select Belonging Status",
                                      choices = c("Belong" = "b", "Don't Belong" = "db"),
                                      selected = "b")
                    )
                  ),
                fluidPage(
                  column(width = 8,
                         div(class = "responsive-plot",  # Limit width and center it
                         imageOutput("emotionImage", width = "100%", height = "auto")
                )
              )
            ),
              column(width = 12, 
                     div(class = "responsive-caption", includeHTML("www/emotion_caption.html"))
              )
        ), # End emotions tab
      
      tabItem(tabName = "whom",
              includeMarkdown("www/whom.md"),
              fluidRow(
                h3("Plutchik's Wheel of Emotions"),
                tags$img(src = "wheel.png", width = "100%"),
                box(width = NULL, background = "black", "text about emo.")
              )
      ),
      
    tabItem(tabName = "method",
            includeMarkdown("www/pbb_method.md")
            ),
    
    tabItem(tabName = "brian",
            includeMarkdown("www/pbb_brian.md")
            
    ) # end tabItems
    )# end dashboardBody
  ) # end dashboardPage
) # end shiny
)
)# end ui 
