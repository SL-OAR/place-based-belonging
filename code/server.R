##################################
# Place Based Belonging App.     #
# by OAR Extern team             #
# server.R file                  #
##################################

# renv::snapshot() # use to update packages
# renv::restore() # if your project code isn't working. This probably implies that you have the wrong package versions installed and you need to restore from known good state in the lockfile.
# 
# packages <- c("shiny", "reactable", "htmltools",
#               "treemapify", "tidyverse", "rvest",
#               "leaflet.extras", "shinydashboard",
#               "shinycssloaders", "here", "reticulate",
#               "markdown", "fastmap", "bslib",
#               "shinyalert", "shinyBS", "farver",
#               "labeling", "crayon", "cli", "viridisLite",
#               "remotes", "fastmap", "conflicted",
#               "rsconnect"
# )
# 
# # Function to handle errors
# handle_error <- function(step, err) {
#   cat(paste0("ERROR during ", step, ": ", conditionMessage(err), "\n"))
#   stop("Script execution halted due to an error.")
# }
# 
# # Install missing packages with error handling
# tryCatch({
#   installed_packages <- packages %in% rownames(installed.packages())
#   if (any(!installed_packages)) {
#     install.packages(packages[!installed_packages])
#   }
# }, error = function(e) handle_error("package installation", e))
# 
# # Load packages with error handling
# tryCatch({
#   invisible(lapply(packages, function(pkg) {
#     library(pkg, character.only = TRUE)
#   }))
# }, error = function(e) handle_error("package loading", e))
# 
# # Set package conflicts preference
# tryCatch({
#   conflicts_prefer(
#     shinydashboard::box(),
#     dplyr::filter(),
#     rvest::guess_encoding(),
#     dplyr::lag(),
#     bslib::page(),
#     markdown::rpubsUpload(),
#     rsconnect::serverInfo()
#   )
# }, error = function(e) handle_error("conflict resolution", e))
# 
# # Set working directory
# tryCatch({
#   path <- here::here()
#   setwd(path)
# }, error = function(e) handle_error("setting working directory", e))
# 
# # Activate the Conda environment using reticulate
# tryCatch({
#   use_condaenv("oar_pbb", required = TRUE)
# }, error = function(e) handle_error("Conda environment activation", e))
# 
# # If everything runs successfully
# cat("✅ Environment successfully activated and libraries loaded\n")



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
# Had to add due to error on "No package with ____ found"
# library(farver)
# library(labeling)
# library(crayon)
# library(cli)
# library(viridisLite)

#####

# library(conflicted)
# conflicts_prefer(
#   shinydashboard::box(),
#   dplyr::filter(),
#   rvest::guess_encoding(),
#   dplyr::lag(),
#   bslib::page(),
#   markdown::rpubsUpload(),
#   rsconnect::serverInfo()
# )


# Set working directory
path <- here::here()
setwd(path)
# packrat::on()

# Use reticulate to activate the conda environment
# use_condaenv("oar_pbb", required = TRUE)
# print("Environment successfully activated and libraries loaded.")


#####################
# SUPPORT FUNCTIONS #
#####################

source("code/helpers.R")
#source("code/filters_campus_emu.R") # Still not working
source("code/setup.R")


################
# SERVER LOGIC #
################

