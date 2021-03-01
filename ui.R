#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(shinyjs)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    useShinyjs(debug=T),
    # Input ----------------
    fluidRow(
        column(4, titlePanel("Data Management")),
    ),
    fluidRow(
        column(2, data_selection_summary_UI("input_info")),
        column(3, actionButton("CsvButton","Manual Upload"),
                  actionButton("DbButton", "Change Data"))
    ),
    #  Output ----------------
    tabsetPanel(id = "dataTypeChooser", type = "tabs",
        tabPanel(value  = "Data", id = "Timeline", strong("Data"),
        ),
        # Rest of Page ---------------------------------------------------------------
        tags$footer()
    )
))