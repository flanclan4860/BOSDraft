
# Application: BOSDraft
# Filename: ui.R
# March, 2015

# Defines the user interface, a navbarPage

# The page contains multiple tabPanels with datatables containing player stats.
# There are two tabs showing projected stats for all American League players,
#  one for hitters and one for pitchers, one row for each player;
#  a tab with all of the rosters for each AL team, one row for each position;
#  a tab with all of the rosters for the fantasy league, one row for each position;
#  one tab for each fantasy team roster with projected stats, one row for each player;
#    - the team tabs contain a table for for hitters, a table for pitchers, 
#      a table for a summary of hitter data, and a table for a summary of pitcher data 
#  a tab showing the projected standings for the fantasy league

# The side panel has two sections. 
#  1. The user can draft a player by clicking on a row and pressing the draft button.
#     The user can toggle between showing all AL players, or only those which are 
#     not yet drafted.
#  2. Once a player has been drafted, his position on the roster can be changed by
#     clicking on a row, selecting the new position from the newBosPos dropdown,
#     and pressing the updatePos button.
#  

source("./globals.R")
source("./draft.R")
source("./initData.R")
source("./team.R")

shinyUI(navbarPage("Boys Of Summer",                   
                   
    
     tabPanel("Draft",
          fluidRow(
            column(10,
               tabsetPanel(type = "tabs", 
                    tabPanel("Hitters", dataTableOutput('hitters')),
                    tabPanel("Pitchers", dataTableOutput('pitchers')),
                    
                    tabPanel(names(team[1]), 
                             dataTableOutput(paste(names(team[1]),"hitter", sep="")),
                             dataTableOutput('summary1'),
                             dataTableOutput(paste(names(team[1]),"pitcher", sep="")),
                             dataTableOutput('summaryP1'),
                             dataTableOutput('res1'),
                             dataTableOutput('resP1')),
                    tabPanel(names(team[2]), 
                             dataTableOutput(paste(names(team[2]),"hitter", sep="")),
                             dataTableOutput('summary2'),
                             dataTableOutput(paste(names(team[2]),"pitcher", sep="")),
                             dataTableOutput('summaryP2'),
                             dataTableOutput('res2'),
                             dataTableOutput('resP2')),
                    tabPanel(names(team[3]), 
                             dataTableOutput(paste(names(team[3]),"hitter", sep="")),
                             dataTableOutput('summary3'),
                             dataTableOutput(paste(names(team[3]),"pitcher", sep="")),
                             dataTableOutput('summaryP3'),
                             dataTableOutput('res3'),
                             dataTableOutput('resP3')),
                    tabPanel(names(team[4]), 
                             dataTableOutput(paste(names(team[4]),"hitter", sep="")),
                             dataTableOutput('summary4'),
                             dataTableOutput(paste(names(team[4]),"pitcher", sep="")),
                             dataTableOutput('summaryP4'),
                             dataTableOutput('res4'),
                             dataTableOutput('resP4')),
                    tabPanel(names(team[5]), 
                             dataTableOutput(paste(names(team[5]),"hitter", sep="")),
                             dataTableOutput('summary5'),
                             dataTableOutput(paste(names(team[5]),"pitcher", sep="")),
                             dataTableOutput('summaryP5'),
                             dataTableOutput('res5'),
                             dataTableOutput('resP5')),
                    tabPanel(names(team[6]), 
                             dataTableOutput(paste(names(team[6]),"hitter", sep="")),
                             dataTableOutput('summary6'),
                             dataTableOutput(paste(names(team[6]),"pitcher", sep="")),
                             dataTableOutput('summaryP6'),
                             dataTableOutput('res6'),
                             dataTableOutput('resP6')),
                    tabPanel(names(team[7]), 
                             dataTableOutput(paste(names(team[7]),"hitter", sep="")),
                             dataTableOutput('summary7'),
                             dataTableOutput(paste(names(team[7]),"pitcher", sep="")),
                             dataTableOutput('summaryP7'),
                             dataTableOutput('res7'),
                             dataTableOutput('resP7')),
                    tabPanel(names(team[8]), 
                             dataTableOutput(paste(names(team[8]),"hitter", sep="")),
                             dataTableOutput('summary8'),
                             dataTableOutput(paste(names(team[8]),"pitcher", sep="")),
                             dataTableOutput('summaryP8'),
                             dataTableOutput('res8'),
                             dataTableOutput('resP8')),
                    tabPanel(names(team[9]), 
                             dataTableOutput(paste(names(team[9]),"hitter", sep="")),
                             dataTableOutput('summary9'),
                             dataTableOutput(paste(names(team[9]),"pitcher", sep="")),
                             dataTableOutput('summaryP9'),
                             dataTableOutput('res9'),
                             dataTableOutput('resP9'))
                )
            ),        
            column(2,
               wellPanel(
                    selectInput("draftTeam", 
                                label = "Drafting Team",
                                choices = c("NONE", names(team)),
                                selected = names(team[1])),
                    actionButton("draft", "Draft Selected Player"),
                    checkboxInput("available", "Show available players only", FALSE)
               ),
               wellPanel(
                    selectInput("newBOSPos", 
                                label = "Modify BOS Position", 
                                choices = c("Select Position"), selected="Select Position"),
                                actionButton("updatePos", "Update")
               )
                    
            )
         )
     ),

     tabPanel("AL Rosters", dataTableOutput('ALteamPos')),
     tabPanel("BOS Rosters", dataTableOutput('teamPos')),
     tabPanel("League Standings", dataTableOutput('rankings'),
                                  dataTableOutput("rankValues"))
    
)

)
                    
  
