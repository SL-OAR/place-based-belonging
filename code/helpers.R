
## Functions

#### Rendering reactable tables ###
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



#### Tree map function ###

# inclusive_tree_fun <- function(dat) {
#   df <- dat
#   cp <- as.vector(if_else(df$incl > 75, "#30313A", "#FCFFA4"))
#   plot <- dat %>%
#     ggplot(aes(area = tot, fill = incl, label = place)) +
#     geom_treemap() +
#     geom_treemap_text(place = "center", grow = TRUE, reflow = TRUE, color = cp) +
#     scale_fill_viridis_c(name = "Inclusiveness", option = "inferno", limits = c(0, 100)) +
#     theme(
#       panel.background = element_rect(fill = "#30313A"),
#       plot.background = element_rect(color = "#30313A", fill = "#30313A"),
#       legend.background = element_rect(fill = "#30313A"),
#       legend.title = element_text(color = "#FCFFA4"),
#       legend.text = element_text(color = "#FCFFA4"),
#       plot.margin = margin(0.5, 0.5, 0.5, 0.5, "cm")
#     )
#   return(plot)
# }

## UO Colors

uo_colors <- list(
  # Primary Colors
  green = "#154733",      # UO Green
  yellow = "#FEE123",     # UO Yellow
  
  # Secondary Colors - Greens
  legacy_green = "#004F27", # Legacy Green
  grass_green = "#518241",  # Grass Green
  lime_green = "#7BAE28",   # Lime Green
  chartreuse = "#9FD430",   # Chartreuse
  
  # Secondary Colors - Blues
  dark_blue = "#004D6C",    # Dark Blue
  light_blue = "#3F8EA8",   # Light Blue
  
  # Secondary Colors - Berry
  berry = "#820043",        # Berry
  
  # Secondary Colors - Grays
  dark_gray = "#2E2E2E",    # Dark Gray
  medium_gray = "#7C8487",  # Medium Gray
  light_gray = "#E6E7E8",   # Light Gray
  
  # Accent Colors
  pine = "#004225",         # Pine
  forest = "#0E4B33",       # Forest
  sage = "#899A75",         # Sage
  moss = "#D5DD98",         # Moss
  spring = "#A1D296",       # Spring
  blue = "#84A4CC",         # Blue
  tan = "#B3A369"          # Tan
  
  # color_scale = c("#D5DD98", "#FEE123", "#9FD430", "#004F27", "#004D6C", "#820043"), # Used for tree maps
  # 
  # color_scale_b = c("#D5DD98", "#A1D296", "#899A75", "#518241", "#9FD430", "#7BAE28", "#154733", "#004225"), # UO colors for b scheme
  # 
  # color_scale_db = c("#FEE123", "#D5DD98", "#B3A369", "#7C8487", "#84A4CC", "#3F8EA8", "#004D6C", "#820043"), # UO colors for db scheme
  # 
  # color_scale_b <- c("#D5DD98", "#A1D296", "#899A75", "#516841","#518241", "#9FD430", "#7BAF40", "#7BAE28", "#154733", "#004225"), # Expanded for donuts b
  # 
  # color_scale_db <- c("#FEE123", "#D5DD98", "#B3A369","#7C8467",, "#7C8487", "#84A4CC", "#3F8EA8", "#004D6C", "#824D78", "#820043") # Expanded for donuts db
)

# Tree Map Function using UO Approved Colors

inclusive_tree_fun <- function(dat) {
  df <- dat  # Store input data frame
  
  plot <- dat %>%
    ggplot(aes(area = tot, fill = incl, label = place)) +
    geom_treemap() +
    geom_treemap_text(aes(color = incl > 75, size = tot), place = "center", grow = TRUE, reflow = TRUE, fontface = "bold") +
    
    # Using UO Color Gradient (Moss -> UO Yellow -> Chartreuse -> UO Green -> Dark Blue -> Berry)
    scale_fill_gradientn(
      name = "Inclusiveness",
      colors = c("#D5DD98", "#FEE123", "#9FD430", "#004F27", "#004D6C", "#820043"),
      limits = c(0, 100)
    ) +
    
    #  Fix legend scaling (taller Y-axis)
    guides(fill = guide_colorbar(title.position = "top", barwidth = 1, barheight = 15)) +
    
    #  Adjust text colors
    scale_color_manual(values = c("#2E2E2E", "#D5DD98"), guide = "none") +
    
    # Scale text size dynamically
    scale_size_continuous(range = c(3, 8)) +  
    
    #I mprove legend styling
    theme(
      panel.background = element_rect(fill = "#2E2E2E"),
      plot.background = element_rect(color = "#2E2E2E", fill = "#2E2E2E"),
      legend.background = element_rect(fill = "#2E2E2E"),
      legend.title = element_text(color = "#D5DD98", size = 14, face = "bold"),
      legend.text = element_text(color = "#D5DD98", size = 12),
      legend.key.height = unit(2, "cm"),  #  Extend legend height
      legend.key.width = unit(0.75, "cm"),  #  Keep legend width small
      plot.margin = margin(0.5, 0.5, 0.5, 0.5, "cm")
    )
  
  return(plot)
}





