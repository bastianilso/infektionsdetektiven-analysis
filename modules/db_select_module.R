db_select_UI <- function(id) {
  ns = NS(id)
  list(
    fluidPage(
    HTML("<h3>Select and Edit Data</h3>",
         "<p>Here you can switch which data record is being used,
         remove records and upload new records.</p>"),
    textOutput(ns("statusText")),
    uiOutput(ns("sessionList"))
    )
  )
}

db_select <- function(input, output, session, connected) {
  ns <- session$ns
  
  meta = NULL
  active_session = ""
  current_trigger = 0
  active_df = NULL
  
  if (connected) {
    meta <- unique(RetreiveAllData("Meta"))
    
    #active_session = GetSessionID()
    #if (active_session == "NA") {
    #  active_session <- as.character(meta$SessionID[1])
    #  SetSessionID(active_session)
    #}
    active_df <- RetreiveAllData("Full")
    current_trigger = current_trigger + 1
  }

  toReturn <- reactiveValues(
    df = active_df,
    df_meta = meta,
    session = active_session,
    trigger = current_trigger
  )
  
  return(toReturn)
}