##################################
# Place Based Belonging App.     #
# by OAR Extern team             #
# server.R file                  #
##################################

# renv::snapshot() # use to update packages
# renv::restore() # if your project code isn't working. This probably implies that you have the wrong package versions installed and you need to restore from known good state in the lockfile.

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
## Had to add due to error on "No package with ____ found"
# library(farver)
# library(labeling)
# library(crayon)
# library(cli)
# library(viridisLite)

# Do we need a CSS styl sheet?

#########
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

#popify? To wrap UI element in popify to add popover to wrapped element

## Can also potentially use tooltip 
# bsTooltip("Text", "Tooltip info", placement = "bottom", trigger = "hover", options = NULL)
## Primarily for input to describe the function

#####

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


#####################
# SUPPORT FUNCTIONS #
#####################

source("code/helpers.R")
# I don't know how to get the server to use the filters in this file.
#source("code/filters.R")
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
  
  
  
#########################################
  
## Captions ##
  
  output$CampusMapCaption <- renderUI({
    HTML("<p><b>Note:</b> 
    <b><span style='color: red;'>R</span>
    <span style='color: orange;'>O</span>
    <span style='color: yellow;'>Y</span>
    <span style='color: #39FF14;'>G</span>
    <span style='color: blue;'>B</span>
    <span style='color: #4B0082;'>I</span>
    <span style='color: violet;'>V</span></b> 
    spectrum represents a continuum from more to fewer clicks on a place, given total number of clicks. 
    Number of clicks on a place &ge; 20 are displayed.</p>

  <p>Color saturation and area of blobs are dependent on concentration in a general area, irrespective of 
  regions drawn on a map, which can sometimes be inconsistent with quantification based on clicks in map regions.</p>

  <p><b>\"All Years\"</b> = Mostly first-year, second-year, third-year, fourth-year, and fifth-year 
  (i.e., 2021-22, 2020-21, 2019-20, 2018-19, and 2017-18 cohorts, respectively) US undergraduates contributed data, 
  along with a few <i>n-year</i> students (i.e., a few from 2002-03, 2007-08, 2010-11, 2011-12, 2014-15, and 2016-17 cohorts) 
  and US exchange undergraduates.</p>

  <p>See <a href='#supmeth' style='color: #DF63A4;'>Supplemental Method</a> for more details.</p>

  <p>Heat map was produced in Qualtrics (30px radius, 35px blur). Click counts were overlaid on the heat map image 
  using the <code>magick</code> package.</p>")
  })
  
  output$CampusTableCaption <- renderUI({
    HTML("<p><b>Note:</b> All columns are sortable. The default sorting is alphabetical order of <b>Aggregated Place</b> then <b>Place</b>. 
  The <b>Aggregated Place</b> column is searchable. Scroll right to see more metrics on the right side of the table. 
  Use the \"Show\" dropdown to elongate the table up to 100 rows. Click \"Previous,\" \"Next,\" or numbers between to move through pages.</p>

  <p>The table is hierarchically organized: <b>Place</b> within <b>Aggregated Place</b>. Click the triangle next to an <b>Aggregated Place</b> 
  to drop down its list of subordinate Places. Parentheses to the right of <b>Aggregated Place</b> names denote how many subordinate places 
  there are (1 = Aggregated Place and Place are identical).</p>

  <p>An <b>Aggregated Place</b> combines places in the <b>Place</b> column that are spatial (e.g., Lokey Science Complex) or conceptual (e.g., 
  University Housing) clusters of many places. Most aggregation is based on campus maps, but the Erb Memorial Union has its own maps and data collection. 
  Consequently, the <b>\"Erb Memorial Union\"</b> entry in the <b>Aggregated Place</b> column contains campus-level data, and the 
  <b>\"EMU-Specific Places\"</b> entry contains EMU-level data.</p>

  <p><span style='color: #11E8FF;'><b>Inclusive</b></span> is a percentage indicating how inclusive a place is and is computed by:  
  <i>n</i> Belong / (<i>n</i> Belong + <i>n</i> Don't Belong) * 100.</p>

  <p><span style='color: #49C1AD; font-style: italic'>n</span> <span style='color: #11E8FF'>Belong</span> and 
  <span style='color: #49C1AD; font-style: italic'>n</span> <span style='color: #11E8FF'>Don't Belong</span> are raw counts of how many clicks 
  a place accrued on the \"belong\" map or \"don't belong\" map, respectively.</p>

  <p><span style='color: #11E8FF;'><b>Click Belong</b></span> and <span style='color: #11E8FF;'><b>Click Don't Belong</b></span> are percentages indicating 
  the extent to which a place is considered somewhere students feel like they belong or don’t belong, respectively, relative to other places. 
  They are computed by dividing <i>n</i> Belong and <i>n</i> Don't Belong by the total number of Belong or Don't Belong clicks, respectively, and multiplying by 100.</p>

  <p><span style='color: #11E8FF;'><b>Student Belong</b></span> and <span style='color: #11E8FF;'><b>Student Don't Belong</b></span> are percentages indicating 
  the extent to which students agree that a place is somewhere they feel they belong or don’t belong, respectively. 
  They are computed by dividing <i>n</i> Belong and <i>n</i> Don't Belong by the total numbers of students who contributed data to those <i>n</i>s, respectively.</p>

  <p>In other words, <span style='color: #11E8FF;'><b>Inclusive</b></span>, <i>n</i> Belong, <i>n</i> Don't Belong, 
  <span style='color: #11E8FF;'><b>Click Belong</b></span>, and <span style='color: #11E8FF;'><b>Click Don't Belong</b></span> are all 
  <span style='color: #11E8FF;'><b>place-based metrics</b></span>, whereas <span style='color: #11E8FF;'><b>Student Belong</b></span> and 
  <span style='color: #11E8FF;'><b>Student Don't Belong</b></span> are <span style='color: #11E8FF;'><b>person-based metrics</b></span>.</p>

  <p>Because this overall table combines data from multiple academic years and because both places and methods have changed over the years, 
  there is some inaccuracy in representing some places. For example:</p>

  <ul>
    <li><b>Unthank Hall</b> did not exist before Spring 2022 data collection, so its metrics are likely underestimated.</li>
    <li><b>Lokey Science Complex</b> was disaggregated in map regions after Spring 2018. Thus, it appears as both an aggregated place and a subordinate 
    place (Spring 2018) with legitimate subordinate places that make up Lokey Science Complex (Spring 2019, Spring 2020, Spring 2022).</li>
  </ul>

  <p><b>Spring 2022:</b> Mostly first-year, second-year, third-year, fourth-year, and fifth-year (i.e., 2021-22, 2020-21, 2019-20, 2018-19, 
  and 2017-18 cohorts, respectively) US undergraduates contributed data, along with a few <i>n-year</i> students (i.e., a few from 2002-03, 
  2007-08, 2010-11, 2011-12, 2014-15, and 2016-17 cohorts) and US exchange undergraduates. <b>East Lawn</b> was mislabeled as <b>West Lawn</b>, 
  meaning there is no distinction between them.</p>

  <p><b>Spring 2020:</b> First-year, second-year, third-year, fourth-year, and fifth-year (i.e., 2019-20, 2018-19, 2017-18, 2016-17, and 
  2015-16 cohorts, respectively) US undergraduates contributed data.</p>

  <p><b>Spring 2019:</b> First-year, second-year, third-year, and fourth-year (i.e., 2018-19, 2017-18, 2016-17, and 2015-16 cohorts, respectively) 
  US undergraduates contributed data. <b>Baker</b> was mislabeled as <b>Barnhart</b>, meaning there is no distinction between them. 
  Additionally, no region was drawn for <b>Autzen Stadium</b>, so no click data exist for it.</p>

  <p><b>Spring 2018:</b> First-year, second-year, and third-year (i.e., 2017-18, 2016-17, and 2015-16 cohorts, respectively) 
  US undergraduates contributed data.</p>")
  })
  
  
  output$EmuMapCaption <- renderUI({
    HTML("<p><b>Note:</b> 
    <b><span style='color: red;'>R</span>
    <span style='color: orange;'>O</span>
    <span style='color: yellow;'>Y</span>
    <span style='color: #39FF14;'>G</span>
    <span style='color: blue;'>B</span>
    <span style='color: #4B0082;'>I</span>
    <span style='color: violet;'>V</span></b> 
    spectrum represents a continuum from more to fewer clicks on a place, given total number of clicks.</p>

  <p>Number of clicks on a place &ge; 20 are displayed.</p>

  <p>Color saturation and area of blobs are dependent on concentration in a general area, 
  irrespective of regions drawn on a map, which can sometimes be inconsistent with quantification based on clicks in map regions.</p>

  <p><b>\"All Years\"</b> = Mostly first-year, second-year, third-year, fourth-year, and fifth-year 
  (i.e., 2021-22, 2020-21, 2019-20, 2018-19, and 2017-18 cohorts, respectively) US undergraduates contributed data, 
  along with a few <i>n-year</i> students (i.e., a few from 2002-03, 2007-08, 2010-11, 2011-12, 2014-15, and 2016-17 cohorts) 
  and US exchange undergraduates.</p>
  
  <b>Additionally, the Erb Memorial Union map in Spring 2019 consisted of two vertically stacked images.</b> 
  This produces blob distortion across images, and it results in invalid data; 
  although students were instructed to select up to 3, some selected more than 3 places. 
  For quantification of maps and other analyses, the first three recorded responses from these few students were used and the rest were discarded.<br><br>
      
  See <a href='#supmeth' style='color: #DF63A4'>Supplemental Method</a> for more details.
  Heat map was produced in Qualtrics (30px radius, 35px blur).
  Click counts were overlaid on the heat map image using the <code>magick</code> package.</p>")
  })
  
  output$AggBarCaption <- renderUI({
    HTML("Inclusiveness is a percentage indicating how inclusive a place is and is computed by:
           <br>
           <i>n</i> Belong / (<i>n</i> Belong + <i>n</i> Don't Belong) * 100.
           <br><br>
           <b>Yellow</b> represents the high end of the inclusiveness continuum, and <b>black</b> represents the low end.
           Color mapping to inclusiveness percentages follows the treemaps in the 'Disaggregated and Less Delimited' section
           and is thus variable across plots.
           <br><br>
           <b>'Aggregated'</b> = Some individual places were combined into larger places
           (e.g., residence halls into University Housing).
           <br>
           <b>'More Delimited'</b> = The criterion for inclusion of a place in a plot was
           &ge; 0.1 of the total proportion of clicks, where total proportion of clicks
           was defined as the total number of clicks on a place divided by the
           average of the total number of clicks across all places.
           This is a stricter criterion than that used in 'Less Delimited.'
           <br><br>
           Clicks on Lawn, Other, and Out of Bounds regions were omitted before computing the total proportion of clicks.
           <br><br>
           <b>Spring 2022:</b>
           Mostly first-year, second-year, third-year, fourth-year, and fifth-year
           (i.e., 2021-22, 2020-21, 2019-20, 2018-19, and 2017-18 cohorts, respectively)
           US undergraduates contributed data, along with a few n-year students
           (i.e., from 2002-03, 2007-08, 2010-11, 2011-12, 2014-15, and 2016-17 cohorts)
           and US exchange undergraduates.
           <br><br>
           <b>Spring 2020:</b>
           First-year, second-year, third-year, fourth-year, and fifth-year
           (i.e., 2019-20, 2018-19, 2017-18, 2016-17, and 2015-16 cohorts, respectively)
           US undergraduates contributed data.
           <br><br>
           <b>Spring 2019:</b>
           First-year, second-year, third-year, and fourth-year
           (i.e., 2018-19, 2017-18, 2016-17, and 2015-16 cohorts, respectively)
           US undergraduates contributed data.
           <br><br>
           <b>Spring 2018:</b>
           First-year, second-year, and third-year
           (i.e., 2017-18, 2016-17, and 2015-16 cohorts, respectively)
           US undergraduates contributed data.
         ")
  })
  
  output$DisaggTreeCaption <- renderUI({
    HTML("Note: Rectangle <span style='color: #11E8FF'>size</span> represents a place's overall <span style='color: #11E8FF'>popularity</span>, 
           computed by <i>n</i> Belong + <i>n</i> Don't Belong.
           Rectangle <span style='color: #11E8FF'>color</span> represents a place's <span style='color: #11E8FF'>inclusiveness</span>,
           which is a percentage indicating how inclusive a place is and is computed by:
           <br>
           <i>n</i> Belong / (<i>n</i> Belong + <i>n</i> Don't Belong) * 100.
           <br><br>
           <b>Yellow</b> represents the high end of the inclusiveness continuum, and <b>black</b> represents the low end.
           <span style='color: gray;'>Gray text</span> represents inclusiveness &gt; 75%.
           <br><br>
           <b>'Disaggregated'</b> = Nothing was done to combine individual places into larger places
           (e.g., residence halls into University Housing).
           <b>'Less Delimited'</b> = The criterion for inclusion in a treemap was a total click count of at least 20,
           which is less restrictive than the criterion used in 'More Delimited.'
           The criterion for presenting a treemap was at least 4 places represented.
           Additionally, all treemaps omit clicks on Lawn, Other, and Out of Bounds regions.
           <br><br>
           Some names of places with lower popularity were abbreviated to fit the text in their respective rectangles:
           <br>
           <span style='color: #11E8FF'><b>TF</b></span> = Turf Field,
           <span style='color: #11E8FF'><b>DS</b></span> = Duck Store,
           <span style='color: #11E8FF'><b>Barn</b></span> = Outdoor Program Barn,
           <span style='color: #11E8FF'><b>Cas</b></span> = Cascade,
           <span style='color: #11E8FF'><b>FAS</b></span> = Fine Art Studios,
           <span style='color: #11E8FF'><b>MNL</b></span> = Many Nations Longhouse,
           <span style='color: #11E8FF'><b>MS</b></span> = LERC Military Science,
           <span style='color: #11E8FF'><b>MNCH</b></span> = Museum of Natural and Cultural History,
           <span style='color: #11E8FF'><b>Moss</b></span> = Moss Street Children's Center,
           <span style='color: #11E8FF'><b>Fent</b></span> = Fenton,
           <span style='color: #11E8FF'><b>LLC</b></span> = Living Learning Center,
           <span style='color: #11E8FF'><b>Essl</b></span> = Esslinger,
           <span style='color: #11E8FF'><b>BCC</b></span> = Black Cultural Center,
           <span style='color: #11E8FF'><b>Mac</b></span> = McArthur Court,
           <span style='color: #11E8FF'><b>Saun Stad</b></span> = Saunders Stadium,
           <span style='color: #11E8FF'><b>Friend</b></span> = Friendly,
           <span style='color: #11E8FF'><b>TI</b></span> = Tennis Indoor,
           <span style='color: #49C1AD'><b>PLC</b></span> = Prince Lucien Campbell.
           <br><br>
           Because this overall treemap combines data from multiple academic years,
           and because both places and methods have changed over time,
           there is some inaccuracy in representing popularity and inclusiveness
           (treemaps within academic years are accurate; however,
           due to limited data, the overall treemap for international students remains accurate despite combining data).
           <br><br>
           For example, Unthank Hall did not exist before Spring 2022 data collection,
           and Lokey Science Complex was disaggregated in map regions after Spring 2018.
           Thus, Unthank's popularity is likely underestimated,
           and its inclusiveness may be as well.
           Lokey Science Complex (Spring 2018) is depicted on the treemap along with its disaggregated components from later years.
           <br><br>
           <b>Spring 2022:</b>
           Mostly first-year, second-year, third-year, fourth-year, and fifth-year
           (i.e., 2021-22, 2020-21, 2019-20, 2018-19, and 2017-18 cohorts, respectively)
           US undergraduates contributed data, along with a few n-year students
           (i.e., from 2002-03, 2007-08, 2010-11, 2011-12, 2014-15, and 2016-17 cohorts) and US exchange undergraduates.
           <br>
           <span style='color: red;'><b>East Lawn was mislabeled as West Lawn</b></span>.
           There is no distinction between East and West Lawns.
           <br><br>
           <b>Spring 2020:</b>
           First-year, second-year, third-year, fourth-year, and fifth-year
           (i.e., 2019-20, 2018-19, 2017-18, 2016-17, and 2015-16 cohorts, respectively)
           US undergraduates contributed data.
           <br><br>
           <b>Spring 2019:</b>
           First-year, second-year, third-year, and fourth-year
           (i.e., 2018-19, 2017-18, 2016-17, and 2015-16 cohorts, respectively)
           US undergraduates contributed data.
           <br>
           <span style='color: red;'><b>Baker was mislabeled as Barnhart</b></span>.
           There is no distinction between Baker and Barnhart.
           Additionally, no region was drawn for Autzen Stadium;
           therefore, no click data exist for Autzen.
           <br><br>
           <b>Spring 2018:</b>
           First-year, second-year, and third-year
           (i.e., 2017-18, 2016-17, and 2015-16 cohorts, respectively)
           US undergraduates contributed data.")
  }
  )
  
  output$EmuTreeCaption <- renderUI({
    HTML("Note: Rectangle <span style='color: #11E8FF'>size</span> represents a place's overall <span style='color: #11E8FF'>popularity</span>,
           computed by <i>n</i> Belong + <i>n</i> Don't Belong.
           <br>
           Rectangle <span style='color: #11E8FF'>color</span> represents a place's <span style='color: #11E8FF'>inclusiveness</span>,
           which is a percentage indicating how inclusive a place is and is computed by:
           <br>
           <i>n</i> Belong / (<i>n</i> Belong + <i>n</i> Don't Belong) * 100.
           <br><br>
           <b>Yellow</b> represents the high end of the inclusiveness continuum, and <b>black</b> represents the low end.
           <span style='color: gray;'>Gray text</span> represents inclusiveness &gt; 75%.
           <br><br>
           The criterion for inclusion of a place in the treemap was a total click count of at least 20.
           The criterion for presenting a treemap was at least 4 places represented.
           Additionally, all treemaps omit clicks on 'Other' and 'Out of Bounds' regions.
           <br><br>
           <b>Abbreviations:</b>
           <b>SSC</b> = Student Sustainability Center
           <b>Hallway 1</b> = The East wing hallway on level 1 that runs in front of the Multicultural Center
           <b>Hallway 2</b> = The East wing hallway on level 2 that runs in front of the Center for Student Involvement Resource Center and the Redwood Auditorium
           <br><br>
           Because this overall treemap combines data from multiple academic years,
           and because both places and methods have changed over time,
           there is some inaccuracy in representing popularity and inclusiveness
           (treemaps within academic years are accurate).
           <br><br>
           <b>Spring 2022:</b>
           Mostly first-year, second-year, third-year, fourth-year, and fifth-year
           (i.e., 2021-22, 2020-21, 2019-20, 2018-19, and 2017-18 cohorts, respectively)
           US undergraduates contributed data, along with a few n-year students
           (i.e., from 2002-03, 2007-08, 2010-11, 2011-12, 2014-15, and 2016-17 cohorts)
           and US exchange undergraduates.
           <br><br>
           <b>Spring 2020:</b>
           First-year, second-year, third-year, fourth-year, and fifth-year
           (i.e., 2019-20, 2018-19, 2017-18, 2016-17, and 2015-16 cohorts, respectively)
           US undergraduates contributed data.
           <br><br>
           <b>Spring 2019:</b>
           First-year, second-year, third-year, and fourth-year
           (i.e., 2018-19, 2017-18, 2016-17, and 2015-16 cohorts, respectively)
           US undergraduates contributed data.
           <br><br>
           <b>Spring 2018:</b>
           First-year, second-year, and third-year
           (i.e., 2017-18, 2016-17, and 2015-16 cohorts, respectively)
           US undergraduates contributed data.")
  }
  )
  
  output$CloudCaption <- renderUI({
    HTML("<p><b>Note:</b> Word <span style='color: #11E8FF; font-weight: bold;'>size</span> represents 
  <span style='color: #11E8FF; font-weight: bold;'>frequency</span> of keyword occurrence.</p>

  <p><span style='color: #11E8FF; font-weight: bold;'>Hover over</span> words to see frequencies.</p>

  <p>The criterion for inclusion of a keyword in the wordcloud was occurrence &gt; 1.</p>

  <p>If a word seems negatively valenced, it was very likely negated 
  (e.g., preceded by the word \"not\").</p>

  <p>Because analyses combine data from multiple academic years, some students contributed data more than once.</p>

  <p><span style='color: #11E8FF; font-weight: bold;'>Across all places that were not subsequently aggregated 
  into superordinate places and then disaggregated by subordinate places</span> 
  (i.e., not Erb Memorial Union, Lokey Science Complex, or University Housing) 
  <span style='color: #11E8FF; font-weight: bold;'>as well as across sentiments</span> 
  (i.e., \"belong\" and \"don't belong\"), most students contributed to only one wave of data collection, 
  relatively few students contributed to two waves, and no one contributed to three waves.</p>

  <p>See <a href='#supmeth' style='color: #DF63A4'>Supplemental Method</a> for more details.</p>

  <p>Text data were annotated using the <code>udpipe</code> package.</p>

  <p>Keywords were extracted using the <b>Rapid Keyword Extraction (RAKE) algorithm</b> 
  (<a href='https://uoregon-my.sharepoint.com/:b:/g/personal/clark13_uoregon_edu/Eda0fgvF1VJAn2PPEU3c0xIBTrkNJIEnzOUzQhz6zaT5IA?e=FeHDYB' target='_blank' style='color: #DF63A4;'>Rose et al., 2010</a>).</p>

  <p>Wordcloud was generated using the <code>wordcloud2</code> package.</p>

  <p>Colors were produced using the <code>rocket</code> palette of the <code>viridis</code> package.</p>")
  })
  
  output$NetCaption <- renderUI({
    HTML("<p><b>Note:</b> Wordnet = adjacent (&le; 1 word apart) adjective-noun bigrams visualized as a network.</p>

  <p>Line <span style='color: #11E8FF; font-weight: bold;'>thickness</span> represents 
  <span style='color: #11E8FF; font-weight: bold;'>frequency</span> of co-occurrence.</p>

  <p>If a word seems negatively valenced, it was very likely negated 
  (e.g., preceded by the word \"not\").</p>

  <p><span style='color: #11E8FF; font-weight: bold;'>Generally</span>, 
  US undergraduates of all years/cohorts (mostly 1st-through-4th-year and predominantly first-year) 
  contributed data in <code>r ayrs_cam</code>. Because analyses combine data from multiple academic years, 
  some students contributed data more than once.</p>

  <p><span style='color: #11E8FF; font-weight: bold;'>Across all places that were not subsequently 
  aggregated into superordinate places and then disaggregated by subordinate places</span> 
  (i.e., not Erb Memorial Union, Lokey Science Complex, or University Housing) 
  <span style='color: #11E8FF; font-weight: bold;'>as well as across sentiments</span> 
  (i.e., \"belong\" and \"don't belong\"), most students contributed to only one wave of data collection.</p>

  <p>See <a href='#supmeth' style='color: #DF63A4'>Supplemental Method</a> for more details.</p>

  <p>Text data were annotated using the <code>udpipe</code> package.</p>
  
  <p>Wordnet was generated using the <code>ggraph</code> and <code>igraph</code> packages.</p>
  
  <p>Colors were produced using the <code>rocket</code> palette of the <code>viridis</code> package.</p>")
  })
  
  output$EmotionCaption <- renderUI({
    HTML("<p><b>Note:</b> Emotions are presented in rank order from most to least prevalent.</p>

  <p><b>Percentage</b> = the percentage of all eligible words classified as being representative of one of eight emotions 
  (anger, anticipation, disgust, fear, joy, sadness, surprise, trust), based on 
  <a href='https://doi.org/10.1177/053901882021004003' target='_blank' style='color: #DF63A4;'>Plutchik's psychoevolutionary theory of emotion</a> 
  (<a href='#f1' style='color: #DF63A4;'>Figure 1</a>).</p>

  <p>The threshold for the minimum number of responses was 20.</p>

  <p>Because analyses combine data from multiple academic years, some students contributed data more than once.</p>

  <p><span style='color: #11E8FF; font-weight: bold;'>Across all places that were not subsequently aggregated into superordinate places 
  and then disaggregated by subordinate places</span> (i.e., not Erb Memorial Union, Lokey Science Complex, or University Housing) 
  <span style='color: #11E8FF; font-weight: bold;'>as well as across sentiments</span> (i.e., \"belong\" and \"don't belong\"), 
  most students contributed to only one wave of data collection, relatively few students contributed to two waves, 
  and no one contributed to three waves.</p>

  <p>See <a href='#supmeth' style='color: #DF63A4;'>Supplemental Method</a> for more details.</p>

  <p>Text was annotated using the <code>tidytext</code> package.</p>

  <p>The <code>nrc</code> lexicon 
  (<a href='https://arxiv.org/pdf/1308.6297.pdf' target='_blank' style='color: #DF63A4;'>Mohammad & Turney, 2013</a>) 
  was used to classify emotional content.</p>

  <p>Bar plot was generated using the <code>ggplot2</code> package.</p>

  <p>Colors were produced using the <code>rocket</code> palette of the <code>viridis</code> package.</p>")
  })

#########################################    
  ## Filters ## 
  
  ## Campus Belonging
  # Heat Maps
  
  # Type Select Campus
  output$typeSelectCampus <- renderUI({
    selectInput("typeSelectCampus", "Select Type:", choices = c("Undergraduate", "International", "Graduate"),
                selected = "Undergraduate")
  })
  
  # Year Select Campus
  output$yearSelectCampus <- renderUI({
    req(input$typeSelectCampus)
    if (input$typeSelectCampus == "Undergraduate") {
      selectInput("yearSelectCampus", "Select Year:", choices = c("2017", "2018", "2019", "2020", "2022", "Overall"))
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
  
  
  ## EMU Belonging 
  # Heat Maps
  
  # Type Select EMU
  output$typeSelectEmu <- renderUI({
    selectInput("typeSelectEmu", "Select Type:", choices = c("Undergraduate", "International", "Graduate"), 
                selected = "Undergraduate")
  })
  
  # Year Select EMU
  output$yearSelectEmu <- renderUI({
    req(input$typeSelectEmu)
    if (input$typeSelectEmu == "Undergraduate") {
      selectInput("yearSelectEmu", "Select Year:", choices = c("2018", "2019", "2020", "2022", "Overall"))
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
  
  
  
  # Wordcloud & Wordnet filters
  
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
    req(input$placeSelect)  # Ensure a place is selected
    
    if (input$typeSelectWords == "Undergraduate") {
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
    }
    else if (input$typeSelectWords == "International" && input$placeSelect == "Erb Memorial Union (EMU)") {
      # Special case: International students only get "Overall" and "Mills Center" for EMU
      selectInput("place2Select", "Select Location:", 
                  choices = c("Overall", "Mills Center"))
    }
  })
  
  observe({
    req(input$typeSelectWords, input$placeSelect)  # Ensure both inputs are available
    
    if (input$typeSelectWords == "International" && input$placeSelect == "Erb Memorial Union (EMU)") {
      # If International selects EMU, ensure place2Select defaults to "Overall" if not set
      if (is.null(input$place2Select)) {
        updateSelectInput(session, "place2Select", selected = "Overall")
      }
    } else if (input$typeSelectWords %in% c("International", "Graduate")) {
      # Ensure "Overall" is assigned but place2Select is NOT visible for Graduate students
      updateSelectInput(session, "place2Select", selected = "Overall")
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
    
    img_path <- "www/Nothing_to_see.png"  
    
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
    } else if (!is.null(type) && !is.na(type) && type == "International") {
      
      # International doesn't have any tree maps available
      grid::grid.raster(png::readPNG(img_path))
      grid::grid.text("Insufficient data for International tree map to display", 
                      gp = grid::gpar(fontsize = 20, col = "black"), 
                      y = 0.1, just = "bottom")
      return(NULL)
    } else if (!is.null(type) && !is.na(type) && type == "Graduate") {
      
      # Graduate doesn't have any tree maps available
      grid::grid.raster(png::readPNG(img_path))
      grid::grid.text("Insufficient data for Graduate tree map to display", 
                      gp = grid::gpar(fontsize = 20, col = "black"), 
                      y = 0.1, just = "bottom")
      return(NULL)
    }
    
    # Render the tree map if data exists
    if (!is.null(data)) {
      inclusive_tree_fun(data)
    } else {
      
      # Fallback: No data available, show "Nothing to See" image
      grid::grid.raster(png::readPNG(img_path))
      grid::grid.text(paste("Insufficient data for", type, year, cohort,"to display"), 
                      gp = grid::gpar(fontsize = 20, col = "black"), 
                      y = 0.1, just = "bottom")
    }
  }
  
  # Render tree maps for EMU
  output$emuTree <- renderPlot({
    req(input$locationSelect == 'EMU Student Union')
    renderEmuTree(input$typeSelectEmuTreeMap, input$yearSelectEmuTreeMap, input$cohortSelectEmuTreeMap)
  })
  
  
  ## Reactable Tables: 
  # Reactable Table for Campus Maps
  output$tableCampus <- renderReactable({
    
    # Ensure inputs are available (A chhatGPT fix to handle null inputs)
    if (is.null(input$typeSelectCampus) || is.null(input$yearSelectCampus) || is.null(input$cohortSelectCampus)) return()
    
    # Initialize variables
    table_to_display <- NULL
    year <- input$yearSelectCampus
    cohort <- input$cohortSelectCampus
    type <- input$typeSelectCampus
    
    # Mapping years
    year_map <- list("2018" = "1718", "2019" = "1819", "2020" = "1920", "2022" = "2122")
    
    # Helper function to create table name
    create_table_name <- function(type, year, cohort) {
      mapped_year <- year_map[[year]]
      if (is.null(mapped_year)) return(NULL)
      
      if (cohort == "All Cohorts" || cohort == "No cohort available") {
        return(paste0("rt_", type, "_ay", mapped_year))
      } else {
        cohort <- gsub("/", "", cohort)
        return(paste0("rt_", type, "_ay", mapped_year, "_c", cohort))
      }
    }
    
    # Determine the table to display
    if (type == "Undergraduate") {
      if (year == "Overall") {
        table_to_display <- reactable_fun(rt_us_ug)
      } else {
        table_name <- create_table_name("us_ug", year, cohort)
        table_to_display <- tryCatch({ reactable_fun(get(table_name)) }, error = function(e) { NULL })
      }
    } else if (type == "International") {
      if (year == "Overall") {
        table_to_display <- reactable_fun(rt_i)
      } else if (year == "Undergrad 2020") {
        table_to_display <- reactable_fun(rt_i_ug_ay1920)
      } else if (year == "2022") {
        table_to_display <- reactable_fun(rt_i_ay2122)
      }
    } else if (type == "Graduate" && year == "2022") {
      table_to_display <- reactable_fun(rt_gr_ay2122)
    }
    
    # Render the table or a message if no data is available
    if (!is.null(table_to_display)) {
      table_to_display
    } else {
      HTML("<p>No data available for the selected options.</p>")
    }
  })
  
  
  ## Reactable Tables: 
  # Reactable Tables for EMU
  output$tableEmu <- renderReactable({
    # Ensure inputs are available
    if (is.null(input$typeSelectEmu) || is.null(input$yearSelectEmu) || is.null(input$cohortSelectEmu)) return()
    
    # Initialize variables
    table_to_display <- NULL
    year <- input$yearSelectEmu
    cohort <- input$cohortSelectEmu
    type <- input$typeSelectEmu
    
    # Mapping years
    year_map <- list("2018" = "1718", "2019" = "1819", "2020" = "1920", "2022" = "2122")
    
    # Helper function to create table name
    create_table_name <- function(type, year, cohort) {
      mapped_year <- year_map[[year]]
      if (is.null(mapped_year)) return(NULL)
      
      if (cohort == "All Cohorts" || cohort == "No cohort available") {
        return(paste0("rt_", type, "_ay", mapped_year))
      } else {
        cohort <- gsub("/", "", cohort)
        return(paste0("rt_", type, "_ay", mapped_year, "_c", cohort))
      }
    }
    
    # Determine the table to display
    if (type == "Undergraduate") {
      if (year == "Overall") {
        table_to_display <- reactable_fun(pbb_tables_for_rt$us_ug)
      } else {
        table_name <- create_table_name("us_ug", year, cohort)
        table_to_display <- tryCatch({ reactable_fun(pbb_tables_for_rt[[table_name]]) }, error = function(e) { NULL })
      }
    } else if (type == "International") {
      if (year == "Overall") {
        table_to_display <- reactable_fun(pbb_tables_for_rt$i)
      } else if (year == "Undergrad 2020") {
        table_to_display <- reactable_fun(pbb_tables_for_rt$i_ug_ay1920)
      } else if (year == "2022") {
        table_to_display <- reactable_fun(pbb_tables_for_rt$i_ay2122)
      }
    } else if (type == "Graduate" && year == "2022") {
      table_to_display <- reactable_fun(pbb_tables_for_rt$gr_ay2122)
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
      if (year == "Overall") {
        image_src_belonging <- "map_emu_b_us_ug.png"
      } else {
        mapped_year <- switch(year, "2018" = "1718", "2019" = "1819", "2020" = "1920", "2022" = "2122")
        cohort <- input$cohortSelectEmu
        if (cohort == "All Cohorts" || cohort == "No cohort available") {
          image_src_belonging <- paste0("map_emu_b_us_ug_ay", mapped_year, ".png")
        } else {
          cohort <- gsub("/", "", cohort)
          image_src_belonging <- paste0("map_emu_b_us_ug_ay", mapped_year, "_c", cohort, ".png")
        }
      }
    } else if (input$typeSelectEmu == "International") {
      if (input$yearSelectEmu == "Overall") {
        image_src_belonging <- "map_emu_b_i.png"
      } else if (input$yearSelectEmu == "Undergrad 2020") {
        image_src_belonging <- "map_emu_b_i_ug_ay1920.png"
      } else if (input$yearSelectEmu == "Undergrad & Grad 2022") {
        image_src_belonging <- "map_emu_b_i_ay2122.png"
      }
    } else if (input$typeSelectEmu == "Graduate" && input$yearSelectEmu == "2022") {
      image_src_belonging <- "map_emu_b_gr_ay2122.png"
    }
    
    if (image_src_belonging %in% available_maps) {
      img(src = paste0(base_path, image_src_belonging), height = "600px", style = "margin-bottom: 20px; padding-right: 20px;")
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
      if (year == "Overall") {
        image_src_not_belonging <- "map_emu_db_us_ug.png"
      } else {
        mapped_year <- switch(year, "2018" = "1718", "2019" = "1819", "2020" = "1920", "2022" = "2122")
        cohort <- input$cohortSelectEmu
        if (cohort == "All Cohorts" || cohort == "No cohort available") {
          image_src_not_belonging <- paste0("map_emu_db_us_ug_ay", mapped_year, ".png")
        } else {
          cohort <- gsub("/", "", cohort)
          image_src_not_belonging <- paste0("map_emu_db_us_ug_ay", mapped_year, "_c", cohort, ".png")
        }
      }
    } else if (input$typeSelectEmu == "International") {
      if (input$yearSelectEmu == "Overall") {
        image_src_not_belonging <- "map_emu_db_i.png"
      } else if (input$yearSelectEmu == "Undergrad 2020") {
        image_src_not_belonging <- "map_emu_db_i_ug_ay1920.png"
      } else if (input$yearSelectEmu == "Undergrad & Grad 2022") {
        image_src_not_belonging <- "map_emu_db_i_ay2122.png"
      }
    } else if (input$typeSelectEmu == "Graduate" && input$yearSelectEmu == "2022") {
      image_src_not_belonging <- "map_emu_db_gr_ay2122.png"
    }
    
    if (image_src_not_belonging %in% available_maps) {
      img(src = paste0(base_path, image_src_not_belonging), height = "600px", style = "margin-bottom: 20px; padding-right: 20px;")
    } else {
      tags$p("No 'Don't Belong' map available for the selected options.")
    }
  })
  
  addPopover(session, id = "notBelongingMapEmu", title = "EMU Don't Belong Map", 
             content = "Number equals the number of clicks. Color equals density of clicks.", 
             trigger = "hover", placement = "right", options = list(container = "body"))
  
  
  ## Heat Maps:
  # Heat Maps for Campus
  # Belonging Map
  output$belongingMapCampus <- renderUI({
    req(input$typeSelectCampus, input$yearSelectCampus, input$cohortSelectCampus)
    base_path <- "maps/"
    image_src_belonging <- ""
    
    if (input$typeSelectCampus == "Undergraduate") {
      year <- input$yearSelectCampus
      if (year == "Overall") {
        image_src_belonging <- "map_cam_b_us_ug.png"
      } else {
        mapped_year <- switch(year, "2017" = "1617", "2018" = "1718", "2019" = "1819", "2020" = "1920", "2022" = "2122")
        cohort <- input$cohortSelectCampus
        if (cohort == "All Cohorts" || cohort == "No cohort available") {
          image_src_belonging <- paste0("map_cam_b_us_ug_ay", mapped_year, ".png")
        } else {
          cohort <- gsub("/", "", cohort)
          image_src_belonging <- paste0("map_cam_b_us_ug_ay", mapped_year, "_c", cohort, ".png")
        }
      }
    } else if (input$typeSelectCampus == "International") {
      if (input$yearSelectCampus == "Overall") {
        image_src_belonging <- "map_cam_b_i.png"
      } else if (input$yearSelectCampus == "Undergrad 2020") {
        image_src_belonging <- "map_cam_b_i_ug_ay1920.png"
      } else if (input$yearSelectCampus == "Undergrad & Grad 2022") {
        image_src_belonging <- "map_cam_b_i_ay2122.png"
      }
    } else if (input$typeSelectCampus == "Graduate" && input$yearSelectCampus == "2022") {
      image_src_belonging <- "map_cam_b_gr_ay2122.png"
    }
    
    if (image_src_belonging %in% available_maps) {
      img(src = paste0(base_path, image_src_belonging), height = "600px", style = "margin-bottom: 20px; padding-right: 20px;")
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
      if (year == "Overall") {
        image_src_not_belonging <- "map_cam_db_us_ug.png"
      } else {
        mapped_year <- switch(year, "2017" = "1617", "2018" = "1718", "2019" = "1819", "2020" = "1920", "2022" = "2122")
        cohort <- input$cohortSelectCampus
        if (cohort == "All Cohorts" || cohort == "No cohort available") {
          image_src_not_belonging <- paste0("map_cam_db_us_ug_ay", mapped_year, ".png")
        } else {
          cohort <- gsub("/", "", cohort)
          image_src_not_belonging <- paste0("map_cam_db_us_ug_ay", mapped_year, "_c", cohort, ".png")
        }
      }
    } else if (input$typeSelectCampus == "International") {
      if (input$yearSelectCampus == "Overall") {
        image_src_not_belonging <- "map_cam_db_i.png"
      } else if (input$yearSelectCampus == "Undergrad 2020") {
        image_src_not_belonging <- "map_cam_db_i_ug_ay1920.png"
      } else if (input$yearSelectCampus == "Undergrad & Grad 2022") {
        image_src_not_belonging <- "map_cam_db_i_ay2122.png"
      }
    } else if (input$typeSelectCampus == "Graduate" && input$yearSelectCampus == "2022") {
      image_src_not_belonging <- "map_cam_db_gr_ay2122.png"
    }
    
    if (image_src_not_belonging %in% available_maps) {
      img(src = paste0(base_path, image_src_not_belonging), height = "600px", style = "margin-bottom: 20px; padding-right: 20px;")
    } else {
      tags$p("No 'Don't Belong' map available for the selected options.")
    }
  }
  )
  
  addPopover(session, id = "notBelongingMapCampus", title = "Campus Don't Belong Map", 
            content = "Number equals the number of clicks. Color equals density of clicks.", 
            trigger = "hover", placement = "right", options = list(container = "body"))
  
  
  
  ## Word Nets & Word Clouds
  
  observeEvent(input$placeSelect, {
    # Reset the sub-location (place2Select) to "Overall" only if the previous building was EMU, Lokey, or University Housing
    if (input$placeSelect %in% c("Erb Memorial Union (EMU)", "Lokey Science Complex", "University Housing")) {
      updateSelectInput(session, "place2Select", selected = "Overall")
    } else {
      # For buildings without sub-locations, we can hide or disable the sub-location input if needed
      updateSelectInput(session, "place2Select", selected = NULL)
    }
  })
  
  output$wordCloudImage <- renderImage({
    req(input$typeSelectWords, input$placeSelect, input$belongStatus)  
    
    student_group <- switch(input$typeSelectWords,
                            "Undergraduate" = "us_ug",
                            "International" = "i",
                            "Graduate" = "gr")
    
    building_name <- location_file_name_map[[input$placeSelect]] 
    building_name <- tolower(building_name)  
    
    if (!is.null(input$place2Select) && input$place2Select != "Overall" && input$placeSelect %in% c("Erb Memorial Union (EMU)", "Lokey Science Complex", "University Housing")) {
      sub_location_mapped <- location_file_name_map[[input$place2Select]]
      if (!is.null(sub_location_mapped)) {
        building_name <- tolower(sub_location_mapped)
      } else {
        building_name <- tolower(gsub(" ", "_", input$place2Select))
      }
    }
    
    # Construct the file path
    file_name <- paste0("wc_", building_name, "_", input$belongStatus, "_", student_group, ".png")
    
    # Define the full path to the image directory (in 'www/wordclouds')
    full_image_path <- file.path(getwd(), "code", "www", "wordclouds", file_name)
    
    # Placeholder image when no word cloud is available
    no_data_image_path <- file.path(getwd(), "code", "www", "Nothing_to_see.png")
    
    # Check if the file exists for the selected belong status
    if (file.exists(full_image_path)) {
      return(list(
        src = full_image_path, 
        alt = paste("Word cloud for", input$place2Select, input$placeSelect, input$typeSelectWords, input$belongStatus),
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
  
  output$wordNetImage <- renderImage({
    req(input$typeSelectWords, input$placeSelect, input$belongStatus)  
    
    student_group <- switch(input$typeSelectWords,
                            "Undergraduate" = "us_ug",
                            "International" = "i",
                            "Graduate" = "gr")
    
    building_name <- location_file_name_map[[input$placeSelect]]
    building_name <- tolower(building_name)
    
    if (!is.null(input$place2Select) && input$place2Select != "Overall" && input$placeSelect %in% c("Erb Memorial Union (EMU)", "Lokey Science Complex", "University Housing")) {
      sub_location_mapped <- location_file_name_map[[input$place2Select]]
      if (!is.null(sub_location_mapped)) {
        building_name <- tolower(sub_location_mapped)
      } else {
        building_name <- tolower(gsub(" ", "_", input$place2Select))
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
        alt = paste("Word net for", input$place2Select, input$placeSelect, input$typeSelectWords, input$belongStatus),
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
    
    building_name <- location_file_name_map[[input$buildingSelect]] 
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