### Break down inclusiveness functions so server is not crowded

### EMU Trees

renderEmuTree <- function(input) {
  if(input$typeSelect == "Undergraduate") {
    year <- input$yearSelect
    
    if(input$yearSelect == "Overall") {
      inclusive_tree_fun(emu_us_ug)
    } else if (input$yearSelect == "2022") {
      if(input$cohortSelect == "All Years") { 
        inclusive_tree_fun(emu_us_ug_ay2122)
      } else if(input$cohortSelect == "4th Year") { 
        inclusive_tree_fun(emu_us_ug_ay2122_c2122)
      } 
    } else if (input$yearSelect == "2020") {
      if(input$cohortSelect == "All Years") {
        inclusive_tree_fun(emu_us_ug_ay1920)
      } else if(input$cohortSelect == "4th Year") { 
        inclusive_tree_fun(emu_us_ug_ay1920_c1920)
      } else if(input$cohortSelect == "3rd Year") { 
        inclusive_tree_fun(emu_us_ug_ay1920_c1819)
      } 
    } else if (input$yearSelect == "2019") {
      if(input$cohortSelect == "All Years") {
        inclusive_tree_fun(emu_us_ug_ay1819)
      } else if(input$cohortSelect == "4th Year") { 
        inclusive_tree_fun(emu_us_ug_ay1819_c1819)
      } 
    } else if (input$yearSelect == "2018") {
      inclusive_tree_fun(emu_us_ug_ay1718)
    }
  } else {
    box(width = NULL, background = "black", "No data available for the selected options.")
  }
}

### Campus Trees

renderCampusTree <- function(input) {
  
  if(input$typeSelect == "Undergraduate") {
    year <- input$yearSelect
    if(input$yearSelect == "Overall") {
      inclusive_tree_fun(cam_us_ug)
    } else if (input$yearSelect == "2022") {
      if(input$cohortSelect == "All Years") { 
        inclusive_tree_fun(cam_us_ug_ay2122)
      } else if(input$cohortSelect == "4th Year") { 
        inclusive_tree_fun(cam_us_ug_ay2122_c2122)
      } else if(input$cohortSelect == "3rd Year") { 
        inclusive_tree_fun(cam_us_ug_ay2122_c2021)
      } else if(input$cohortSelect == "2nd Year") { 
        inclusive_tree_fun(cam_us_ug_ay2122_c1920)
      } else if(input$cohortSelect == "1st Year") { 
        inclusive_tree_fun(cam_us_ug_ay2122_c1819)
      }
    } else if (input$yearSelect == "2020") {
      if(input$cohortSelect == "All Years") {
        inclusive_tree_fun(cam_us_ug_ay1920)
      } else if(input$cohortSelect == "4th Year") { 
        inclusive_tree_fun(cam_us_ug_ay1920_c1920)
      } else if(input$cohortSelect == "3rd Year") { 
        inclusive_tree_fun(cam_us_ug_ay1920_c1819)
      } else if(input$cohortSelect == "2nd Year") { 
        inclusive_tree_fun(cam_us_ug_ay1920_c1718)
      } else if(input$cohortSelect == "1st Year") { 
        inclusive_tree_fun(cam_us_ug_ay1920_c1617)
      }
    } else if (input$yearSelect == "2019") {
      if(input$cohortSelect == "All Years") {
        inclusive_tree_fun(cam_us_ug_ay1819)
      } else if(input$cohortSelect == "4th Year") { 
        inclusive_tree_fun(cam_us_ug_ay1819_c1819)
      } else if(input$cohortSelect == "3rd Year") { 
        inclusive_tree_fun(cam_us_ug_ay1819_c1718)
      } else if(input$cohortSelect == "2nd Year") { 
        inclusive_tree_fun(cam_us_ug_ay1819_c1617)
      } else if(input$cohortSelect == "1st Year") { 
        inclusive_tree_fun(cam_us_ug_ay1819_c1516)
      }
    } else if (input$yearSelect == "2018") {
      inclusive_tree_fun(cam_us_ug_ay1718)
    }
  }
  # International
  else if(input$typeSelect == "International") {
    year <- input$yearSelect
    if (input$yearSelect == "Overall") {
      inclusive_tree_fun(cam_i)
    } else if (input$yearSelect == "Undergrad 2020") {
      inclusive_tree_fun(cam_i_ug_ay1920)
    }
  }
  # Graduate
  else if(input$typeSelect == "Graduate") {
    year <- input$yearSelect
    if (input$yearSelect == "2022") {
      inclusive_tree_fun(cam_gr_ay2122)
    } else if (input$yearSelect == "Overall") {
      box(width = NULL, background = "black", "No data available for the selected options.")
    }
  } else {
    HTML("<p>No data available for the selected options.</p>")
  }
}
