##################################
# Place Based Belonging App.     #
# by OAR Intern team             #
# ui.R file                      #
##################################
#renv::restore() # if your project code isn't working. This probably implies that you have the wrong package versions installed and you need to restore from known good state in the lockfile.
#renv::snapshot()
# For some reason I need to run this separately to get the app to run when I get that remote sha error





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
                       menuItem("SwaSI Project Details", tabName = "about", icon = icon("info-circle")),
                       menuItem("Summary of Findings", tabName = "findings", icon = icon("lightbulb")),
                       menuItem("Where? Campus Belonging", tabName = "campus", icon = icon("table")),
                       menuItem("Where? EMU Belonging", tabName = "emu", icon = icon("random", lib = "glyphicon")),
                       menuItem("Where? Inclusiveness", tabName = "inclusiveness", icon = icon("stats", lib = "glyphicon")),
                       menuItem("Why There? Wordnets & Wordclouds", tabName = "words", icon = icon("comment")),
                       menuItem("Why There? Emotions", tabName = "emotions", icon = icon("face-smile")),
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
        tags$html(lang = "en"),
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
        
        tabItem(tabName = "about", includeMarkdown("www/about.md")),
        
        tabItem(tabName = "findings", includeMarkdown("www/findings.md")),
        
        tabItem(tabName = "campus",
            tabBox(
              id = "campus_tabs", width = 12, 
              tabPanel("Maps",
                      includeMarkdown("www/maps_intro.md"),
                fluidRow(
                  column(4, uiOutput("typeSelectCampus")),
                  column(4, uiOutput("yearSelectCampus")),
                  column(4, uiOutput("cohortSelectCampus"))
                ),
                
                fluidRow(
                  column(12, 
                         tags$h3("Higher Sense of Belonging Map"),
                         div(class = "map-container",
                             uiOutput("belongingMapCampus", fill = "container")),
                         bsPopover(id = "belongingMapCampus", title = "Campus Higher Belonging Map", 
                                   content = "Number equals the number of clicks (Minimum 20 clicks). Color equals density of clicks (Red = higher density).", 
                                   trigger = "hover", placement = "bottom", options = list(container = "body"))
                  )
                ),
                
                fluidRow(
                  column(12, 
                         tags$h3("Lower Sense of Belonging Map"),
                         div(class = "map-container",
                             uiOutput("notBelongingMapCampus", fill = "container")),
                         bsPopover(id = "notBelongingMapCampus", title = "Campus Lower Belonging Map", 
                                   content = "Number equals the number of clicks (Minimum 20 clicks). Color equals density of clicks (Red = higher density).", 
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
          ), # End Campus Tables
      
      tabPanel("Summary",
               fluidRow(
                 includeMarkdown("www/campus_summary.md") # change to correct file
               )
              ) # End Summary Tab
        ) # End Campus Box
      ), # End Campus tab
        
        
        tabItem(tabName = "emu",
              tabBox(
                id = "emu_tabs", width = 12,
                tabPanel("Emu Maps",
                    includeMarkdown("www/emu_intro.md"),
                fluidRow(
                  column(4, uiOutput("typeSelectEmu")),
                  column(4, uiOutput("yearSelectEmu")),
                  column(4, uiOutput("cohortSelectEmu"))
                ),
                
                fluidRow(
                  column(width = 10,
                         tags$h3("Higher Sense of Belonging Map"),
                         div(class = "map-container",
                         uiOutput("belongingMapEmu", fill = "container")),
                         bsPopover(id = "belongingMapEmu", title = "Emu Higher Belonging Map", 
                                   content = "Number equals the number of clicks (Minimum 20 clicks). Color equals density of clicks (Red = higher density).", 
                                   trigger = "hover", placement = "bottom", options = list(container = "body"))
                  )
                ),
                
                fluidRow(
                  column(width = 10,
                         tags$h3("Lower Sense of Belonging Map"),
                         div(class = "map-container",
                         uiOutput("notBelongingMapEmu", fill = "container")),
                         bsPopover(id = "notBelongingMapEmu", title = "Emu Lower Belonging Map", 
                                   content = "Number equals the number of clicks (Minimum 20 clicks). Color equals density of clicks (Red = higher density).", 
                                   trigger = "hover", placement = "bottom", options = list(container = "body"))
                  )
                ),
                
                fluidRow(
                  column(width = 12, 
                         div(class = "responsive-caption", includeHTML("www/emu_map_caption.html"))
                  )
                )
              ), # Emu Maps Panel
              
              tabPanel("Summary",
                       includeMarkdown("www/emu_summary.md") 
                ) # End EMU Summary
              ) # End EMU Box
                
            # fluidRow(
            #       column(width = 12,
            #              reactableOutput("tableEmu"))
            #      )
            ), # End EMU Tab Item
        
        
        tabItem(tabName = "inclusiveness",
            tabBox(
                id = "inclusive_tabs", width = 12,
              tabPanel("Inclusivity Plots",
                includeMarkdown("www/inclusiveness_intro.md"),
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
                      column(width = 9,
                          div(class = "responsive-plot", 
                             h3("Inclusiveness"), 
                                 uiOutput("inclusiveBar", fill = "container")),
                             bsPopover(id = "inclusiveBar", title = "Aggregated Inclusivity", 
                                       content = "Inclusivity of aggregated campus places based on number of clicks for belonging divided by total clicks for a location.", 
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
                                 plotOutput("campusTree", height = "800px")
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
                               plotOutput("emuTree", height = "800px") # Fix Nothing_to_see.png 
                           )
                    )
                  ), 
                  fluidRow(
                    column(width = 12, 
                           div(class = "responsive-caption", includeHTML("www/emutree_caption.html"))
                    )
                  )
                ) #EMU conditional panel
              ), # End Inclusivity Plots
            tabPanel("Summary",
                     includeMarkdown("www/emu_summary.md")
                     ) # End Summary Panel
            ) # End inclusivity box
        ), #End of Inclusive tab
        
        
        tabItem(tabName = "words", 
              tabBox(
                  id = "words", width = 12, 
                tabPanel("Introduction to Words",
                        includeMarkdown("www/word_intro.md")
                        ), # End of Intro to words panel
                tabPanel("Word Clouds", 
                         includeMarkdown("www/clouds_intro.md"),
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
                                      choices = c("More Belong" = "b", "Less Belong" = "db"), 
                                      selected = "b"  # Default to "Belong" # I am not sure this is working
                         )
                  )
                  ),
                # Static Word Clouds
                  # fluidRow(
                  # column(width = 6,
                  #     div(class = "responsive-plot",
                  #        imageOutput("wordCloudImage", width = "100%", height = "auto"))
                  #     )
                  # ),
                # New Dynamic Word Clouds

                         fluidRow(
                           column(width = 12,
                                #div(class = "responsive-plot",
                                  tags$h3("Word Cloud"),
                                    uiOutput("wordCloudUI"),  # This will show the placeholder image
                                    wordcloud2Output("wordCloudPlot")  # Using wordcloud2 output instead of static images
                            #)
                           )
                         ),
                
                  fluidRow(    
                     column(width = 12, 
                            div(class = "responsive-caption", includeHTML("www/cloud_caption.html"))
                        )
                      )
                ),  # End word clouds panel

                tabPanel("Donut Words",
                         includeMarkdown("www/donuts_intro.md"),
                    fluidRow(
                      column(width = 12,
                             selectInput("typeSelectDonut", "Select Type:",
                                         choices = c("Undergraduate", "International", "Graduate"),
                                         selected = "Undergraduate" # Default to "Undergrad"
                             ),
                             uiOutput("placeSelectDonut"),  # place select input for both word clouds and word nets
                             uiOutput("place2SelectDonut"),  # second place select input for word clouds and word nets i.e. Buildings within complexes
                          )
                        ),

                    fluidRow(
                      column(12, 
                             conditionalPanel(
                               condition = "output.wordDonutBelong !== null",
                               plotlyOutput("wordDonutBelong")
                             ),
                             conditionalPanel(
                               condition = "output.wordDonutBelong === null",
                               textOutput("noBelongingDataMessage")
                             )
                      )
                    ), # Belonging Donut Plot
                    
                    fluidRow(
                      column(12, 
                             conditionalPanel(
                               condition = "output.wordDonutDb !== null",  # Show plot only if it exists
                               plotlyOutput("wordDonutDb")
                             ),
                             conditionalPanel(
                               condition = "output.wordDonutDb === null",  # Show message if plot is NULL
                               textOutput("noLessBelongingDataMessage")
                             )
                      )
                    ), # Less belonging Donut plot
                    
                    fluidRow(
                        column(width = 12,
                               div(class = "responsive-caption", includeHTML("www/donut_plot_caption.html"))
                          )
                      )
                    ), # End Donuts tab
                
                tabPanel("Word Nets",
                         includeMarkdown("www/nets_intro.md"),
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
                                               choices = c("More Belonging" = "b", "Less Belonging" = "db"), 
                                               selected = "b"  # Default to "Belong" # I am not sure this is working
                                  )
                           )
                         ),
                  fluidRow(
                    column(width = 12,
                       #div(id = "wordnetImageWrapper", class = "responsive-plot", 
                         uiOutput("wordNetImage", height = "600px", width = "100%"))
                       #div(class = "responsive-caption", includeHTML("www/net_caption.html"))
                          #)
                      ),
                fluidRow(
                    column(width = 12,
                           div(class = "responsive-caption", includeMarkdown("www/net_caption.md"))
                      )
                  )
                ), # End word nets Panel
                
            tabPanel("Reasons",
                     includeMarkdown("www/reasons_intro.md"),
                     fluidRow(
                       column(4, uiOutput("placeSelectReasonsTable")),
                       column(4, uiOutput("place2SelectReasonsTable")),
                       column(4, uiOutput("sentiSelectReasonsTable"))
                     ),
                     fluidRow(
                       column(12, reactableOutput("tableReasons"))
                     ),
                     fluidRow(
                       column(width = 12, 
                              div(class = "responsive-caption", includeHTML("www/reasons_table_caption.html"))
                       )
                     )
            ), # End Reasons Tab panel
            
            tabPanel("Summary", 
                     fluidRow(
                       column(width = 12,
                              includeMarkdown("www/words_summary.md")
                       )
                     )
                  ), # End Summary Tab)
              ) # End tab box
        ), # End words tab
      
      
        tabItem(tabName = "emotions",
              tabBox(
                  id = "emotions", width = 12, 
                tabPanel("Emotions",
                      includeMarkdown("www/emotions_intro.md"),
                fluidRow(
                  column(width = 6,
                          selectInput("typeSelectEmotion", "Select Type",
                                      choices = c("Undergraduate", "International", "Graduate"),
                                      selected = "Undergraduate" # default selection
                                      ),
                         uiOutput("buildingSelect"),
                         uiOutput("building2Select"),
                         radioButtons("belongStatus", "Select Belonging Status",
                                      choices = c("More Belonging" = "b", "Less Belonging" = "db"),
                                      selected = "b")
                    )
                  ),
                fluidRow(
                  column(width = 9,
                         div(id = "emotionImage" , class = "responsive-plot",  # Limit width and center it
                         uiOutput("emotionImage", fill = "container")),
                        bsPopover(id = "emotionImage", title = "Campus Emotions",
                            content = "The emotions associated with a place based on an analysis of responses to 'Why did you pick this location'.",
                            trigger = "hover", placement = "right", options = list(container = "body")),
                         div(class = "responsive-caption", includeMarkdown("www/emotion_caption.md"))
                    )
                  )
                
              #     column(width = 9,
              #          div(class = "responsive-caption", includeHTML("www/emotion_caption.html"))
              #     ),
              # fluidRow(
              # column(width = 12,
              #        div(class = "responsive-caption", includeHTML("www/emotion_caption.html"))
              #       )
              #     )
                ), # End emotions tab panel
            
            tabPanel("Emotion Wheel",
                     includeMarkdown("www/whom.md"),
                     fluidRow(
                       h3("Plutchik's Wheel of Emotions"),
                       tags$img(src = "wheel.png", width = "100%")
                       #box(width = NULL, background = "black", "text about emo.")
                     )  
                  ),  # End emotions wheel panel
            
            tabPanel("Summary", 
                     includeMarkdown("www/emotion_summary.md") # change to correct file
            ) 
            
              )
        ), # End emotions tab
      
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
