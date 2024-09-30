
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

inclusive_tree_fun <- function(dat) {
  df <- dat
  cp <- as.vector(if_else(df$incl > 75, "#30313A", "#FCFFA4"))
  plot <- dat %>%
    ggplot(aes(area = tot, fill = incl, label = place)) +
    geom_treemap() +
    geom_treemap_text(place = "center", grow = TRUE, reflow = TRUE, color = cp) +
    scale_fill_viridis_c(name = "Inclusiveness", option = "inferno", limits = c(0, 100)) +
    theme(
      panel.background = element_rect(fill = "#30313A"),
      plot.background = element_rect(color = "#30313A", fill = "#30313A"),
      legend.background = element_rect(fill = "#30313A"),
      legend.title = element_text(color = "#FCFFA4"),
      legend.text = element_text(color = "#FCFFA4"),
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
