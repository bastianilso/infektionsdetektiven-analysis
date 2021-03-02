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
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    
    includeCSS("custom.css"),
    useShinyjs(),
    fluidRow(
        column(8, titlePanel("Infektionsdetektiven Analysis")),
        column(4,
               column(11,style = "margin-top : 20px; text-align: center;",
                      selectInput("versionSelect", NULL, choices=c("Loading.." = -1))
               )
        )
    ),
    fluidRow(
        column(12, checkboxGroupInput("pidChooser", label = "Loading...", choices = NULL, inline = TRUE))
    ),

    tabsetPanel(id = "subjectChooser", type = "tabs",
        tabPanel(value  = "gameplay", id = "gameplayPan", strong("GamePlay"),
                 navlistPanel(
                     widths = c(4, 8),
                     "Choose Visualization:",
                     tabPanel("Levels Completed",
                              plotlyOutput("levelscompletePlot"),
                              tags$div(class = "vizcontrols-explainer")
                     ),
                     tabPanel("Rating",
                              plotlyOutput("ratingPlot"),
                              tags$div(class = "vizcontrols-explainer")
                     ),
                     tabPanel("NumberOfRestarts",
                              plotlyOutput("restartPlot"),
                              tags$div(class = "vizcontrols-explainer")
                              
                     )
                 )
        )
    ),
    tags$footer()
))