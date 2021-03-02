library(RMySQL)

source("utils/loaddbdata.R")

creds <- read.csv("credentials.csv", header=TRUE,sep=",", colClasses=c("character","character","character","character"))
ConnectToServer(creds)

#lapply( dbListConnections( dbDriver( drv = "MySQL")), dbDisconnect)
#mydb = dbConnect(MySQL(),
#                 user=creds[1, "username"],
#                 # rstudioapi::askForPassword("Database user"),
#                 password=creds[1, "password"],
#                 # rstudioapi::askForPassword("Database password"),
#                 dbname=creds[1, "dbname"],
#                 host=creds[1, "host"])

# RetreiveUniqueColmnVals() Used to get unique values available for a column
# USAGE:
#dtest = RetreiveUniqueColmnVals("Email")
#RetreiveUniqueColVals <- function(tablename, column) {
#  queryString = paste("SELECT DISTINCT",column,"FROM",tablename,sep=" ")
#  res = dbSendQuery(mydb, queryString)
#  vals = fetch(res, n=-1)
#  dbClearResult(dbListResults(mydb)[[1]])
#  return(unlist(vals)) # if there are several values, they arrive as a list, so unlist them on arrival.
#}

#versions = unname(RetreiveUniqueColVals("infektionsdetektiven","GameVersion"))


# RetreiveDataSet() Used to query for a specific dataset.
# Setting colvalue to NULL retreives all data.
# USAGE:
#dtest = RetreiveDataSet("reactiontime","Email","mhel@create.aau.dk")
#RetreiveDataSet <- function(tablename, column, colvalue) {
#  queryString = "SELECT *"
#  queryString = paste(queryString, "FROM",tablename, sep = " ")
#  if (colvalue != "NA") {
#    queryString = paste(queryString, "WHERE",column,"= ",sep=" ")
#    queryString = paste(queryString,"\'",colvalue,"\'",sep="")
#  }
#  print(queryString)
#  res = dbSendQuery(mydb, queryString)
#  df = fetch(res, n=-1)
#  dbClearResult(dbListResults(mydb)[[1]])
#  return(df)
#}

# RefreshDataSet is a helper function called in the app for refreshing ReactionTime and Synch datasets.
# Setting colfilter to NULL retreives all data.
# USAGE:
# RefreshDataSets("mhel@create.aau.dk")
#RefreshDataSets <- function(colfilter) {
#  if (colfilter == "-1") {
#    # -1 is the default value R Shiny uses on startup.
#    return()
#  }
#  
#  df<<- RetreiveDataSet("infektionsdetektiven","PlayID","NA")
#  
#  # REFRESH REACTION TIME DATASET  
#  if (nrow(df) > 0) {
#    df$GameVersion<<-"v1"
    #dfrt$Intens<<-factor(dfrt$Intens,levels = c("Low", "High"))
    #dfrt$ReactionTimeRounded <<- round(dfrt$ReactionTime, digits=-1)
    #dfrt$Modal <<- as.factor(dfrt$Modal)
    #df$PID 
#  }
#}

df <- data.frame()