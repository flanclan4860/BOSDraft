
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
                           tabPanel("BOS Rosters", dataTableOutput('teamPos')),
                           tabPanel("AL Rosters", dataTableOutput('ALteamPos')),
                           tabPanel("League Standings", dataTableOutput('rankings')),
                           tabPanel(names(team[1]), dataTableOutput(names(team[1])), dataTableOutput('summary1')),
                           tabPanel(names(team[2]), dataTableOutput(names(team[2])), dataTableOutput('summary2')),
                           tabPanel(names(team[3]), dataTableOutput(names(team[3])), dataTableOutput('summary3')),
                           tabPanel(names(team[4]), dataTableOutput(names(team[4])), dataTableOutput('summary4')),
                           tabPanel(names(team[5]), dataTableOutput(names(team[5])), dataTableOutput('summary5')),
                           tabPanel(names(team[6]), dataTableOutput(names(team[6])), dataTableOutput('summary6')),
                           tabPanel(names(team[7]), dataTableOutput(names(team[7])), dataTableOutput('summary7')),
                           tabPanel(names(team[8]), dataTableOutput(names(team[8])), dataTableOutput('summary8')),
                           tabPanel(names(team[9]), dataTableOutput(names(team[9])), dataTableOutput('summary9'))
              )
          )
     )
)
  
