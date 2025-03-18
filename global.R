# Explicitly define the package list before using it
# List of required packages
# packages <- c("shiny", "reactable", "htmltools",
#               "treemapify", "tidyverse", "rvest",
#               "leaflet.extras", "shinydashboard",
#               "shinycssloaders", "here", "reticulate",
#               "markdown", "fastmap", "bslib", "shinyBS", "farver",
#               "labeling", "crayon", "cli", "viridisLite",
#               "remotes", "fastmap", "conflicted",
#               "rsconnect", "wordcloud2", "ggrepel", "plotly", "terra", "sf")
# 
# # Install missing packages
# missing_packages <- setdiff(packages, rownames(installed.packages()))
# if (length(missing_packages) > 0) {
#   install.packages(missing_packages, dependencies = TRUE)
# }
# 
# # Load all packages
# invisible(lapply(packages, function(pkg) {
#   suppressMessages(library(pkg, character.only = TRUE))
# }))


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
# library(reticulate)
library(markdown)
library(bslib)
library(fastmap)
## New Addition for Shiny features
# library(bslib)
#library(shinyalert)
library(shinyBS)
library(farver)
library(labeling)
library(crayon)
library(cli)
library(rsconnect)
library(remotes)
library(conflicted)
library(plotly)
library(ggrepel)
library(terra)
library(sf)
library(wordcloud2)


#######################


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
#     rsconnect::serverInfo(),
#     plotly::layout()
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

