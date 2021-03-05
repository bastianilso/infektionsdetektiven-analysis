library(plotly)
gamesettings = data.frame(levelNo = c(1,2,3,4,5,6,7,8),
                          gameOverScore = c(2,10,15,15,15,20,20,40),
                          gameWonScore= c(20,24,28,28,42,49,84,84),
                          numberOfSubjects = c(20,40,40,80,80,150,180,200),
                          newInfectionSeconds = c(NA,6,4,4,3,5,5,3),
                          newInfectedOnStart = c(5,1,1,1,1,1,3,5))

gamesettings = gamesettings %>% mutate(healthGameOver = numberOfSubjects-gameOverScore)

vistemplate <- plot_ly() %>%
  config(scrollZoom = TRUE, displaylogo = FALSE, modeBarButtonsToRemove = c("pan2d","select2d","hoverCompareCartesian", "toggleSpikelines","zoom2d","toImage", "sendDataToCloud", "editInChartStudio", "lasso2d", "drawclosedpath", "drawopenpath", "drawline", "drawcircle", "eraseshape", "autoScale2d", "hoverClosestCartesian","toggleHover", "")) %>%
  layout(dragmode = "pan", showlegend=FALSE,
         xaxis=list(mirror=T, showline=F,titlefont = list(size=16),dtick=1, tickfont = list(size=14), range=c(0,9)),
         yaxis=list(mirror=T, showline=F,titlefont = list(size=16),tickfont = list(size=14), range=c(0,200))
  )

# Population: How many is in each level
fig1 <- vistemplate %>%
  add_trace(data=gamesettings, x=~levelNo, y=~numberOfSubjects, type="scattergl", color=I('black'), mode="lines") %>%
  add_trace(data=gamesettings, x=~levelNo, y=~gameOverScore, type="scattergl", color=I('FireBrick'), mode="lines") %>%
  layout(xaxis=list(title="Level Number"), yaxis=list(title="Population (n)"))

fig2 <- vistemplate %>%
  add_trace(data=gamesettings, x=~levelNo, y=~gameWonScore, type="scattergl", color=I('DodgerBlue'), mode="lines") %>%
  layout(yaxis=list(range=c(0,100), title="Time (s)"), xaxis=list(title="Level Number"), yaxis=list(title="GameOverScore"))

fig3 <- vistemplate %>%
  add_trace(data=gamesettings, x=~levelNo, y=~newInfectionSeconds, type="scattergl", color=I('FireBrick'), mode="lines") %>%
  layout(yaxis=list(range=c(0,7), title="Time (s)"), xaxis=list(title="Level Number"), yaxis=list(title="GameOverScore"))

fig4 <- vistemplate %>%
  add_trace(data=gamesettings, x=~levelNo, y=~newInfectedOnStart, type="scattergl", color=I('FireBrick'), mode="lines") %>%
  layout(yaxis=list(range=c(0,6), title="Population (n)"), xaxis=list(title="Level Number"), yaxis=list(title="GameOverScore"))

fig_comb <- subplot(nrows = 4, titleX = TRUE, titleY = TRUE, margin = 0.04, fig1, fig2, fig3, fig4) %>%
  layout(height = 1200)

orca(fig_comb, "level-stats.png", width=300)
