## Filters ## 

## Campus Belonging
# Type Select Campus
output$typeSelectCampus <- renderUI({
  selectInput("typeSelectCampus", "Select Type:", choices = c("Undergraduate", "International", "Graduate"))
})

# Year Select Campus
output$yearSelectCampus <- renderUI({
  req(input$typeSelectCampus)
  if (input$typeSelectCampus == "Undergraduate") {
    selectInput("yearSelectCampus", "Select Year:", choices = c("2018", "2019", "2020", "2022", "Overall"))
  } else if (input$typeSelectCampus == "International") {
    selectInput("yearSelectCampus", "Select Year:", choices = c("Undergrad 2020", "Overall"))
  } else if (input$typeSelectCampus == "Graduate") {
    selectInput("yearSelectCampus", "Select Year:", choices = c("Overall", "2022"))
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


## EMU Belonging 

# Type Select EMU
output$typeSelectEmu <- renderUI({
  selectInput("typeSelectEmu", "Select Type:", choices = c("Undergraduate", "International", "Graduate"))
})

# Year Select EMU
output$yearSelectEmu <- renderUI({
  req(input$typeSelectEmu)
  if (input$typeSelectEmu == "Undergraduate") {
    selectInput("yearSelectEmu", "Select Year:", choices = c("2018", "2019", "2020", "2022", "Overall"))
  } else if (input$typeSelectEmu == "International") {
    selectInput("yearSelectEmu", "Select Year:", choices = c("Undergrad 2020", "Overall"))
  } else if (input$typeSelectEmu == "Graduate") {
    selectInput("yearSelectEmu", "Select Year:", choices = c("Overall", "2022"))
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


## Tree Maps Inclusiveness 
# Campus #

# Type Select Campus Tree Map
output$typeSelectCampusTreeMap <- renderUI({
  selectInput("typeSelectCampusTreeMap", "Select Type:", choices = c("Undergraduate", "International", "Graduate"))
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



# EMU #
# Type Select EMU Tree Map
output$typeSelectEmuTreeMap <- renderUI({
  selectInput("typeSelectEmuTreeMap", "Select Type:", choices = c("Undergraduate", "International", "Graduate"))
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



# Wordclouds filters

output$typeSelectWords <- renderUI({
  selectInput("typeSelectWords", "Select Type:", 
              choices = c("Undergraduate", "International", "Graduate"), 
              selected = "Undergraduate"
  )
})

# Generate the main location select input based on the selected student group
output$placeSelect <- renderUI({
  req(input$typeSelectWords)  
  
  # Clear place2Select when switching between locations
  updateSelectInput(session, "place2Select", selected = NULL)
  
  if (input$typeSelectWords == "Undergraduate") {
    selectInput("placeSelect", "Select Location:",
                choices = c("Allen", "Autzen Stadium", "Cemetery", "Chapman", "Erb Memorial Union (EMU)",
                            "Frohnmayer", "Hayward Field", "HEDCO", "Jaqua", "Knight Law", "Lawrence",
                            "Knight Library", "Lillis Business Complex", "Lokey Science Complex",
                            "Matthew Knight Arena", "McKenzie", "Oregon", "Straub", "Student Rec Complex",
                            "Tykeson", "University Health Services", "University Housing"))
  } else if (input$typeSelectWords == "International") {
    selectInput("placeSelect", "Select Location:", 
                choices = c("Erb Memorial Union (EMU)", "Knight Library", "Lokey Science Complex",
                            "Student Rec Complex", "University Housing"))
  } else if (input$typeSelectWords == "Graduate") {
    selectInput("placeSelect", "Select Location:",
                choices = c("Knight Library", "Student Rec Complex"))
  }
})

# Generate the sub-location select input when a complex like EMU, Lokey, or Housing is selected
output$place2Select <- renderUI({
  req(input$placeSelect)  
  
  if (input$placeSelect == "Erb Memorial Union (EMU)") {
    selectInput("place2Select", "Select Location:",
                choices = c("Overall", "Atrium East", "Courtyard", "Craft", "Duck Nest", "Falling Sky", 
                            "Fishbowl", "Fresh Market", "LGBTQIA3", "Mills Center", 
                            "Multicultural Center", "O Lounge", "Taylor Lounge", "Women's Center"))
  } else if (input$placeSelect == "Lokey Science Complex") {
    selectInput("place2Select", "Select Location:",
                choices = c("Overall", "Columbia", "Klamath", "Lewis", "Science Commons", "Willamette"))
  } else if (input$placeSelect == "University Housing") {
    selectInput("place2Select", "Select Location:",
                choices = c("Overall", "Barnhart", "Bean", "Carson", "Earl", "Global Scholars",
                            "Hamilton", "Kalapuya Ilihi", "Living Learning", "Unthank", "Walton"))
  }
})

location_file_name_map <- list(
  "Allen" = "allen",
  "Autzen Stadium" = "autzen",
  "Cemetery" = "cemetery",
  "Chapman" = "chapman",
  "Erb Memorial Union (EMU)" = "emu",
  "Frohnmayer" = "frohnmayer",
  "Hayward Field" = "hayward",
  "HEDCO" = "hedco",
  "Jaqua" = "jaqua",
  "Knight Law" = "law",
  "Lawrence" = "lawrence",
  "Knight Library" = "library",
  "Lillis Business Complex" = "lillis",
  "Lokey Science Complex" = "lokey",
  "Matthew Knight Arena" = "mattknight",
  "McKenzie" = "mckenzie",
  "Oregon" = "oregon",
  "Straub" = "straub",
  "Student Rec Complex" = "src",
  "Tykeson" = "tykeson",
  "University Health Services" = "uhs",
  "University Housing" = "housing",
  
  # Secondary level options
  "Women's Center" = "womens",
  "Willamette" = "willamette",
  "Walton" = "walton",
  "Unthank" = "unthank",
  "Taylor Lounge" = "taylor",
  "O Lounge" = "olounge",
  "Mills Center" = "mills",
  "Fishbowl" = "fishbowl",
  "Falling Sky" = "fallingsky",
  "Fresh Market" = "freshmarket",
  "Duck Nest" = "ducknest",
  "Craft" = "craft",
  "Courtyard" = "courtyard",
  "Columbia" = "columbia",
  "Barnhart" = "barnhart",
  "Bean" = "bean",
  "Carson" = "carson",
  "Earl" = "earl",
  "Hamilton" = "hamilton",
  "Kalapuya Ilihi" = "kalapuya",
  "Living Learning" = "llc",
  "Global Scholars" = "gsh",
  "Atrium East" = "atrium",
  "Science Commons" = "scicom",
  "Multicultural Center" = "mcc",
  "LGBTQIA3" = "lgbtqa3",
  "Lisbon" = "lisb",
  "Klamath" = "klamath"
)

