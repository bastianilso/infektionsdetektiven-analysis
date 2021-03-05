library(lubridate)
library(shinyjs)
library(plotly)
plot_isolation_module_UI <- function(id) {
  ns = NS(id)
  plotlyOutput(ns("isolation"))
}

plot_isolation_module <- function(input, output, session, df) {
  
  vistemplate <- plot_ly() %>%
    config(scrollZoom = TRUE, displaylogo = FALSE, modeBarButtonsToRemove = c("pan2d","select2d","hoverCompareCartesian", "toggleSpikelines","zoom2d","toImage", "sendDataToCloud", "editInChartStudio", "lasso2d", "drawclosedpath", "drawopenpath", "drawline", "drawcircle", "eraseshape", "autoScale2d", "hoverClosestCartesian","toggleHover", "")) %>%
    layout(dragmode = "pan", showlegend=FALSE,
           xaxis=list(mirror=T, showline=F,titlefont = list(size=16),tickfont = list(size=14), range=c(0,60)),
           yaxis=list(mirror=T, showline=F,titlefont = list(size=16),tickfont = list(size=14), range=c(0,100))
    )
  
  
  ns <- session$ns

  output$isolation <- renderPlotly({
    active_df = df() %>% 
      mutate(Timestamp.Event = as.POSIXct(Timestamp.Event, format = "%Y-%m-%d %H:%M:%OS")) %>%
      group_by(SessionID) %>%
      arrange(Timestamp.Event)
    
    #active_df %>% filter(Event.Event == "Sample") %>% select(Event.Event, GameTime, NumberOfInfected, LevelPlayID) %>% View()
    fig1 <- vistemplate %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 1), x=~GameTime, y=~NumberOfIsolated, type="scattergl", color=~paste(SessionID, LevelPlayID), mode="lines") %>%
      layout(xaxis=list(title="Game Time, Lvl 1"), yaxis=list(title="Isolation"))
    fig2 <- vistemplate %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 2 ), x=~GameTime, y=~NumberOfIsolated, type="scattergl", color=~paste(SessionID, LevelPlayID), mode="lines") %>%
      layout(xaxis=list(title="Game Time, Lvl 2"), yaxis=list(title="Isolation"))
    fig3 <- vistemplate %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 3 ), x=~GameTime, y=~NumberOfIsolated, type="scattergl", color=~paste(SessionID, LevelPlayID), mode="lines") %>%
      layout(xaxis=list(title="Game Time, Lvl 3"), yaxis=list(title="Isolation"))
    fig4 <- vistemplate %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 4 ), x=~GameTime, y=~NumberOfIsolated, type="scattergl", color=~paste(SessionID, LevelPlayID), mode="lines") %>%
      layout(xaxis=list(title="Game Time, Lvl 4"), yaxis=list(title="Isolation"))
    fig5 <- vistemplate %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 5 ), x=~GameTime, y=~NumberOfIsolated, type="scattergl", color=~paste(SessionID, LevelPlayID), mode="lines") %>%
      layout(xaxis=list(title="Game Time, Lvl 5"), yaxis=list(title="Isolation"))
    fig6 <- vistemplate %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 6 ), x=~GameTime, y=~NumberOfIsolated, type="scattergl", color=~paste(SessionID, LevelPlayID), mode="lines") %>%
      layout(xaxis=list(title="Game Time, Lvl 6"), yaxis=list(title="Isolation"))
    fig7 <- vistemplate %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 7 ), x=~GameTime, y=~NumberOfIsolated, type="scattergl", color=~paste(SessionID, LevelPlayID), mode="lines") %>%
      layout(xaxis=list(title="Game Time, Lvl 7"), yaxis=list(title="Isolation"))
    subplot(nrows = 2, widths = c(0.22, 0.28,0.28, 0.22), titleX = TRUE, titleY = TRUE, margin = 0.04, fig1, fig2, fig3, fig4, fig5, fig6, fig7) %>%
      layout(height = 700)

  })  
}