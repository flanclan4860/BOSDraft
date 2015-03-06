
# Filename: globals.R

# Contains variables, and constants, which are global to entire app

library(shiny)
library(dplyr)
library(tidyr)
library(data.table)
library(stringr)


# Column numbers in player data, from user selected row (input$rows)
NAME <- 2
POSITION <- 4

# Target for each stat (At Bats, Runs, HomeRuns, RBI, Stolen Bases, Batting Average, Tier, Rating)
HITTER_TARGETS <- list(4500, 1040, 280, 1040, 165, format(0.280, nsmall=3), 168, 100)
# Pitcher targets (IP, Wins, StrikeOuts, Saves+Holds, ERA, WHIP, Tier, Rating)
PITCHER_TARGETS <- list(900, 90, 1000, 195, format(0.380, nsmall=3), format(1.250, nsmall=3), 140, 130)

# The "team" list holds the BOS team names, 
#  used to label the tabPanels on the mainPanel, 
#  and the draftTeam selectInput.
# They are in draft order.
# The numeric value is used for automatically 
#  incrementing the currently drafting team
team <- c("Bison"=1, "Dakota"=2, "Libs"=3, 
          "Pig"=4, "Port"=5, "Slug"=6, 
          "SSF"=7, "Twelve"=8, "Wombat"=0)

# Valid Player positions
playerPositions <- c("C1", "C2", "1B", "CI", "3B",
                  "2B","MI", "SS", 
                  "OF1", "OF2", "OF3", "OF4", "OF5",
                  "DH",
                  "RES1", "RES2", "RES3", "ML1", "ML2",
                  "DL1", "DL2", "DL3", "DL4", "DL5", 
                  "DL6", "DL7", "DL8", "DL9", "DL10")
pitcherPositions <- c("SP1", "SP2", "SP3", "SP4", 
                      "P1", "P2", 
                      "RP1", "RP2", "RP3", "RP4")

# Column names for data tables
playerCol <- c("Name", "Team", "Pos")
statCol <- c("AB", "R", "HR", "RBI", "SB", "AVG")
pitcherStatCol <- c("IP","Wins","SO","SaveHold","ERA","WHIP")
flanaprog <- c("FlanaprogTiering", "FlanaprogRating")



