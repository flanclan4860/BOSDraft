
# Filename: server.R
# February, 2015
#
# BOSDraft is a Shiny application for running a Fantasy Baseball Draft.
#
# There are multiple tabPanels with datatables containing player stats.
# There is one main tab showing projected stats for all American League players,
#  one row for each player;
#  a tab with all of the rosters for each AL team, one row for each position;
#  a tab with all of the rosters for the fantasy league, one row for each position;
#  one tab for each fantasy team roster with projected stats, one row for each player
#  a tab showing the projected standings for the fantasy league


source("./globals.R")
source("./draft.R")
source("./initData.R")


# Build the callback string for a team data table
# The user selects the row for a player to be drafted
# When a row is selected, the data for that row is saved in "input$rows"
getCallBack <- function(teamName) {
      return(paste("function(", teamName, ") {", teamName, 
             ".on('click.dt', 'tr', function() {$(this).toggleClass('selected');Shiny.onInputChange('rows',",
             teamName, ".row(this).data());});}", sep=""))
}

# render the data table for a team
renderTeam <- function(input, output, teamName) {
  
     output[[teamName]] <- renderDataTable({
          if (input$draft > 0 | input$updatePos > 0){ }
               return(dfHitters %>% filter(BOSTeam==teamName) %>% 
                        select(one_of(c("BOSPos", playerCol, statCol, "FlanaprogTiering"))) %>%
                        arrange(BOSPos))
     }
     , options=list(info=FALSE, paging=FALSE, searching=FALSE, ordering=FALSE)
     , callback = getCallBack(teamName)
     )
}

# render summary data table for a team
renderSummary <- function(input, output, summary, teamName) {
  
     output[[summary]] <- renderDataTable({
          if (input$draft > 0) {  }  
               dfHitters %>% filter(BOSTeam==teamName) %>%
               summarize(AB = sum(AB, na.rm=TRUE),
                         R = sum(R, na.rm=TRUE),
                         HR = sum(HR, na.rm=TRUE),
                         RBI = sum(RBI, na.rm=TRUE),
                         SB = sum(SB, na.rm=TRUE),
                         AVG = format(sum(AB*AVG)/sum(AB), digits=3, width=4),
                         FlanaprogTiering = sum(FlanaprogTiering, na.rm=TRUE)) %>%
               rbind(HITTER_TARGETS) %>%
               mutate(Summary = c("TOTALS", "TARGET")) %>%
               select(one_of(c("Summary", statCol, "FlanaprogTiering")))
     }
     , options=list(info=FALSE, paging=FALSE, searching=FALSE, ordering=FALSE)
     )
}

