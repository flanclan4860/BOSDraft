
# Application: BOSDraft
# Filename: globals.R

# Contains variables, and constants, which are global to entire app

library(shiny)
library(dplyr)
library(tidyr)
library(data.table)
library(stringr)
#library(DT)


# Column numbers in player data, from user selected row (input$rows)
NAME <- 2
POSITION <- 4

# Target for each stat (At Bats, Runs, HomeRuns, RBI, Stolen Bases, Batting Average, Tier, Rating)
HITTER_TARGETS <- list(4500, 1040, 280, 1040, 165, format(0.280, nsmall=3), 168, 100)
# Pitcher targets (IP, Wins, StrikeOuts, Saves+Holds, ERA, WHIP, Tier, Rating)
PITCHER_TARGETS <- list(900, 90, 1000, 195, format(3.80, nsmall=3), format(1.25, nsmall=3), 140, 130)

# The "team" list holds the BOS team names, 
#  used to label the tabPanels on the mainPanel, 
#  and the draftTeam selectInput.
# They are in draft order.
# The numeric value is used for automatically 
#  incrementing the currently drafting team
team <- c("Phoenix"=1, "Bisons"=2, "Libs"=3, 
          "Portsiders"=4, "_12thMan"=5, "SSF"=6, 
          "IcePig"=7, "Slugaards"=8, "Wombats"=0)

# Valid Player positions
playerPositions <- c("C1", "C2", "1B", "CI", "3B",
                  "2B","MI", "SS", 
                  "OF1", "OF2", "OF3", "OF4", "OF5",
                  "DH",
                  "RES1", "RES2", "RES3", "RES4", "RES5")
                  
pitcherPositions <- c("SP1", "SP2", "SP3", "SP4", 
                      "P1", "P2", 
                      "RP1", "RP2", "RP3", "RP4",
                      "RESP1", "RESP2", "RESP3", "RESP4", "RESP5")
                      
# Column names for data tables
playerCol <- c("Name", "Team", "Pos")
statCol <- c("AB", "R", "HR", "RBI", "SB", "AVG")
pitcherStatCol <- c("IP","Wins","SO","S_H","ERA","WHIP")
flanaprog <- c("Tiering", "Rating")



