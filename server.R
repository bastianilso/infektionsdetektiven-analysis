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
shinyServer(function(input, output, session) {

    # filtering variables.
    pid_index <- NULL
    pid_name <- NULL
    pid_version <- NULL
    pid_query <- NULL
    subject <- 'gameplay'
    participants <- NULL
    choices <- NULL
    
    observe({
        query <- parseQueryString(session$clientData$url_search)
        # Change E-mail dropdown based on the ?email=XXX URL parameter
        # Filter visualizations based on the ?pid=XXX URL parameter (based on the tab's value attribute)
        # Change Tab based on the ?subject=XXX URL parameter (based on the tab's value attribute)
        if (!is.null(query[['subject']])) {
            subject <<- query[['subject']]
            updateTabsetPanel(session, "subjectChooser", selected = subject)
        }
        if (!is.null(query[['pid']])) {
            pid = query[['pid']]
            pid_query <<- pid
            pid_name <<- pid
        }
        if (!is.null(query[['version']])) {
            sel = query[['version']]
            pid_version = query[['version']]
            updateSelectInput(session , "versionSelect", choices = c(versions, "All Data" = "NA"), selected = sel)
        } else {
            updateSelectInput(session , "versionSelect", choices = c(versions, "All Data" = "NA"))
        }
    })
    
    observeEvent({input$subjectChooser}, {
        if (input$subjectChooser != subject) {
            subject <<- input$subjectChooser
            UpdatePIDSelection()     
            UpdateVisualizations()     
        }
    })
    
    observeEvent(ignoreNULL=FALSE, {input$pidChooser}, {
        print(paste("version: ", input$versionSelect))
        # prevent infinite loop - only update pid_name to null, if the value is not already null.
        if (is.null(pid_name) & is.null(input$pidChooser)) {
            print(paste("pidChooser: pid_index ", pid_index))
            print(paste("pidChooser: pid_name ", pid_name))
            print("ignored..")
            return()
        }
        # CheckboxInputGroup sends an initial NULL value which overrides any query values.
        # Make sure we check whether a specific PID was specified as URL param before.
        if (!is.null(pid_query)) {
            print("pid_query exists, ignoring pidChooser")
        } else if (!is.null(input$pidChooser)) {
            pid_index <<- input$pidChooser
            pid_name <<- unlist(participants[input$pidChooser,"PlayID"])
            pid_version <<- unlist(participants[input$pidChooser,"GameVersion"])
        } else {
            pid_index <<- NULL
            pid_name <<- NULL
            pid_version <<- NULL
        }
        print(paste("pidChooser: pid_index ", pid_index))
        print(paste("pidChooser: pid_name ", pid_name))
        UpdateVisualizations() 
    })

    observeEvent({input$versionSelect},{
        if (input$versionSelect == "-1") {
            return()
        }
        RefreshDataSets(input$versionSelect)
        
        UpdatePIDSelection()
        
        UpdateVisualizations()
    })

    UpdatePIDSelection <- function() {
        # Update PID Choosers to show PID numbers based on the data
        # for synch -------
        if (subject == "gameplay") {
            participants <<- unique(df %>% group_by(GameVersion) %>% distinct(PlayID))
            if (length(participants$PlayID[is.na(participants$PlayID)]) > 0 ) {
                participants$PlayID[is.na(participants$PlayID)] <<- "NA"
            }
            if (nrow(participants) > 0) {
                choices <<- setNames(c(1:nrow(participants)),1:nrow(participants))
            } else {
                choices <<- NULL
            }
        }
        if (!is.null(pid_query)) {
            pid_name <<- pid_query
            pid_query <<- NULL
            pid_index <<- unname(choices[names(choices) == pid_name])
            print(paste("PIDQuery: e-mail", input$versionSelect))
            print(paste("PIDQuery: pid_name", pid_name))
            print(paste("PIDQuery: pid_index", pid_index))
        }
        print(choices)
        print(nrow(participants))
        print(paste("pid_name: ", pid_name))
        if (is.null(choices)) {
            updateCheckboxGroupInput(session, label = "No Participant Data", "pidChooser", choices = NULL, selected = NULL, inline = TRUE)
        }
        else if (is.null(pid_index)) {
            print("UpdateCheckbox: pid is null")
            updateCheckboxGroupInput(session, label = "Filter by Participant:", "pidChooser", choices = choices, selected = NULL, inline = TRUE)
        } else {
            print(paste("UpdateCheckbox: ", pid_index))
            updateCheckboxGroupInput(session, label = "Filter by Participant:", "pidChooser", choices = choices, selected = pid_index, inline = TRUE)
        }
    }    

    UpdateVisualizations <- function() {
        if (input$versionSelect == "-1") {
            return()
        }
        print(paste("UpdateVis pid: ", pid_name))
        print(paste("df nrow:",nrow(df)))
        
        # Filter visualization data based on pid_name
        if (!is.null(pid_name)) {
            df <- df %>% filter (GameVersion %in% pid_version) %>% filter(PlayID %in% pid_name)
        }
        if (subject == "gameplay") {
            print(paste("df filtered nrow:",nrow(df)))
            
            output$levelscompletePlot <- 
                renderPlotly({
                    plot_ly(x = df[,"LevelNo"], y = df[,"PlayID"]) %>% 
                        add_trace(data = D, type = 'scatter') %>%
                        layout(xaxis = list(title = "Level Number"), yaxis = list(title = "Participants"))
                }) 
            output$ratingPlot <- 
                renderPlotly({
                    plot_ly(x = df[!is.na(df$HowMuchDoYouLikeGame),]$HowMuchDoYouLikeGame, y = df[!is.na(df$HowMuchDoYouLikeGame),]$PlayID) %>% 
                        add_trace(data = D, type = 'scatter') %>%
                        layout(xaxis = list(title = "Hvad Syntes Du Om Spillet?"), yaxis = list(title = "Participants"))
                })
            output$restartPlot <- 
                renderPlotly({
                    plot_ly(x = df[!is.na(df$HowMuchDoYouLikeGame),]$HowMuchDoYouLikeGame, y = df[!is.na(df$HowMuchDoYouLikeGame),]$PlayID) %>% 
                        add_trace(data = D, type = 'scatter') %>%
                        layout(xaxis = list(title = "Hvad Syntes Du Om Spillet?"), yaxis = list(title = "Participants"))
                })
        }
    }
    
})
