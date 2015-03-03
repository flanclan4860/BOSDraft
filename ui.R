
# Filename: ui.R

# Defines the user interface, consisting of a header, sidebar, and main panel

source("./globals.R")

shinyUI(
    
     pageWithSidebar(
          headerPanel("BOS Fantasy Baseball League"),
          sidebarPanel(
               wellPanel(
                    selectInput("draftTeam", 
                                label = "Drafting Team",
                                choices = c("NONE", names(team)),
                                selected = names(team[1])),
                    actionButton("draft", "Draft Selected Player"),
                    checkboxInput("available", "Show available players only", FALSE)
               ),
               wellPanel(
                    selectInput("newBOSPos", label = "Modify BOS Position", 
                                choices = c("Select Position"), selected="Select Position"),
                    actionButton("updatePos", "Update")
               )
          ),
          mainPanel(
               tabsetPanel(type = "tabs", 
                    tabPanel("Hitters", dataTableOutput('hitters')),
                    tabPanel("Pitchers", dataTableOutput('pitchers')),
                    tabPanel("BOS Rosters", dataTableOutput('teamPos')),
                    tabPanel("AL Rosters", dataTableOutput('ALteamPos')),
                    tabPanel("League Standings", dataTableOutput('rankings')),
                    tabPanel(names(team[1]), wellPanel(dataTableOutput(paste(names(team[1]),"hitter", sep="")),
                                             dataTableOutput('summary1')),
                                             wellPanel(dataTableOutput(paste(names(team[1]),"pitcher", sep="")))),
                    tabPanel(names(team[2]), dataTableOutput(paste(names(team[2]),"hitter", sep="")), 
                                             dataTableOutput('summary2'),
                                             dataTableOutput(paste(names(team[2]),"pitcher", sep=""))),
                    tabPanel(names(team[3]), dataTableOutput(paste(names(team[3]),"hitter", sep="")), 
                                             dataTableOutput('summary3'),
                                             dataTableOutput(paste(names(team[3]),"pitcher", sep=""))),
                    tabPanel(names(team[4]), dataTableOutput(paste(names(team[4]),"hitter", sep="")), 
                                             dataTableOutput('summary4'),
                                             dataTableOutput(paste(names(team[4]),"pitcher", sep=""))),
                    tabPanel(names(team[5]), dataTableOutput(paste(names(team[5]),"hitter", sep="")), 
                                             dataTableOutput('summary5'),
                                             dataTableOutput(paste(names(team[5]),"pitcher", sep=""))),
                    tabPanel(names(team[6]), dataTableOutput(paste(names(team[6]),"hitter", sep="")), 
                                             dataTableOutput('summary6'),
                                             dataTableOutput(paste(names(team[6]),"pitcher", sep=""))),
                    tabPanel(names(team[7]), dataTableOutput(paste(names(team[7]),"hitter", sep="")), 
                                             dataTableOutput('summary7'),
                                             dataTableOutput(paste(names(team[7]),"pitcher", sep=""))),
                    tabPanel(names(team[8]), dataTableOutput(paste(names(team[8]),"hitter", sep="")), 
                                             dataTableOutput('summary8'),
                                             dataTableOutput(paste(names(team[8]),"pitcher", sep=""))),
                    tabPanel(names(team[9]), dataTableOutput(paste(names(team[9]),"hitter", sep="")), 
                                             dataTableOutput('summary9'),
                                             dataTableOutput(paste(names(team[9]),"pitcher", sep="")))
              )
          )
     )
)
  
