library(lubridate)
library(shinyjs)
library(plotly)
plot_module_UI <- function(id) {
  ns = NS(id)
  plotlyOutput(ns("infection_spread"))
}

plot_module_summary <- function(input, output, session, df) {
  
  vistemplate <- plot_ly() %>%
    config(scrollZoom = TRUE, displaylogo = FALSE, modeBarButtonsToRemove = c("pan2d","select2d","hoverCompareCartesian", "toggleSpikelines","zoom2d","toImage", "sendDataToCloud", "editInChartStudio", "lasso2d", "drawclosedpath", "drawopenpath", "drawline", "drawcircle", "eraseshape", "autoScale2d", "hoverClosestCartesian","toggleHover", "")) %>%
    layout(dragmode = "pan", showlegend=FALSE,
           xaxis=list(mirror=T, showline=F,titlefont = list(size=16),tickfont = list(size=14), range=c(0,60)),
           yaxis=list(mirror=T, showline=F,titlefont = list(size=16),tickfont = list(size=14), range=c(0,100))
    )
  
  
  ns <- session$ns

  output$infection_spread <- renderPlotly({
    active_df = df() %>% 
      mutate(Timestamp.Event = as.POSIXct(Timestamp.Event, format = "%Y-%m-%d %H:%M:%OS")) %>%
      group_by(SessionID) %>%
      arrange(Timestamp.Event)
    
    #active_df %>% filter(Event.Event == "Sample") %>% select(Event.Event, GameTime, NumberOfInfected, LevelPlayID) %>% View()
    fig1 <- vistemplate %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 1), x=~GameTime, y=~NumberOfInfected, type="scattergl", color=~paste(SessionID, LevelPlayID), mode="lines") %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 1 ), x=~GameTime, y=~(SubjectsOnStart-GameOverScore-NewInfectionSeconds), type="scattergl", color=I('red'), mode="lines") %>%
      layout(xaxis=list(title="Game Time, Lvl 1"), yaxis=list(title="Infection Spread"))
    fig2 <- vistemplate %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 2 ), x=~GameTime, y=~NumberOfInfected, type="scattergl", color=~paste(SessionID, LevelPlayID), mode="lines") %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 2 ), x=~GameTime, y=~(SubjectsOnStart-GameOverScore-NewInfectionSeconds), type="scattergl", color=I('red'), mode="lines") %>%
      layout(xaxis=list(title="Game Time, Lvl 2"), yaxis=list(title="Infection Spread"))
    fig3 <- vistemplate %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 3 ), x=~GameTime, y=~NumberOfInfected, type="scattergl", color=~paste(SessionID, LevelPlayID), mode="lines") %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 3 ), x=~GameTime, y=~(SubjectsOnStart-GameOverScore-NewInfectionSeconds), type="scattergl", color=I('red'), mode="lines") %>%
      layout(xaxis=list(title="Game Time, Lvl 3"), yaxis=list(title="Infection Spread"))
    fig4 <- vistemplate %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 4 ), x=~GameTime, y=~NumberOfInfected, type="scattergl", color=~paste(SessionID, LevelPlayID), mode="lines") %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 4 ), x=~GameTime, y=~(SubjectsOnStart-GameOverScore-NewInfectionSeconds), type="scattergl", color=I('red'), mode="lines") %>%
      layout(xaxis=list(title="Game Time, Lvl 4"), yaxis=list(title="Infection Spread"))
    fig5 <- vistemplate %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 5 ), x=~GameTime, y=~NumberOfInfected, type="scattergl", color=~paste(SessionID, LevelPlayID), mode="lines") %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 5 ), x=~GameTime, y=~(SubjectsOnStart-GameOverScore-NewInfectionSeconds), type="scattergl", color=I('red'), mode="lines") %>%
      layout(xaxis=list(title="Game Time, Lvl 5"), yaxis=list(title="Infection Spread"))
    fig6 <- vistemplate %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 6 ), x=~GameTime, y=~NumberOfInfected, type="scattergl", color=~paste(SessionID, LevelPlayID), mode="lines") %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 6 ), x=~GameTime, y=~(SubjectsOnStart-GameOverScore-NewInfectionSeconds), type="scattergl", color=I('red'), mode="lines") %>%
      layout(xaxis=list(title="Game Time, Lvl 6"), yaxis=list(title="Infection Spread"))
    fig7 <- vistemplate %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 7 ), x=~GameTime, y=~NumberOfInfected, type="scattergl", color=~paste(SessionID, LevelPlayID), mode="lines") %>%
      add_trace(data=active_df %>% filter(Event.Event == "Sample", LevelNo == 7 ), x=~GameTime, y=~(SubjectsOnStart-GameOverScore-NewInfectionSeconds), type="scattergl", color=I('red'), mode="lines") %>%
      layout(xaxis=list(title="Game Time, Lvl 7"), yaxis=list(title="Infection Spread"))
    subplot(nrows = 2, widths = c(0.22, 0.28,0.28, 0.22), titleX = TRUE, titleY = TRUE, margin = 0.04, fig1, fig2, fig3, fig4, fig5, fig6, fig7) %>%
      layout(height = 700)

  })  
}