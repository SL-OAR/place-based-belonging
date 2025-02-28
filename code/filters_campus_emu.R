# filters_campus_emu.R

# The filters for campus maps and tables 
# + the filters for the emu maps and tables

# Type Select Campus
typeSelectCampusUI <- function(id) {
  selectInput(NS(id, "typeSelectCampus"), "Select Type:",
              choices = c("Undergraduate", "International", "Graduate"),
              selected = "Undergraduate")
}

# Year Select Campus
yearSelectCampusUI <- function(id) {
  selectInput(NS(id, "yearSelectCampus"), "Select Year:",
              choices = switch(input[[NS(id, "typeSelectCampus")]],
                               "Undergraduate" = c("2017", "2018", "2019", "2020", "2022"),
                               "International" = c("Undergrad 2020", "Undergrad & Grad 2022"),
                               "Graduate" = c("2022"),
                               character(0) # Default empty if none match
              ))
}

# Cohort Select Campus
cohortSelectCampusUI <- function(id) {
  selectInput(NS(id, "cohortSelectCampus"), "Select Cohort:",
              choices = if (input[[NS(id, "typeSelectCampus")]] == "Undergraduate" && 
                            input[[NS(id, "yearSelectCampus")]] %in% c("2019", "2020", "2022")) {
                switch(input[[NS(id, "yearSelectCampus")]],
                       "2019" = c("All Cohorts", "15/16", "16/17", "17/18", "18/19"),
                       "2020" = c("All Cohorts", "16/17", "17/18", "18/19", "19/20"),
                       "2022" = c("All Cohorts", "18/19", "19/20", "20/21", "21/22"))
              } else {
                c("No cohort available")
              })
}

