#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    connected = GetConnectedToServer()
    if (!connected) {
        auth <- read.csv("credentials.csv", header=TRUE,sep=",", colClasses=c("character","character","character","character"))
        connected = ConnectToServer(auth)
    }
    
    r <- reactiveValues(df = NULL, meta = NULL, source = NULL)
    
    
    db_data <- callModule(db_select, "selectData", connected)
    csv_data <- callModule(csv_upload, "uploadData")
    callModule(data_selection_summary,"input_info", reactive(r$df))
    
    observeEvent(csv_data$trigger, {
        req(csv_data$trigger > 0)
        r$df <- csv_data$df
        r$source <- 'csv data'
    })
    observeEvent(db_data$trigger, {
        req(db_data$trigger > 0)
        r$df <- db_data$df
        r$source <- db_data$session
    })
    
    observeEvent(input$CsvButton, {
        insertUI(selector = "#CsvButton", where = "afterEnd",
                 ui = showModal(modalDialog(csv_upload_UI("uploadData"), easyClose = TRUE)))
    })
    observeEvent(input$DbButton, {
        insertUI(selector = "#DbButton", where = "afterEnd",
                 ui = showModal(modalDialog(db_select_UI("selectData"), easyClose = TRUE)))
    })
    
})