server <- function(input, output, session) {
  # Ensure all required inputs are available before proceeding
  check_inputs <- function(...) {
    inputs <- list(...)
    for (input in inputs) {
      if (is.null(input)) return(FALSE)
    }
    return(TRUE)
  }
  


##############################    
  ## Filters ## 
############################# 
  ## Campus Heat Maps
  
  # Type Select Campus
  output$typeSelectCampus <- renderUI({
    selectInput("typeSelectCampus", "Select Type:", choices = c("Undergraduate", "International", "Graduate"),
                selected = "Undergraduate")
  })

  # Year Select Campus
  output$yearSelectCampus <- renderUI({
    req(input$typeSelectCampus)
    if (input$typeSelectCampus == "Undergraduate") {
      selectInput("yearSelectCampus", "Select Year:", choices = c("2017", "2018", "2019", "2020", "2022"))
    } else if (input$typeSelectCampus == "International") {
      selectInput("yearSelectCampus", "Select Year:", choices = c("Undergrad 2020", "Undergrad & Grad 2022"))
    } else if (input$typeSelectCampus == "Graduate") {
      selectInput("yearSelectCampus", "Select Year:", choices = c("2022"))
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
  
############################# 
  ## Campus Tables 
  
  # Type Select Campus
  output$typeSelectCampusTable <- renderUI({
    selectInput("typeSelectCampusTable", "Select Type:", choices = c("Undergraduate", "International", "Graduate"),
                selected = "Undergraduate")
  })
  
  # Year Select Campus
  output$yearSelectCampusTable <- renderUI({
    req(input$typeSelectCampusTable)
    if (input$typeSelectCampusTable == "Undergraduate") {
      selectInput("yearSelectCampusTable", "Select Year:", choices = c("2018", "2019", "2020", "2022", "Overall"))
    } else if (input$typeSelectCampusTable == "International") {
      selectInput("yearSelectCampusTable", "Select Year:", choices = c("Undergrad 2020", "Undergrad & Grad 2022", "Overall"))
    } else if (input$typeSelectCampusTable == "Graduate") {
      selectInput("yearSelectCampusTable", "Select Year:", choices = c("2022"))
    }
  })
  
  # Cohort Select Campus
  output$cohortSelectCampusTable <- renderUI({
    req(input$typeSelectCampusTable, input$yearSelectCampusTable)
    if (input$typeSelectCampusTable == "Undergraduate" && input$yearSelectCampusTable %in% c("2019", "2020", "2022")) {
      choices <- switch(input$yearSelectCampusTable,
                        "2019" = c("All Cohorts", "15/16", "16/17", "17/18", "18/19"),
                        "2020" = c("All Cohorts", "16/17", "17/18", "18/19", "19/20"),
                        "2022" = c("All Cohorts", "18/19", "19/20", "20/21", "21/22"))
      selectInput("cohortSelectCampusTable", "Select Cohort:", choices = choices)
    } else {
      selectInput("cohortSelectCampusTable", "Select Cohort:", choices = c("No cohort available"))
    }
  })
  
#############################   
  ## EMU Belonging 
  # EMU Heat Maps
  
  # Type Select EMU
  output$typeSelectEmu <- renderUI({
    selectInput("typeSelectEmu", "Select Type:", choices = c("Undergraduate", "International", "Graduate"), 
                selected = "Undergraduate")
  })
  
  # Year Select EMU
  output$yearSelectEmu <- renderUI({
    req(input$typeSelectEmu)
    if (input$typeSelectEmu == "Undergraduate") {
      selectInput("yearSelectEmu", "Select Year:", choices = c("2018", "2019", "2020", "2022"))
    } else if (input$typeSelectEmu == "International") {
      selectInput("yearSelectEmu", "Select Year:", choices = c("Undergrad 2020", "Undergrad & Grad 2022"))
    } else if (input$typeSelectEmu == "Graduate") {
      selectInput("yearSelectEmu", "Select Year:", choices = c("2022"))
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

#############################     
  ## Inclusive ##
  
  ## Inclusive Bar Plots
  
  # Type Select Inclusive Bar
  output$typeSelectInclusiveBar <- renderUI({
    req(input$visualizationType == "Aggregated - Bar Plot")
    selectInput("typeSelectInclusiveBar", "Select Type:", choices = c("Undergraduate", "International", "Graduate"))
  })
  
  # Year Select Inclusive Bar
  output$yearSelectInclusiveBar <- renderUI({
    req(input$visualizationType == "Aggregated - Bar Plot")
    selectInput("yearSelectInclusiveBar", "Select Year:", choices = c("Overall" , "2022", "2020", "2019", "2018"))
  })
  
  # Cohort Select Inclusive Bar
  output$cohortSelectInclusiveBar <- renderUI({
    req(input$visualizationType == "Aggregated - Bar Plot")
    selectInput("cohortSelectInclusiveBar", "Select Cohort:", 
                choices = c("All Years", "1st Year", "2nd Year", "3rd Year", "4th Year"))
  })
  
#############################   
  ## Tree Maps Inclusiveness 
  # Campus #
  
  # Type Select Campus Tree Map
  output$typeSelectCampusTreeMap <- renderUI({
    selectInput("typeSelectCampusTreeMap", "Select Type:", choices = c("Undergraduate", "International", "Graduate"),
                selected = "Undergraduate")
  })
  
  # Year Select Campus Tree Map
  output$yearSelectCampusTreeMap <- renderUI({
    req(input$typeSelectCampusTreeMap)
    if (input$typeSelectCampusTreeMap == "Undergraduate") {
      selectInput("yearSelectCampusTreeMap", "Select Year:", choices = c("Overall", "2018", "2019", "2020", "2022"))
    } else if (input$typeSelectCampusTreeMap == "International") {
      selectInput("yearSelectCampusTreeMap", "Select Year:", choices = c("Overall", "2020"))
    } else if (input$typeSelectCampusTreeMap == "Graduate") {
      selectInput("yearSelectCampusTreeMap", "Select Year:", choices = c("2022"))
    }
  })
  
  # Cohort Select Campus Tree Map
  output$cohortSelectCampusTreeMap <- renderUI({
    req(input$typeSelectCampusTreeMap, input$yearSelectCampusTreeMap)
    if (input$typeSelectCampusTreeMap == "Undergraduate") {
      if (input$yearSelectCampusTreeMap %in% c("2022", "2020", "2019")) {
        choices <- switch(input$yearSelectCampusTreeMap,
                          "2022" = c("All Years", "4th Year", "3rd Year", "2nd Year", "1st Year"),
                          "2020" = c("All Years", "4th Year", "3rd Year", "2nd Year", "1st Year"),
                          "2019" = c("All Years", "4th Year", "3rd Year", "2nd Year", "1st Year"))
        selectInput("cohortSelectCampusTreeMap", "Select Cohort:", choices = choices)
      } else if (input$yearSelectCampusTreeMap == "2018") {
        selectInput("cohortSelectCampusTreeMap", "Select Cohort:", choices = c("1st-3rd Years"))
      } else {
        selectInput("cohortSelectCampusTreeMap", "Select Cohort:", choices = c("No cohort available"))
      }
    } else {
      selectInput("cohortSelectCampusTreeMap", "Select Cohort:", choices = c("No cohort available"))
    }
  })
  
  
#############################   
  # EMU #
  # Type Select EMU Tree Map
  output$typeSelectEmuTreeMap <- renderUI({
    selectInput("typeSelectEmuTreeMap", "Select Type:", choices = c("Undergraduate", "International", "Graduate"),
                selected = "Undergraduate")
  })
  
  # Year Select EMU Tree Map
  output$yearSelectEmuTreeMap <- renderUI({
    req(input$typeSelectEmuTreeMap)
    
    if (input$typeSelectEmuTreeMap == "Undergraduate") {
      selectInput("yearSelectEmuTreeMap", "Select Year:", 
                  choices = c("2018", "2019", "2020", "2022", "Overall"))
    } else if (input$typeSelectEmuTreeMap == "International") {
      selectInput("yearSelectEmuTreeMap", "Select Year:", 
                  choices = c("Overall", "2022", "Spring 2020"))
    } else if (input$typeSelectEmuTreeMap == "Graduate") {
      selectInput("yearSelectEmuTreeMap", "Select Year:", 
                  choices = c("Overall"))
    }
  })
  
  # Cohort Select EMU Tree Map
  output$cohortSelectEmuTreeMap <- renderUI({
    req(input$typeSelectEmuTreeMap, input$yearSelectEmuTreeMap)
    
    if (input$typeSelectEmuTreeMap == "Undergraduate") {
      if (input$yearSelectEmuTreeMap %in% c("2022", "2020", "2019")) {
        choices <- switch(input$yearSelectEmuTreeMap,
                          "2022" = c("All Years", "4th Year", "3rd Year", "2nd Year", "1st Year"),
                          "2020" = c("All Years", "4th Year", "3rd Year", "2nd Year", "1st Year"),
                          "2019" = c("All Years", "4th Year", "3rd Year", "2nd Year", "1st Year"))
        selectInput("cohortSelectEmuTreeMap", "Select Cohort:", choices = choices)
      } else if (input$yearSelectEmuTreeMap == "2018") {
        selectInput("cohortSelectEmuTreeMap", "Select Cohort:", choices = c("1st-3rd Years"))
      } else {
        selectInput("cohortSelectEmuTreeMap", "Select Cohort:", choices = c("No cohort available"))
      }
    } else if (input$typeSelectEmuTreeMap == "International") {
      selectInput("cohortSelectEmuTreeMap", "Select Cohort:", choices = c("No cohort available"))
    } else if (input$typeSelectEmuTreeMap == "Graduate") {
      selectInput("cohortSelectEmuTreeMap", "Select Cohort:", choices = c("No cohort available"))
    }
  })
  
  
#############################   
  # Wordcloud filters
  
 # Word Clouds Filtering
output$typeSelectWordsCloud <- renderUI({
  selectInput("typeSelectWordsCloud", "Select Type:", 
              choices = c("Undergraduate", "International", "Graduate"), 
              selected = "Undergraduate"
  )
})

# Generate the main location select input based on the selected student group
output$placeSelectCloud <- renderUI({
  req(input$typeSelectWordsCloud)

  # Clear place2Select when switching between locations
  updateSelectInput(session, "place2SelectCloud", selected = NULL)

  if (input$typeSelectWordsCloud == "Undergraduate") {
    selectInput("placeSelectCloud", "Select Location:",
                choices = c("Allen", "Autzen Stadium", "Cemetery", "Chapman", "Erb Memorial Union (EMU)",
                            "Frohnmayer", "Hayward Field", "HEDCO", "Jaqua", "Knight Law", "Lawrence",
                            "Knight Library", "Lillis Business Complex", "Lokey Science Complex",
                            "Matthew Knight Arena", "McKenzie", "Oregon", "Straub", "Student Rec Complex",
                            "Tykeson", "University Health Services", "University Housing"))
  } else if (input$typeSelectWordsCloud == "International") {
    selectInput("placeSelectCloud", "Select Location:",
                choices = c("Erb Memorial Union (EMU)", "Knight Library", "Lokey Science Complex",
                            "Student Rec Complex", "University Housing"))
  } else if (input$typeSelectWordsCloud == "Graduate") {
    selectInput("placeSelectCloud", "Select Location:",
                choices = c("Knight Library", "Student Rec Complex"))
  }
})
  

# Generate the sub-location select input when a complex like EMU, Lokey, or Housing is selected
output$place2SelectCloud <- renderUI({
  req(input$placeSelectCloud)  # Ensure a place is selected
  
  sub_location_choices <- NULL  # Default to no options
  
  # Special restrictions for International students
  if (input$typeSelectWordsCloud == "International") {
    if (input$placeSelectCloud == "Erb Memorial Union (EMU)") {
      sub_location_choices <- c("Overall", "Mills Center")  # Limited options for EMU
    } else if (input$placeSelectCloud == "Lokey Science Complex") {
      sub_location_choices <- c("Overall")  # International students only get "Overall" at Lokey
    } else if (input$placeSelectCloud == "University Housing") {
      sub_location_choices <- c("Overall")  # International students only get "Overall" at Housing
    }
  } else {
    # Default sub-location choices for Undergraduate & Graduate students
    if (input$placeSelectCloud == "Erb Memorial Union (EMU)") {
      sub_location_choices <- c("Overall", "Atrium East", "Courtyard", "Craft", "Duck Nest", "Falling Sky", 
                                "Fishbowl", "Fresh Market", "LGBTQIA3", "Mills Center", 
                                "Multicultural Center", "O Lounge", "Taylor Lounge", "Women's Center")
    } else if (input$placeSelectCloud == "Lokey Science Complex") {
      sub_location_choices <- c("Overall", "Columbia", "Klamath", "Lewis", "Science Commons", "Willamette")
    } else if (input$placeSelectCloud == "University Housing") {
      sub_location_choices <- c("Overall", "Barnhart", "Bean", "Carson", "Earl", "Global Scholars",
                                "Hamilton", "Kalapuya Ilihi", "Living Learning", "Unthank", "Walton")
    }
  }
  
  # Render dropdown only if there are valid sub-location choices
  if (!is.null(sub_location_choices)) {
    selectInput("place2SelectCloud", "Select Location:", choices = sub_location_choices, selected = "Overall")
  } else {
    return(NULL)  # Hide input if no sub-location choices are available
  }
})


observeEvent(input$typeSelectWordsCloud, {
  req(input$typeSelectWordsCloud)
  # Define available location choices based on selected type
  location_choices <- switch(input$typeSelectWordsCloud,
                             "Undergraduate" = c("Allen", "Autzen Stadium", "Cemetery", "Chapman", "Erb Memorial Union (EMU)",
                                                 "Frohnmayer", "Hayward Field", "HEDCO", "Jaqua", "Knight Law", "Lawrence",
                                                 "Knight Library", "Lillis Business Complex", "Lokey Science Complex",
                                                 "Matthew Knight Arena", "McKenzie", "Oregon", "Straub", "Student Rec Complex",
                                                 "Tykeson", "University Health Services", "University Housing"),
                             "International" = c("Erb Memorial Union (EMU)", "Knight Library", "Lokey Science Complex",
                                                 "Student Rec Complex", "University Housing"),
                             "Graduate" = c("Knight Library", "Student Rec Complex"),
                             c("Allen", "Autzen Stadium", "Cemetery", "Chapman", "Erb Memorial Union (EMU)",
                               "Frohnmayer", "Hayward Field", "HEDCO", "Jaqua", "Knight Law", "Lawrence",
                               "Knight Library", "Lillis Business Complex", "Lokey Science Complex",
                               "Matthew Knight Arena", "McKenzie", "Oregon", "Straub", "Student Rec Complex",
                               "Tykeson", "University Health Services", "University Housing"))  # Default for Undergraduate
  
  # **Force Reset `placeSelectCloud`** by first setting it to an empty list
  updateSelectInput(session, "placeSelectCloud", choices = NULL, selected = NULL)
  # **After a short delay, update it with the correct values**  
  later::later(function() {
    updateSelectInput(session, "placeSelectCloud", choices = location_choices, selected = location_choices[1])
  }, delay = 0.1)
  
  # Reset place2SelectCloud UI
  output$place2SelectCloud <- renderUI({ NULL })
})


observeEvent(input$placeSelectCloud, {
  req(input$placeSelectCloud)  # Ensure placeSelectCloud is not NULL
  
  if (input$placeSelectCloud %in% c("Erb Memorial Union (EMU)", "Lokey Science Complex", "University Housing")) {
    
    # Handle International students separately
    sub_location_choices <- if (input$typeSelectWordsCloud == "International") {
      switch(input$placeSelectCloud,
             "Erb Memorial Union (EMU)" = c("Overall", "Mills Center"),
             "Lokey Science Complex" = c("Overall"),
             "University Housing" = c("Overall"),
             NULL)
    } else {
      # Default sub-location options for Undergraduate & Graduate students
      switch(input$placeSelectCloud,
             "Erb Memorial Union (EMU)" = c("Overall", "Atrium East", "Courtyard", "Craft", 
                                            "Duck Nest", "Falling Sky", "Fishbowl", "Fresh Market", 
                                            "LGBTQIA3", "Mills Center", "Multicultural Center", 
                                            "O Lounge", "Taylor Lounge", "Women's Center"),
             "Lokey Science Complex" = c("Overall", "Columbia", "Klamath", "Lewis", 
                                         "Science Commons", "Willamette"),
             "University Housing" = c("Overall", "Barnhart", "Bean", "Carson", "Earl", 
                                      "Global Scholars", "Hamilton", "Kalapuya Ilihi", 
                                      "Living Learning", "Unthank", "Walton"),
             NULL)
    }
    
    # Ensure sub_location_choices is valid before rendering UI
    if (!is.null(sub_location_choices)) {
      output$place2SelectCloud <- renderUI({
        selectInput("place2SelectCloud", "Select Location:", choices = sub_location_choices, selected = "Overall")
      })
    } else {
      output$place2SelectCloud <- renderUI({ NULL })
    }
    
  } else {
    # Remove the sub-location dropdown when switching to a building without sub-locations
    output$place2SelectCloud <- renderUI({ NULL })
  }
})


  
#############################   
  # Wordnet filters
  
  output$typeSelectWordsNet <- renderUI({
    selectInput("typeSelectWordsNet", "Select Type:", 
                choices = c("Undergraduate", "International", "Graduate"), 
                selected = "Undergraduate"
    )
  })
  
  # Generate the main location select input based on the selected student group
  output$placeSelectNet <- renderUI({
    req(input$typeSelectWordsNet)  
    
    # Clear place2Select when switching between locations
    updateSelectInput(session, "place2SelectNet", selected = NULL)
    
    if (input$typeSelectWordsNet == "Undergraduate") {
      selectInput("placeSelectNet", "Select Location:",
                  choices = c("Allen", "Autzen Stadium", "Cemetery", "Chapman", "Erb Memorial Union (EMU)",
                              "Frohnmayer", "Hayward Field", "HEDCO", "Jaqua", "Knight Law", "Lawrence",
                              "Knight Library", "Lillis Business Complex", "Lokey Science Complex",
                              "Matthew Knight Arena", "McKenzie", "Oregon", "Straub", "Student Rec Complex",
                              "Tykeson", "University Health Services", "University Housing"))
    } else if (input$typeSelectWordsNet == "International") {
      selectInput("placeSelectNet", "Select Location:", 
                  choices = c("Erb Memorial Union (EMU)", "Knight Library", "Lokey Science Complex",
                              "Student Rec Complex", "University Housing"))
    } else if (input$typeSelectWordsNet == "Graduate") {
      selectInput("placeSelectNet", "Select Location:",
                  choices = c("Knight Library", "Student Rec Complex"))
    }
  })
  
  # Generate the sub-location select input when a complex like EMU, Lokey, or Housing is selected
  output$place2SelectNet <- renderUI({
    req(input$placeSelectNet)  # Ensure a place is selected
    
    if (input$typeSelectWordsNet == "Undergraduate") {
      if (input$placeSelectNet == "Erb Memorial Union (EMU)") {
        selectInput("place2SelectNet", "Select Location:",
                    choices = c("Overall", "Atrium East", "Courtyard", "Craft", "Duck Nest", "Falling Sky", 
                                "Fishbowl", "Fresh Market", "LGBTQIA3", "Mills Center", 
                                "Multicultural Center", "O Lounge", "Taylor Lounge", "Women's Center"))
      } else if (input$placeSelectNet == "Lokey Science Complex") {
        selectInput("place2SelectNet", "Select Location:",
                    choices = c("Overall", "Columbia", "Klamath", "Lewis", "Science Commons", "Willamette"))
      } else if (input$placeSelectNet == "University Housing") {
        selectInput("place2SelectNet", "Select Location:",
                    choices = c("Overall", "Barnhart", "Bean", "Carson", "Earl", "Global Scholars",
                                "Hamilton", "Kalapuya Ilihi", "Living Learning", "Unthank", "Walton"))
      }
    }
    else if (input$typeSelectWordsNet == "International" && input$placeSelectNet == "Erb Memorial Union (EMU)") {
      # Special case: International students only get "Overall" and "Mills Center" for EMU
      selectInput("place2SelectNet", "Select Location:", 
                  choices = c("Overall", "Mills Center"))
    }
  })
  
  observe({
    req(input$typeSelectWordsNet, input$placeSelectNet)  # Ensure both inputs are available
    
    if (input$typeSelectWordsNet == "International" && input$placeSelectNet == "Erb Memorial Union (EMU)") {
      # If International selects EMU, ensure place2Select defaults to "Overall" if not set
      if (is.null(input$place2SelectNet)) {
        updateSelectInput(session, "place2SelectNet", selected = "Overall")
      }
    } else if (input$typeSelectWordsNet %in% c("International", "Graduate")) {
      # Ensure "Overall" is assigned but place2Select is NOT visible for Graduate students
      updateSelectInput(session, "place2SelectNet", selected = "Overall")
    }
  })
  
############################# 
  
  location_file_name_map <- list(
    "Allen" = list(wordnet = "allen", wordcloud = "allen", reasons = "allen"),
    "Autzen Stadium" = list(wordnet = "autzen", wordcloud = "autzen_stadium", reasons = "autzen"),
    "Cemetery" = list(wordnet = "cemetery", wordcloud = "cemetery", reasons = "cemetery"),
    "Chapman" = list(wordnet = "chapman", wordcloud = "chapman", reasons = "chapman"),
    "Erb Memorial Union (EMU)" = list(wordnet = "emu", wordcloud = "emu_overall", reasons = "emu"),
    "Frohnmayer" = list(wordnet = "frohnmayer", wordcloud = "frohnmayer", reasons = "frohnmayer"),
    "Hayward Field" = list(wordnet = "hayward", wordcloud = "hayward", reasons = "hayward"),
    "HEDCO" = list(wordnet = "hedco", wordcloud = "hedco", reasons = "hedco"),
    "Jaqua" = list(wordnet = "jaqua", wordcloud = "jaqua", reasons = "jaqua"),
    "Knight Law" = list(wordnet = "law", wordcloud = "knight_law", reasons = "law"),
    "Lawrence" = list(wordnet = "lawrence", wordcloud = "lawrence", reasons = "lawrence"),
    "Knight Library" = list(wordnet = "library", wordcloud = "library", reasons = "library"),
    "Lillis Business Complex" = list(wordnet = "lillis", wordcloud = "lillis", reasons = "lillis"),
    "Lewis" = list(wordnet = "lewis", wordcloud = "lewis", reasons = "lewis"),
    
    # Handle different naming conventions properly
    "Lokey Science Complex" = list(wordnet = "lokey", wordcloud = "lokey_complex", reasons = "lokey"),
    "Matthew Knight Arena" = list(wordnet = "mattknight", wordcloud = "mattknight", reasons = "mattknight"),
    "McKenzie" = list(wordnet = "mckenzie", wordcloud = "mckenzie", reasons = "mckenzie"),
    "Oregon" = list(wordnet = "oregon", wordcloud = "oregon", reasons = "oregon"),
    "Straub" = list(wordnet = "straub", wordcloud = "straub", reasons = "straub"),
    "Student Rec Complex" = list(wordnet = "src", wordcloud = "src", reasons = "src"),
    "Tykeson" = list(wordnet = "tykeson", wordcloud = "tykeson", reasons = "tykeson"),
    "University Health Services" = list(wordnet = "uhs", wordcloud = "uhs", reasons = "uhs"),
    "University Housing" = list(wordnet = "housing", wordcloud = "housing", reasons = "housing"),
    "Spencer View" = list(wordnet = "spencer_view", wordcloud = "spencer_view", reasons = "spencer_view"),
    "Pacific" = list(wordnet = "pacific", wordcloud = "pacific", reasons = "pacific"),
    "Black Cultural Center" = list(wordnet = "bcc", wordcloud = "bcc", reasons = "bcc"),
    "University Hall" = list(wordnet = "university_hall", wordcloud = "university_hall", reasons = "university_hall"),
    
    # Sub-locations
    "Women's Center" = list(wordnet = "womens", wordcloud = "womens", reasons = "womens"),
    "Willamette" = list(wordnet = "willamette", wordcloud = "willamette", reasons = "willamette"),
    "Walton" = list(wordnet = "walton", wordcloud = "walton", reasons = "walton"),
    "Unthank" = list(wordnet = "unthank", wordcloud = "unthank", reasons = "unthank"),
    "Taylor Lounge" = list(wordnet = "taylor", wordcloud = "taylor", reasons = "taylor"),
    "O Lounge" = list(wordnet = "olounge", wordcloud = "olounge", reasons = "olounge"),
    "Mills Center" = list(wordnet = "mills", wordcloud = "mills_center", reasons = "mills"),
    "Fishbowl" = list(wordnet = "fishbowl", wordcloud = "fishbowl", reasons = "fishbowl"),
    "Falling Sky" = list(wordnet = "fallingsky", wordcloud = "falling_sky", reasons = "falling_sky"),
    "Fresh Market" = list(wordnet = "freshmarket", wordcloud = "fresh_market", reasons = "fresh_market"),
    "Duck Nest" = list(wordnet = "ducknest", wordcloud = "duck_nest", reasons = "duck_nest"),
    "Duck Store" = list(wordnet = "duck_store", wordcloud = "duck_store", reasons = "duck_store"),
    "Craft" = list(wordnet = "craft", wordcloud = "craft_center", reasons = "craft"),
    "Courtyard" = list(wordnet = "courtyard", wordcloud = "courtyard", reasons = "courtyard"),
    "Columbia" = list(wordnet = "columbia", wordcloud = "columbia", reasons = "columbia"),
    "Barnhart" = list(wordnet = "barnhart", wordcloud = "barnhart", reasons = "barnhart"),
    "Bean" = list(wordnet = "bean", wordcloud = "bean", reasons = "bean"),
    "Carson" = list(wordnet = "carson", wordcloud = "carson", reasons = "carson"),
    "Earl" = list(wordnet = "earl", wordcloud = "earl", reasons = "earl"),
    "Hamilton" = list(wordnet = "hamilton", wordcloud = "hamilton", reasons = "hamilton"),
    "Kalapuya Ilihi" = list(wordnet = "kalapuya", wordcloud = "kalapuya", reasons = "kalapuya"),
    "Living Learning" = list(wordnet = "llc", wordcloud = "llc", reasons = "llc"),
    "Global Scholars" = list(wordnet = "gsh", wordcloud = "gsh", reasons = "gsh"),
    "Atrium East" = list(wordnet = "atrium", wordcloud = "atrium_east", reasons = "atrium"),
    "Science Commons" = list(wordnet = "scicom", wordcloud = "science_commons", reasons = "scicom"),
    "Multicultural Center" = list(wordnet = "mcc", wordcloud = "mcc", reasons = "mcc"),
    "LGBTQIA3" = list(wordnet = "lgbtqa3", wordcloud = "lgbtqa3", reasons = "lgbtqa3"),
    "Lisbon" = list(wordnet = "lisb", wordcloud = "lisb", reasons = "lisb"),
    "Klamath" = list(wordnet = "klamath", wordcloud = "klamath", reaasons = "klamath")
  )
  

############################# 
  ## Reasons Tables 
  
  output$placeSelectReasonsTable <- renderUI({
    selectInput("placeSelectReasonsTable", "Select Location:",
                choices = c("Allen", "Autzen Stadium", "Cemetery", "Chapman", "Erb Memorial Union (EMU)",
                            "Frohnmayer", "Hayward Field", "HEDCO", "Jaqua", "Knight Law", "Lawrence",
                            "Knight Library", "Lillis Business Complex", "Lokey Science Complex",
                            "Matthew Knight Arena", "McKenzie", "Oregon", "Straub", "Student Rec Complex",
                            "Tykeson", "University Health Services", "University Housing", "University Hall", 
                            "Black Cultural Center"))
  })
  
  output$place2SelectReasonsTable <- renderUI({
    req(input$placeSelectReasonsTable)
    
    sub_location_choices <- NULL
    default_selection <- NULL  # Default will be dynamically set
    
    if (input$placeSelectReasonsTable == "Erb Memorial Union (EMU)") {
      sub_location_choices <- c("Erb Memorial Union (EMU)", "Atrium East", "Courtyard", "Craft", "Duck Nest", "Falling Sky", 
                                "Fishbowl", "Fresh Market", "LGBTQIA3", "Mills Center", "Duck Store", 
                                "Multicultural Center", "O Lounge", "Taylor Lounge", "Women's Center")
      default_selection <- "Overall"  # EMU starts with "Overall"
    } else if (input$placeSelectReasonsTable == "Lokey Science Complex") {
      sub_location_choices <- c("Columbia", "Klamath", "Lewis", "Science Commons", "Willamette", "Pacific")
      default_selection <- sub_location_choices[1]  # Lokey starts with the first available sub-location
    } else if (input$placeSelectReasonsTable == "University Housing") {
      sub_location_choices <- c("Barnhart", "Bean", "Carson", "Earl", "Global Scholars",
                                "Hamilton", "Kalapuya Ilihi", "Living Learning", "Unthank", "Walton", "Spencer View")
      default_selection <- sub_location_choices[1]  # Housing starts with the first available sub-location
    }
    
    if (!is.null(sub_location_choices)) {
      selectInput("place2SelectReasonsTable", "Select Location:", choices = sub_location_choices, selected = default_selection)
    } else {
      return(NULL)  # Hide dropdown if not needed
    }
  })
  
  
  output$sentiSelectReasonsTable <- renderUI({
    req(input$placeSelectReasonsTable)  # Ensure a place is selected
    
    # Only require place2SelectReasonsTable if the selected place is a complex
    if (input$placeSelectReasonsTable %in% c("Erb Memorial Union (EMU)", "Lokey Science Complex", "University Housing")) {
      req(input$place2SelectReasonsTable)  # Ensure the secondary location is available
    }
    
    # Define available sentiments dynamically based on the selected location
    available_sentiments <- NULL
    
    # Dynamically check if the sentiment exists in `sentence_tables`
    formatted_place <- gsub(" ", "_", tolower(input$placeSelectReasonsTable))
    
    sentiment_options <- c("b" = "Belong", "db" = "Don't Belong")  # New mapping
    
    available_sentiments <- names(sentiment_options)[paste0("sent_", formatted_place, "_", names(sentiment_options)) %in% names(sentence_tables)]
    
    # Convert shorthand ("b" → "Belong", "db" → "Don't Belong") for user display
    sentiment_labels <- sentiment_options[available_sentiments]
    
    # If no sentiment data is available, default to "Belong"
    if (length(sentiment_labels) == 0) {
      sentiment_labels <- c("b" = "Belong")  # Default to "Belong" only
    }
    
    selectInput("sentiSelectReasonsTable", "Select Sentiment:", choices = sentiment_labels, selected = names(sentiment_labels)[1])
  })
  

  
  
#############################   
## Emotions Bar Graph ##
  
  output$typeSelectEmotion <- renderUI({
    selectInput("typeSelectEmotion", "Select Type:", 
                choices = c("Undergraduate", "International", "Graduate"), 
                selected = "Undergraduate"
    )
  })
  
  # Generate the main location select input based on the selected student group
  output$buildingSelect <- renderUI({
    req(input$typeSelectEmotion)  
    
    # Clear place2Select when switching between locations
    updateSelectInput(session, "building2Select", selected = NULL)
    
    if (input$typeSelectEmotion == "Undergraduate") {
      selectInput("buildingSelect", "Select Location:",
                  choices = c("Allen", "Autzen Stadium", "Cemetery", "Chapman", "Erb Memorial Union (EMU)",
                              "Frohnmayer", "Hayward Field", "HEDCO", "Jaqua", "Knight Law", "Lawrence",
                              "Knight Library", "Lillis Business Complex", "Lokey Science Complex",
                              "Matthew Knight Arena", "McKenzie", "Oregon", "Straub", "Student Rec Complex",
                              "Tykeson", "University Health Services", "University Housing"))
    } else if (input$typeSelectEmotion == "International") {
      selectInput("buildingSelect", "Select Location:", 
                  choices = c("Erb Memorial Union (EMU)", "Knight Library", "Lokey Science Complex",
                              "Student Rec Complex", "University Housing"))
    } else if (input$typeSelectEmotion == "Graduate") {
      selectInput("buildingSelect", "Select Location:",
                  choices = c("Knight Library", "Student Rec Complex"))
    }
  })
  
  # Generate the sub-location select input when a complex like EMU, Lokey, or Housing is selected
  output$building2Select <- renderUI({
    req(input$buildingSelect)  # Ensure a place is selected
    
    if (input$typeSelectEmotion == "Undergraduate") {
      if (input$buildingSelect == "Erb Memorial Union (EMU)") {
        selectInput("building2Select", "Select Location:",
                    choices = c("Overall", "Atrium East", "Courtyard", "Craft", "Duck Nest", "Falling Sky", 
                                "Fishbowl", "Fresh Market", "LGBTQIA3", "Mills Center", 
                                "Multicultural Center", "O Lounge", "Taylor Lounge", "Women's Center"))
      } else if (input$buildingSelect == "Lokey Science Complex") {
        selectInput("building2Select", "Select Location:",
                    choices = c("Overall", "Columbia", "Klamath", "Lewis", "Science Commons", "Willamette"))
      } else if (input$buildingSelect == "University Housing") {
        selectInput("building2Select", "Select Location:",
                    choices = c("Overall", "Barnhart", "Bean", "Carson", "Earl", "Global Scholars",
                                "Hamilton", "Kalapuya Ilihi", "Living Learning", "Unthank", "Walton"))
      }
    }
    else if (input$typeSelectEmotion == "International" && input$buildingSelect == "Erb Memorial Union (EMU)") {
      # Special case: International students only get "Overall" and "Mills Center" for EMU
      selectInput("building2Select", "Select Location:", 
                  choices = c("Overall", "Mills Center"))
    }
      else if (input$typeSelectEmotion == "International" && input$buildingSelect == "Lokey Science Complex") {
        # Special case: International students only get "Overall" for Lokey Science
        selectInput("building2Select", "Select Location:", 
                    choices = c("Overall"))
      }
      
      else if (input$typeSelectEmotion == "International" && input$buildingSelect == "University Housing") {
        # Special case: International students only get "Overall" for Housing
        selectInput("building2Select", "Select Location:", 
                    choices = c("Overall"))
      }
  })
  
  observe({
    req(input$typeSelectEmotion, input$buildingSelect)  # Ensure both inputs are available
    
    if (input$typeSelectEmotion == "International" && input$buildingSelect == "Erb Memorial Union (EMU)") {
      # If International selects EMU, ensure place2Select defaults to "Overall" if not set
      if (is.null(input$building2Select)) {
        updateSelectInput(session, "building2Select", selected = "Overall")
      }
    } else if (input$typeSelectEmotion %in% c("International", "Graduate")) {
      # Ensure "Overall" is assigned but place2Select is NOT visible for Graduate students
      updateSelectInput(session, "building2Select", selected = "Overall")
    }
  })

  
### End filters ##
  
  
#################################
  
  ## Rendering Logic ##  
  
#################################
  
  
  ## Inclusiveness ##
  ### RenderBarPlot Function ###
  
  # Render Campus Bar Plots 
  output$inclusiveBar <- renderUI({
    req(input$visualizationType == "Aggregated - Bar Plot")
    
    type <- input$typeSelectInclusiveBar
    year <- input$yearSelectInclusiveBar
    cohort <- input$cohortSelectInclusiveBar
    
    print(paste("Year value:", year))
    print(paste("Cohort value:", cohort))
    
    # Ensure that type is a single valid string
    if (length(type) != 1 || is.null(type)) {
      return(HTML("<p>Invalid type selection.</p>"))
    }
    
    if (type == "Undergraduate") {
      filename <- switch(year,
                         "Overall" = "ibar_cam_us_ug.png",
                         "2022" = switch(cohort,
                                         "All Years" = "ibar_cam_us_ug_ay2122.png",
                                         "4th Year" = "ibar_cam_us_ug_ay2122_c2122.png",
                                         "3rd Year" = "ibar_cam_us_ug_ay2122_c2021.png",
                                         "2nd Year" = "ibar_cam_us_ug_ay2122_c1920.png",
                                         "1st Year" = "ibar_cam_us_ug_ay2122_c1819.png"),
                         "2020" = switch(cohort,
                                         "All Years" = "ibar_cam_us_ug_ay1920.png",
                                         "4th Year" = "ibar_cam_us_ug_ay1920_c1920.png",
                                         "3rd Year" = "ibar_cam_us_ug_ay1920_c1819.png",
                                         "2nd Year" = "ibar_cam_us_ug_ay1920_c1718.png",
                                         "1st Year" = "ibar_cam_us_ug_ay1920_c1617.png"),
                         "2019" = switch(cohort,
                                         "All Years" = "ibar_cam_us_ug_ay1819.png",
                                         "4th Year" = "ibar_cam_us_ug_ay1819_c1819.png",
                                         "3rd Year" = "ibar_cam_us_ug_ay1819_c1718.png",
                                         "2nd Year" = "ibar_cam_us_ug_ay1819_c1617.png",
                                         "1st Year" = "ibar_cam_us_ug_ay1819_c1516.png"),
                         "2018" = "ibar_cam_us_ug_ay1718.png")
    } else if (type == "International") {
      filename <- switch(year,
                         "Overall" = "ibar_cam_i.png",
                         "2022" = "ibar_cam_i_ay2122.png",
                         "2020" = "ibar_cam_i_ug_ay1920.png")
    } else if (type == "Graduate") {
      filename <- switch(year,
                         "2022" = "ibar_cam_gr_ay2122.png")
    } else {
      return(HTML("<p>No valid data for the selected options.</p>"))
    }
    
    # Construct the full path to the image file
    full_image_path <- file.path(getwd(), "code", "www", "ibars", filename)
    print(paste("Checking full path:", full_image_path))
    
    # Check if the file exists and then adjust the image path for Shiny
    if (file.exists(full_image_path)) {
      print(paste("File found:", full_image_path))
      image_path <- file.path("ibars", filename)
      return(img(src = image_path, height = "400px"))
    } else {
      print(paste("File not found:", full_image_path))
      return(HTML("<p>No image available for the selected options.</p>"))
    }
  })
  
  #################################  
  ### Campus Trees ###
  
  renderCampusTree <- function(type, year, cohort) {
    data <- NULL
    
    # Assign input values, and make sure they are of length 1 
    # Chat GPT's fix for a warning I was receiving about Null values
    type <- if (!is.null(input$typeSelectCampusTreeMap) && 
                length(input$typeSelectCampusTreeMap) == 1) {
      input$typeSelectCampusTreeMap
    } else {
      NA
    }
    
    year <- if (!is.null(input$yearSelectCampusTreeMap) && 
                length(input$yearSelectCampusTreeMap) == 1) {
      input$yearSelectCampusTreeMap
    } else {
      NA
    }
    
    cohort <- if (!is.null(input$cohortSelectCampusTreeMap) && 
                  length(input$cohortSelectCampusTreeMap) == 1) {
      input$cohortSelectCampusTreeMap
    } else {
      NA
    }
    
    # Check if type is "Undergraduate" and if year is valid
    if (!is.na(type) && type == "Undergraduate") {
      data <- switch(year,
                     "Overall" = tm_cam_us_ug,
                     "2022" = switch(cohort,
                                     "All Years" = tm_cam_us_ug_ay2122,
                                     "4th Year" = tm_cam_us_ug_ay2122_c2122,
                                     "3rd Year" = tm_cam_us_ug_ay2122_c2021,
                                     "2nd Year" = tm_cam_us_ug_ay2122_c1920,
                                     "1st Year" = tm_cam_us_ug_ay2122_c1819),
                     "2020" = switch(cohort,
                                     "All Years" = tm_cam_us_ug_ay1920,
                                     "4th Year" = tm_cam_us_ug_ay1920_c1920,
                                     "3rd Year" = tm_cam_us_ug_ay1920_c1819,
                                     "2nd Year" = tm_cam_us_ug_ay1920_c1718,
                                     "1st Year" = tm_cam_us_ug_ay1920_c1617),
                     "2019" = switch(cohort,
                                     "All Years" = tm_cam_us_ug_ay1819,
                                     "4th Year" = tm_cam_us_ug_ay1819_c1819,
                                     "3rd Year" = tm_cam_us_ug_ay1819_c1718,
                                     "2nd Year" = tm_cam_us_ug_ay1819_c1617,
                                     "1st Year" = tm_cam_us_ug_ay1819_c1516),
                     "2018" = tm_cam_us_ug_ay1718
      )
    } else if (!is.na(type) && type == "International") {
      data <- switch(year,
                     "Overall" = tm_cam_i,
                     "2020" = tm_cam_i_ug_ay1920
      )
    } else if (!is.na(type) && type == "Graduate") {
      data <- switch(year,
                     "2022" = tm_cam_gr_ay2122
      )
    }
    
    # Ensure data is not NULL, is a dataframe, and has the 'tot' column
    if (!is.null(data) && is.data.frame(data) && "tot" %in% colnames(data)) {
      inclusive_tree_fun(data)
    } else {
      HTML("<p>No data available or required column 'tot' is missing for the selected options.</p>")
    }
  }
  
  # Render tree maps for Campus
  output$campusTree <- renderPlot({
    req(input$visualizationType == "Disaggregated - Tree Maps" && input$locationSelect == "Full Campus")
    renderCampusTree(input$typeSelectCampusTreeMap, input$yearSelectCampusTreeMap, input$cohortSelectCampusTreeMap)
  })
  
  
  #################################
  ### EMU Trees ###
  
  renderEmuTree <- function(type, year, cohort) {
    data <- NULL
    
    # Assign input values, and make sure they are of length 1 
    # Chat GPT's fix for a warning I was receiving about Null values
    type <- if (!is.null(input$typeSelectEmuTreeMap) && 
                length(input$typeSelectEmuTreeMap) == 1) {
      input$typeSelectEmuTreeMap
    } else {
      NA
    }
    
    year <- if (!is.null(input$yearSelectEmuTreeMap) && 
                length(input$yearSelectEmuTreeMap) == 1) {
      input$yearSelectEmuTreeMap
    } else {
      NA
    }
    
    cohort <- if (!is.null(input$cohortSelectEmuTreeMap) && 
                  length(input$cohortSelectEmuTreeMap) == 1) {
      input$cohortSelectEmuTreeMap
    } else {
      NA
    }
    
    img_path <- "code/www/Nothing_to_see.png"  
    
    # Check conditions for rendering specific tree maps
    if (!is.null(type) && !is.na(type) && type == "Undergraduate") {
      data <- switch(year,
                     "Overall" = tm_emu_us_ug,
                     "2018" = tm_emu_us_ug_ay1718,
                     "2019" = switch(cohort,
                                     "All Years" = tm_emu_us_ug_ay1819,
                                     "1st Year" = tm_emu_us_ug_ay1819_c1819),
                     "2020" = switch(cohort,
                                     "All Years" = tm_emu_us_ug_ay1920,
                                     "1st Year" = tm_emu_us_ug_ay1920_c1920,
                                     "2nd Year" = tm_emu_us_ug_ay1920_c1819),
                     "2022" = switch(cohort,
                                     "All Years" = tm_emu_us_ug_ay2122,
                                     "1st Year" = tm_emu_us_ug_ay2122_c2122))
    } else if (!is.na(type) && type == "International") {
      # International doesn't have any tree maps available: display the png file only.
      grid::grid.raster(png::readPNG(img_path))
      return(NULL)
    } else if (!is.na(type) && type == "Graduate") {
      # Graduate doesn't have any tree maps available: display the png file only.
      grid::grid.raster(png::readPNG(img_path))
      return(NULL)
    }
    
    # If data exists, render the tree map. Otherwise, show the fallback image.
    if (!is.null(data)) {
      inclusive_tree_fun(data)
    } else {
      grid::grid.raster(png::readPNG(img_path))
    }
  }
  
  # Render tree maps for EMU
  output$emuTree <- renderPlot({
    req(input$locationSelect == 'EMU Student Union')
    renderEmuTree(input$typeSelectEmuTreeMap, input$yearSelectEmuTreeMap, input$cohortSelectEmuTreeMap)
  })
  
  
  #################################
  ## Reactable Tables: 
  # Reactable Table for Campus Maps
  
  output$tableCampus <- renderReactable({
    
    # Ensure inputs are available
    req(input$typeSelectCampusTable, input$yearSelectCampusTable, input$cohortSelectCampusTable)
    
    # Initialize variables
    table_to_display <- NULL
    year <- input$yearSelectCampusTable
    cohort <- input$cohortSelectCampusTable
    type <- input$typeSelectCampusTable
    
    # Mapping years
    year_map <- list("2018" = "1718",
                     "2019" = "1819",
                     "2020" = "1920",
                     "2022" = "2122")
    
    # Function to format cohort correctly for dataset lookup
    format_cohort <- function(cohort) {
      if (cohort %in% c("All Cohorts", "No cohort available")) {
        return(NULL)  # No cohort suffix needed
      } else {
        return(paste0("c", gsub("/", "", cohort)))  # Convert "15/16" → "c1516"
      }
    }
    
    # Helper function to create table name
    create_table_name <- function(type, year, cohort) {
      mapped_year <- year_map[[year]]
      if (is.null(mapped_year)) return(NULL)
      
      cohort_suffix <- format_cohort(cohort)
      
      if (is.null(cohort_suffix)) {
        return(paste0("rt_", type, "_ay", mapped_year))  # No cohort suffix
      } else {
        return(paste0("rt_", type, "_ay", mapped_year, "_", cohort_suffix))  # Add cohort suffix
      }
    }
    
    # Determine the table to display
    if (type == "Undergraduate") {
      if (year == "Overall") {
        table_to_display <- if (exists("rt_us_ug")) reactable_fun(rt_us_ug) else NULL
      } else {
        table_name <- create_table_name("us_ug", year, cohort)
        if (exists(table_name)) {
          table_to_display <- tryCatch({ reactable_fun(get(table_name)) }, error = function(e) { NULL })
        }
      }
    } else if (type == "International") {
      if (year == "Overall") {
        table_to_display <- if (exists("rt_i")) reactable_fun(rt_i) else NULL
      } else if (year == "Undergrad 2020") {
        table_to_display <- if (exists("rt_i_ug_ay1920")) reactable_fun(rt_i_ug_ay1920) else NULL
      } else if (year == "Undergrad & Grad 2022") {
        table_to_display <- if (exists("rt_i_ay2122")) reactable_fun(rt_i_ay2122) else NULL
      }
    } else if (type == "Graduate" && year == "2022") {
      if (exists("rt_gr_ay2122")) {
        table_to_display <- reactable_fun(rt_gr_ay2122)
      } else {
        table_to_display <- NULL
      }
    }
    
    # Render the table or a message if no data is available
    if (!is.null(table_to_display)) {
      table_to_display
    } else {
      HTML("<p>No data available for the selected options.</p>")
    }
  })
  
  
  
######################
  ## Heat Maps: 
  # Heat Maps for EMU
  output$belongingMapEmu <- renderUI({
    req(input$typeSelectEmu, input$yearSelectEmu, input$cohortSelectEmu)
    base_path <- "maps/"
    image_src_belonging <- ""
    
    if (input$typeSelectEmu == "Undergraduate") {
      year <- input$yearSelectEmu
      mapped_year <- switch(year,
                            "2018" = "1718",
                            "2019" = "1819",
                            "2020" = "1920",
                            "2022" = "2122")
        cohort <- input$cohortSelectEmu
        
        if (cohort == "All Cohorts" || cohort == "No cohort available") {
          image_src_belonging <- paste0("map_emu_b_us_ug_ay", mapped_year, ".png")
        } else {
          cohort <- gsub("/", "", cohort)
          image_src_belonging <- paste0("map_emu_b_us_ug_ay", mapped_year, "_c", cohort, ".png")
        }
    } else if (input$typeSelectEmu == "International") {
        year <- input$yearSelectEmu
        
        image_src_belonging <- switch (year, 
                                       "Undergrad 2020" = "map_emu_b_i_ug_ay1920.png",
                                       "Undergrad & Grad 2022" = "map_emu_b_i_ay2122.png",
                                       NULL) # Ensures an invalid selection does not break the UI

    } else if (input$typeSelectEmu == "Graduate" && input$yearSelectEmu == "2022") {
      image_src_belonging <- "map_emu_b_gr_ay2122.png"
    }
    
    if (image_src_belonging %in% available_maps) {
      img(src = paste0(base_path, image_src_belonging), class = "responsive-map", alt = "EMU Belonging Map")
    } else {
      tags$p("No belonging map available for the selected options.")
    }
  })
  
  addPopover(session, id = "belongingMapEmu", title = "EMU Belonging Map", 
             content = "Number equals the number of clicks. Color equals density of clicks.", 
             trigger = "hover", placement = "right", options = list(container = "body"))
  
  
  ## Not Belonging Map for EMU
  output$notBelongingMapEmu <- renderUI({
    req(input$typeSelectEmu, input$yearSelectEmu, input$cohortSelectEmu)
    base_path <- "maps/"
    image_src_not_belonging <- ""
    
    if (input$typeSelectEmu == "Undergraduate") {
      year <- input$yearSelectEmu
      mapped_year <- switch(year,
                              "2018" = "1718",
                              "2019" = "1819",
                              "2020" = "1920",
                              "2022" = "2122")
      cohort <- input$cohortSelectEmu
        
        if (cohort == "All Cohorts" || cohort == "No cohort available") {
          image_src_not_belonging <- paste0("map_emu_db_us_ug_ay", mapped_year, ".png")
        } else {
          cohort <- gsub("/", "", cohort)
          image_src_not_belonging <- paste0("map_emu_db_us_ug_ay", mapped_year, "_c", cohort, ".png")
        }
    } else if (input$typeSelectEmu == "International") {
      year <- input$yearSelectEmu
      
      image_src_not_belonging <- switch (year, 
                                     "Undergrad 2020" = "map_emu_db_i_ug_ay1920.png",
                                     "Undergrad & Grad 2022" = "map_emu_db_i_ay2122.png",
                                     NULL) # Ensures an invalid selection does not break the UI
      
    } else if (input$typeSelectEmu == "Graduate" && input$yearSelectEmu == "2022") {
      image_src_not_belonging <- "map_emu_db_gr_ay2122.png"
    }
    
    if (image_src_not_belonging %in% available_maps) {
      img(src = paste0(base_path, image_src_not_belonging), class = "responsive-map", alt = "EMU Don't Belong Map")
    } else {
      tags$p("No 'Don't Belong' map available for the selected options.")
    }
  })
  
  addPopover(session, id = "notBelongingMapEmu", title = "EMU Don't Belong Map", 
             content = "Number equals the number of clicks. Color equals density of clicks.", 
             trigger = "hover", placement = "right", options = list(container = "body"))
  
 
  #######################  
  ## Heat Maps:
  # Heat Maps for Campus
  # Belonging Map
  output$belongingMapCampus <- renderUI({
    req(input$typeSelectCampus, input$yearSelectCampus, input$cohortSelectCampus)
    base_path <- "maps/"
    image_src_belonging <- ""
    
    if (input$typeSelectCampus == "Undergraduate") {
      year <- input$yearSelectCampus
      mapped_year <- switch(year,
                              "2017" = "1617",
                              "2018" = "1718",
                              "2019" = "1819",
                              "2020" = "1920",
                              "2022" = "2122")
        cohort <- input$cohortSelectCampus
        
        if (cohort == "All Cohorts" || cohort == "No cohort available") {
          image_src_belonging <- paste0("map_cam_b_us_ug_ay", mapped_year, ".png")
        } else {
          cohort <- gsub("/", "", cohort)
          image_src_belonging <- paste0("map_cam_b_us_ug_ay", mapped_year, "_c", cohort, ".png")
        }
    }     else if (input$typeSelectCampus == "International") {
      year <- input$yearSelectCampus
      
      image_src_belonging <- switch(year,
                                    "Undergrad 2020" = "map_cam_b_i_ug_ay1920.png",
                                    "Undergrad & Grad 2022" = "map_cam_b_i_ay2122.png",
                                    NULL  # Ensures an invalid selection does not break the UI
                                    )
    } else if (input$typeSelectCampus == "Graduate" && input$yearSelectCampus == "2022") {
      image_src_belonging <- "map_cam_b_gr_ay2122.png"
    }
    
    if (image_src_belonging %in% available_maps) {
      img(src = paste0(base_path, image_src_belonging), class = "responsive-map", 
          alt = "Campus Belonging Map")
    } else {
      tags$p("No belonging map available for the selected options.")
    }
  })
  
  addPopover(session, id = "belongingMapCampus", title = "Campus Belonging Map", 
            content = "Number equals the number of clicks. Color equals density of clicks.", 
            trigger = "hover", placement = "right", options = list(container = "body"))
  
  # Not Belonging Map
  output$notBelongingMapCampus <- renderUI({
    req(input$typeSelectCampus, input$yearSelectCampus, input$cohortSelectCampus)
    base_path <- "maps/"
    image_src_not_belonging <- ""
    
    if (input$typeSelectCampus == "Undergraduate") {
      year <- input$yearSelectCampus
      mapped_year <- switch(year,
                            "2017" = "1617",
                            "2018" = "1718", 
                            "2019" = "1819",
                            "2020" = "1920",
                            "2022" = "2122")
        cohort <- input$cohortSelectCampus
        
        if (cohort == "All Cohorts" || cohort == "No cohort available") {
          image_src_not_belonging <- paste0("map_cam_db_us_ug_ay", mapped_year, ".png")
        } else {
          cohort <- gsub("/", "", cohort)
          image_src_not_belonging <- paste0("map_cam_db_us_ug_ay", mapped_year, "_c", cohort, ".png")
        }
        
    } else if (input$typeSelectCampus == "International") {
      year <- input$yearSelectCampus
      
      image_src_belonging <- switch(year,
                                    "Undergrad 2020" = "map_cam_db_i_ug_ay1920.png",
                                    "Undergrad & Grad 2022" = "map_cam_db_i_ay2122.png",
                                    NULL  # Ensures an invalid selection does not break the UI
                                    )
    
    } else if (input$typeSelectCampus == "Graduate" && input$yearSelectCampus == "2022") {
      image_src_not_belonging <- "map_cam_db_gr_ay2122.png"
    }
    
    if (image_src_not_belonging %in% available_maps) {
      img(src = paste0(base_path, image_src_not_belonging), class = "responsive-map", 
          alt = "Campus Don't Belong Map")
    } else {
      tags$p("No 'Don't Belong' map available for the selected options.")
    }
  }
  )
  
  addPopover(session, id = "notBelongingMapCampus", title = "Campus Don't Belong Map", 
            content = "Number equals the number of clicks. Color equals density of clicks.", 
            trigger = "hover", placement = "right", options = list(container = "body"))
  
  
#######################   
  ## Word Nets, Word Clouds, & Reason Tables
  
  ## Dynamic Word Clouds
  
  
  wc_data <- reactive({
    req(input$typeSelectWordsCloud, input$placeSelectCloud, input$belongStatus)
    
    student_group <- switch(input$typeSelectWordsCloud,
                            "Undergraduate" = "us_ug",
                            "International" = "i",
                            "Graduate" = "gr")
    
    # Validate building name mapping
    if (!input$placeSelectCloud %in% names(location_file_name_map)) {
      warning(paste("Location not found in mapping:", input$placeSelectCloud))
      return(NULL)
    }
    
    building_name <- location_file_name_map[[input$placeSelectCloud]]$wordcloud
    if (is.null(building_name)) {
      warning(paste("No wordcloud mapping found for:", input$placeSelectCloud))
      return(NULL)
    }
    
    building_name <- tolower(building_name)
    
    # Handle sub-location mappings (only for EMU, Lokey, and Housing)
    if (!is.null(input$place2SelectCloud) && input$place2SelectCloud != "Overall" &&
        input$placeSelectCloud %in% c("Erb Memorial Union (EMU)", "Lokey Science Complex", "University Housing")) {
      
      sub_location_mapped <- location_file_name_map[[input$place2SelectCloud]]$wordcloud
      
      if (!is.null(sub_location_mapped)) {
        building_name <- tolower(sub_location_mapped)
      } else {
        building_name <- tolower(gsub(" ", "_", input$place2SelectCloud))
      }
    }
    
    # Construct dataset key
    key <- paste0("wc_", building_name, "_", input$belongStatus, "_", student_group)
    
    message("Looking for dataset key: ", key)
    
    # Check if dataset exists
    if (exists(key, envir = .GlobalEnv)) {
      data <- get(key, envir = .GlobalEnv)
      if (!is.null(data) && nrow(data) > 0) {
        return(data)
      }
    }
    
    warning(paste("Dataset not found:", key))
    return(NULL)
  })
  


  # Render the word cloud dynamically using wordcloud2
  output$wordCloudPlot <- renderWordcloud2({
    wc_data_filtered <- wc_data()
    
    # Debugging: Check if data is valid
    print("Rendering Word Cloud...")
    #print(str(wc_data_filtered))
    
    # Placeholder image when no word cloud is available
    no_data_image_path <- file.path(getwd(), "code", "www", "Nothing_to_see.png")
    
    if (is.null(wc_data_filtered) || nrow(wc_data_filtered) == 0) {
      print("No data available for word cloud.")
      
      # Show the image in a separate UI output
      output$wordCloudPlaceholder <- renderUI({
        tags$img(
          src = "Nothing_to_see.png",  # Relative path; Shiny looks inside www/
          alt = "No data available for the selected options",
          style = "height: 400px; display: block; margin: auto;"
        )
      })
      
      return(NULL)  # Stop further processing
    } else {
      # Clear the placeholder if word cloud data is available
      output$wordCloudPlaceholder <- renderUI({ NULL })
    }
    
    # Define color mappings
    color_mapping <- list(
      "b" = "#FEE123",   # Color for belonging
      "db" = "#9FD430"   # Color for don't belong
    )
    
    bg_color_mapping <- list(
      "b" = "#004D6C",   # Background color for belonging
      "db" = "#820043"   # Background color for don't belong
    )
    
    # Select the correct colors based on Belonging status
    text_color <- color_mapping[[input$belongStatus]]  # Select text color
    bg_color <- bg_color_mapping[[input$belongStatus]]  # Select background color
    
    wordcloud2(data = wc_data_filtered,
               size = 1,
               minSize = 9,
               minRotation = pi/4,
               maxRotation = -pi/6,
               rotateRatio = 0.5,
               color = text_color,  # Use dynamic color
               backgroundColor = bg_color)  # Use dynamic background color
  })
  
  # UI Output for placeholder image
  output$wordCloudUI <- renderUI({
    uiOutput("wordCloudPlaceholder")  # This will hold the image if no data exists
  })
  
#######################  
  # Word nets
  
  output$wordNetImage <- renderImage({
    req(input$typeSelectWordsNet, input$placeSelectNet, input$belongStatus)  
    
    student_group <- switch(input$typeSelectWordsNet,
                            "Undergraduate" = "us_ug",
                            "International" = "i",
                            "Graduate" = "gr")
    
    building_name <- location_file_name_map[[input$placeSelectNet]]$wordnet
    building_name <- tolower(building_name)
    
    if (!is.null(input$place2SelectNet) && input$place2SelectNet != "Overall" &&
        input$placeSelectNet %in% c("Erb Memorial Union (EMU)", "Lokey Science Complex", "University Housing")) {
      sub_location_mapped <- location_file_name_map[[input$place2SelectNet]]
      if (!is.null(sub_location_mapped)) {
        building_name <- tolower(sub_location_mapped)
      } else {
        building_name <- tolower(gsub(" ", "_", input$place2SelectNet))
      }
    }
    
    # Construct the file path for word nets
    file_name_net <- paste0("bg_", building_name, "_", input$belongStatus, "_", student_group, ".png")
    full_image_path_net <- file.path(getwd(), "code", "www", "wordnets", file_name_net)
    # Placeholder image when no word cloud is available
    no_data_image_path <- file.path(getwd(), "code", "www", "Nothing_to_see.png")
    
    if (file.exists(full_image_path_net)) {
      return(list(
        src = full_image_path_net, 
        alt = paste("Word net for", input$place2SelectNet, input$placeSelectNet, input$typeSelectWordsNet, input$belongStatus),
        height = "400px"
      ))
    } else {
      return(list(
        src = no_data_image_path, 
        alt = "No data available for the selected options",
        height = "400px"
      ))
    }
  }, deleteFile = FALSE)
  
  
####################### 
  ## Reasons Tables
  
  output$tableReasons <- renderReactable({
    req(input$placeSelectReasonsTable, input$sentiSelectReasonsTable)  # Ensure primary inputs exist
    
    # Check if the selected place requires a sub-location (EMU, Lokey, Housing)
    requires_sub_location <- input$placeSelectReasonsTable %in% c("Erb Memorial Union (EMU)", "Lokey Science Complex", "University Housing")
    
    # Require place2SelectReasonsTable if the selected place needs a sub-location
    if (requires_sub_location) {
      req(input$place2SelectReasonsTable)
    }
    
    # Retrieve the correctly mapped name for reasons tables
    mapped_place <- location_file_name_map[[input$placeSelectReasonsTable]]$reasons
    
    # Ensure the mapping exists before proceeding
    if (is.null(mapped_place)) {
      print(paste("No mapping found for:", input$placeSelectReasonsTable))
      return(reactable(data.frame(Message = "No data available for this selection")))
    }
    
    # If a sub-location is selected, update mapped_place
    if (requires_sub_location && !is.null(input$place2SelectReasonsTable)) {
      mapped_place <- location_file_name_map[[input$place2SelectReasonsTable]]$reasons
    }
    
    # Map sentiment to correct shorthand ("Belong" → "b", "Don't Belong" → "db")
    sentiment_code <- ifelse(input$sentiSelectReasonsTable == "Belong", "b", "db")
    
    # Construct the expected table name
    table_name <- paste0("sent_", mapped_place, "_", sentiment_code)
    
    # Debugging: Print the table name to console
    print(paste("Looking for table:", table_name))
    
    # Check if the table exists in sentence_tables
    if (table_name %in% names(sentence_tables)) {
      print(paste("Rendering table:", table_name))
      
      reactable(sentence_tables[[table_name]], 
                searchable = TRUE,  # Enables global search
                filterable = TRUE,  # Enables column-specific filters
                defaultPageSize = 10,  # Show 10 rows per page
                showPagination = TRUE  # Show pagination controls
      )
    } else {
      print(paste("Table not found:", table_name))
      reactable(data.frame(Message = "No data available for this selection"))  # Show a message if no data exists
    }
  })
  
  
  
  
#######################   
  ## Emotions Bar Plots ##
  
  observeEvent(input$buildingSelect, {
    # Reset the sub-location (building2Select) to "Overall" only if the previous building was EMU, Lokey, or University Housing
    if (input$buildingSelect %in% c("Erb Memorial Union (EMU)", "Lokey Science Complex", "University Housing")) {
      updateSelectInput(session, "building2Select", selected = "Overall")
    } else {
      # For buildings without sub-locations, we can hide or disable the sub-location input if needed
      updateSelectInput(session, "building2Select", selected = NULL)
    }
  })
  
  output$emotionImage <- renderImage({
    req(input$typeSelectEmotion, input$buildingSelect, input$belongStatus)  
    
    student_group <- switch(input$typeSelectEmotion,
                            "Undergraduate" = "us_ug",
                            "International" = "i",
                            "Graduate" = "gr")
    
    building_name <- location_file_name_map[[input$buildingSelect]]$wordnet # Uses wordnet naming 
    building_name <- tolower(building_name)  
    
    if (!is.null(input$building2Select) && input$building2Select != "Overall" && input$buildingSelect %in% c("Erb Memorial Union (EMU)", "Lokey Science Complex", "University Housing")) {
      sub_location_mapped <- location_file_name_map[[input$building2Select]]
      if (!is.null(sub_location_mapped)) {
        building_name <- tolower(sub_location_mapped)
      } else {
        building_name <- tolower(gsub(" ", "_", input$building2Select))
      }
    }
    
    # Construct the file path
    file_name <- paste0("ebar_", building_name, "_", input$belongStatus, "_", student_group, ".png")
    
    # Define the full path to the image directory (in 'www/wordclouds')
    full_image_path <- file.path(getwd(), "code", "www", "ebars", file_name)
    
    # Placeholder image when no word cloud is available
    no_data_image_path <- file.path(getwd(), "code", "www", "Nothing_to_see.png")
    
    # Check if the file exists for the selected belong status
    if (file.exists(full_image_path)) {
      return(list(
        src = full_image_path, 
        alt = paste("Emotion Bar Plot for", input$building2Select, input$buildingSelect, input$typeSelectEmotion, input$belongStatus),
        height = "400px"
      ))
    } else {
      # Render the placeholder image if the file does not exist
      return(list(
        src = no_data_image_path, 
        alt = "No data available for the selected options",
        height = "400px"
      ))
    }
  }, deleteFile = FALSE)
  
}