shinyServer(
     function(input,output,session){
         
         ## Handle 'draft' action button press
         # Set BOSPos and BOSTeam for selected player
         observe({
              if (input$draft > 0) {
                   isolate({
                        draftPlayer(input$draftTeam, 
                                    input$rows[NAME], input$rows[POSITION])
                        # Set draftTeam to the next team in the draft order
                        updateSelectInput(session, "draftTeam", 
                                          selected=names(team[team[input$draftTeam]+1]))     
                        
                   })
                   write.csv(dfHitters, "./dfOut.csv", row.names=FALSE)
              }
         })
         
         ## Handle 'updatePos' action button press
         # Manual selection of BOS Position
         observe({
             if (input$updatePos > 0) {
               isolate({
                   dfHitters[Name==input$rows[NAME]]$BOSPos <<- 
                       getPosition(dfHitters[Name==input$rows[NAME]]$BOSTeam, input$newBOSPos) 
               })
                  
             }
         })
          
         # Update BOS Position drop down to 
         #  include only valid positions for selected player,
         #  includes all positions listed in Pos column, and CI, MI, DH, Res
         observe({
                rowPos <- input$rows[POSITION]
                if (!is.null(rowPos)) {
                     validPos <- c("Select Position")
                     splitPos <- strsplit(rowPos, split=",")[[1]]
                     validPos <- c(validPos, splitPos[1])
                     if (length(splitPos) > 1){
                          validPos <- c(validPos, splitPos[2])
                          if (length(splitPos) > 2){
                               validPos <- c(validPos, splitPos[3])
                          }
                     }
                     if (grepl("1B|3B", rowPos)) {
                          validPos <- c(validPos, "CI")
                     }
                     if (grepl("2B|SS", rowPos)) {
                          validPos <- c(validPos, "MI")
                     }
                     validPos <- c(validPos, "DH", "Res")
                     updateSelectInput(session, "newBOSPos", choices = validPos)     
                }
         })
        
         ## Hitters table
         output$hitters <- renderDataTable({
           if (input$updatePos > 0 | input$draft > 0) {} 
           if (input$available) {
                    # Display only available players
                    return(dfHitters %>% filter(BOSTeam=="**") %>% 
                           select(one_of(c("BOSTeam", playerCol, statCol))))
              }
              return(dfHitters %>% select(one_of(c("BOSTeam", playerCol, statCol, "FlanaprogTiering"))))
          }
          , callback = getCallBack("hitters")
          , options = list(order = list(list(3, 'asc'), list(10, 'desc')))
          #, options = list(order = list(0, 'asc'))
          
          )
         
    
          # All BOS Team Rosters
          # Table with a column for each team and a row for each position,
          #  Data in the table is the player name
          output$teamPos <- renderDataTable({
               if (input$draft > 0) { }
                    dfHitters %>% select(BOSTeam, BOSPos, Name) %>%
                    filter(BOSTeam != "**" & BOSPos != "NA") %>% spread(BOSTeam, Name, drop=FALSE)
          }
          , options=list(info=FALSE, paging=FALSE, searching=FALSE, ordering=FALSE)
          ) 
         
          # All AL Team Rosters, shows only undrafted players
          output$ALteamPos <- renderDataTable({
               if (input$draft > 0) { }
                    dfHitters %>% filter(BOSTeam == "**") %>% select(Team, ALPos, Name) %>% 
                      spread(Team, Name, drop=FALSE)
               #}
         }
         , options=list(info=FALSE, paging=FALSE, searching=FALSE, ordering=FALSE)
         )   
         
         # Team Standings Table
         output$rankings <- renderDataTable({
           if (input$draft > 0) {  }
             for (i in 1:length(team)) {
               d <- dfHitters %>% filter(BOSTeam==names(team[i])) %>%
                    summarize(AB = sum(AB, na.rm=TRUE),
                              R = sum(R, na.rm=TRUE),
                              HR = sum(HR, na.rm=TRUE),
                              RBI = sum(RBI, na.rm=TRUE),
                              SB = sum(SB, na.rm=TRUE),
                              AVG = format(sum(AB*AVG)/sum(AB), digits=3, width=4)) %>%
                    mutate(Team=names(team[i]))
                    # Add row to table
                    dfRanks <- rbind(dfRanks, d)
             }
             # Assign ranks for each category
             dfRanks <- dfRanks %>% arrange(AB) %>% mutate(ABrank=c(1:9)) %>%
                                    arrange(R) %>% mutate(Rrank=c(1:9)) %>%
                                    arrange(HR) %>% mutate(HRrank=c(1:9)) %>%
                                    arrange(RBI) %>% mutate(RBIrank=c(1:9)) %>%
                                    arrange(SB) %>% mutate(SBrank=c(1:9)) %>%
                                    arrange(AVG) %>% mutate(AVGrank=c(1:9)) %>%
                        mutate(totalRank=ABrank+Rrank+HRrank+RBIrank+SBrank+AVGrank) %>%
                        select(Team, ABrank, Rrank, HRrank, RBIrank, SBrank, AVGrank, totalRank) %>%
                        arrange(desc(totalRank))
             
             return(dfRanks)
           #}
         }
         , options=list(info=FALSE, paging=FALSE, searching=FALSE, ordering=FALSE)
         )
    
          ### Tabs for each team roster
          renderTeam(input, output, names(team[1]))
          renderTeam(input, output, names(team[2]))
          renderTeam(input, output, names(team[3]))
          renderTeam(input, output, names(team[4]))
          renderTeam(input, output, names(team[5]))
          renderTeam(input, output, names(team[6]))
          renderTeam(input, output, names(team[7]))
          renderTeam(input, output, names(team[8]))
          renderTeam(input, output, names(team[9]))         
         
          ### Tables showing the summary totals for each column of data 
          renderSummary(input, output, "summary1", names(team[1]))
          renderSummary(input, output, "summary2", names(team[2]))
          renderSummary(input, output, "summary3", names(team[3]))
          renderSummary(input, output, "summary4", names(team[4]))
          renderSummary(input, output, "summary5", names(team[5]))
          renderSummary(input, output, "summary6", names(team[6]))
          renderSummary(input, output, "summary7", names(team[7]))
          renderSummary(input, output, "summary8", names(team[8]))
          renderSummary(input, output, "summary9", names(team[9]))
         
     }
)
      #edit(teamdf)
