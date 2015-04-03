
# Application: BOSDraft
# Filename: server.R
# March, 2015
#
# BOSDraft is a Shiny application for running a Fantasy Baseball Draft.
#


shinyServer(
     function(input,output,session){
       
         
         # Handle 'draft' action button press
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
                   # Save current state of the draft
                   write.csv(dfHitters, "./draftedHitters.csv", row.names=FALSE)
                   write.csv(dfPitchers, "./draftedPitchers.csv", row.names=FALSE)
              }
         })
         
         # Handle 'updatePos' action button press
         # Manual selection of BOS Position
         observe({
             if (input$updatePos > 0) {
               isolate({
                   newPosition <- input$newBOSPos
                   if (grepl("SP|RP|P", newPosition)) {
                        dfPitchers[Name==input$rows[NAME]]$BOSPos <<- 
                                  getPosition(dfPitchers[Name==input$rows[NAME]]$BOSTeam, newPosition)
                   } else {
                        dfHitters[Name==input$rows[NAME]]$BOSPos <<- 
                                  getPosition(dfHitters[Name==input$rows[NAME]]$BOSTeam, newPosition)
                   }
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
                     splitPos <- strsplit(rowPos, split=" ")[[1]]
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
                     if (grepl("SP", rowPos)) {
                          validPos <- c(validPos, "P", "RP")
                     } else if (grepl("RP", rowPos)){
                          validPos <- c(validPos, "P")
                     }
                     else {
                          validPos <- c(validPos, "DH")
                     }
                     validPos <- c(validPos, "Res")
                     updateSelectInput(session, "newBOSPos", choices = validPos)     
                }
         })
        
         ## Hitters table
         output$hitters <- renderDataTable({
           if (input$updatePos > 0 | input$draft > 0) {} 
           if (input$available) {
                    # Display only available players
                    return(dfHitters %>% filter(BOSTeam=="**") %>% 
                           select(one_of(c("BOSTeam", playerCol, statCol, flanaprog))))
              }
           #datatable(dfHitters %>% select(one_of(c("BOSTeam", playerCol, statCol, flanaprog))))
           return(dfHitters %>% select(one_of(c("BOSTeam", playerCol, statCol, flanaprog))))
          }
          , callback = getCallBack("hitters")
          , options = list(info=FALSE, paging=FALSE,
                           order = list(list(10, 'desc'), list(11, 'desc')))          
          )
         
         ## Pitchers table
         output$pitchers <- renderDataTable({
           if (input$updatePos > 0 | input$draft > 0) {} 
           if (input$available) {
             # Display only available players
             return(dfPitchers %>% filter(BOSTeam=="**") %>% 
                      select(one_of(c("BOSTeam", playerCol, pitcherStatCol, flanaprog))))
           }
           return(dfPitchers %>% select(one_of(c("BOSTeam", playerCol, pitcherStatCol, flanaprog))))
         }
         , callback = getCallBack("pitchers")
         , options = list(info=FALSE, paging=FALSE, 
                          order = list(list(10, 'desc'), list(11, 'desc')))          
         )
         
    
          # All BOS Team Rosters
          # Table with a column for each team and a row for each position,
          #  Data in the table is the player name
          output$teamPos <- renderDataTable({
               if (input$draft > 0) { }
                    h <- dfHitters %>% 
                         filter(BOSTeam != "**") %>%
                         filter(BOSPos != "NA") %>%
                         select(BOSTeam, BOSPos, Name)
               
                    p <- dfPitchers %>% 
                         filter(BOSTeam != "**") %>%
                         filter(BOSPos != "NA") %>%
                         select(BOSTeam, BOSPos, Name)
               
#                     h <- h %>% separate(Name, c("First", "Last"), sep=" ", extra="merge") %>%
#                               select(BOSTeam, BOSPos, Last)
#                     p <- p %>% separate(Name, c("First", "Last"), sep=" ", extra="merge") %>%
#                               select(BOSTeam, BOSPos, Last)
               
                    hp <- rbind(h, p)
                    spread(hp, BOSTeam, Name, drop=FALSE)
          }
          , options=list(info=FALSE, paging=FALSE, searching=FALSE, ordering=FALSE)
          ) 
         
          # All AL Team Rosters, shows only undrafted players
          output$ALteamPos <- renderDataTable({
               if (input$draft > 0) { }
                    h <- dfHitters %>% 
                         filter(BOSTeam == "**") %>% 
                         filter(ALPos != "NA") %>%
                         filter(Team != "AL") %>%
                         filter(Team != "FA") 
                    p <- dfPitchers %>% 
                         filter(BOSTeam == "**") %>% 
                         filter(ALPos != "NA") %>%
                         filter(Team != "AL") %>%
                         filter(Team != "FA")
               
                h <- h %>% separate(Name, c("First", "Last"), sep=" ", extra="merge") %>%
                           select(Team, ALPos, Last)
                p <- p %>% separate(Name, c("First", "Last"), sep=" ", extra="merge") %>%
                           select(Team, ALPos, Last)
                
                hp <- rbind(h, p)
                spread(hp, Team, Last, drop=FALSE)
         }
         , options=list(info=FALSE, paging=FALSE, searching=FALSE, ordering=FALSE)
         )   
         
         # Team Standings Table
         output$rankings <- renderDataTable({
           if (input$draft > 0) {  }
             for (i in 1:length(team)) {
               # Create summary row for each team
               h <- dfHitters %>% filter(BOSTeam==names(team[i])) %>%
                    summarize(Rsum = sum(R, na.rm=TRUE),
                              HRsum = sum(HR, na.rm=TRUE),
                              RBIsum = sum(RBI, na.rm=TRUE),
                              SBsum = sum(SB, na.rm=TRUE),
                              AVGsum = format(sum(AB*AVG)/sum(AB), digits=3, nsmall=3))
                              
               p <- dfPitchers %>% filter(BOSTeam==names(team[i])) %>%
                    summarize(Winsum = sum(Wins, na.rm=TRUE),
                              SOsum = sum(SO, na.rm=TRUE),
                              S_Hsum = sum(S_H, na.rm=TRUE),
                              ERAsum = format(sum(ERA*IP)/sum(IP), digits=3, nsmall=3),
                              WHIPsum = format(sum(WHIP*IP)/sum(IP), digits=3, nsmall=3))
                             
               hp <- data.table(cbind(h, p))
               hp <- mutate(hp, Team=names(team[i]))
               # Add row to table
               dfRanks <- rbind(dfRanks, hp)
             }
             # Assign ranks for each category
             dfRanks <- dfRanks %>% arrange(Rsum) %>% mutate(R=c(1:9)) %>%
                                    arrange(HRsum) %>% mutate(HR=c(1:9)) %>%
                                    arrange(RBIsum) %>% mutate(RBI=c(1:9)) %>%
                                    arrange(SBsum) %>% mutate(SB=c(1:9)) %>%
                                    arrange(AVGsum) %>% mutate(AVG=c(1:9)) %>%
                                    arrange(Winsum) %>% mutate(Wins=c(1:9)) %>%
                                    arrange(SOsum) %>% mutate(SO=c(1:9)) %>%
                                    arrange(S_Hsum) %>% mutate(S_H=c(1:9)) %>%
                                    arrange(desc(ERAsum)) %>% mutate(ERA=c(1:9)) %>%
                                    arrange(desc(WHIPsum)) %>% mutate(WHIP=c(1:9)) %>%
                        mutate(total=R+HR+RBI+SB+AVG +
                                    Wins + SO + S_H + ERA + WHIP) %>%
                        mutate(R=paste(paste(R, Rsum, sep="_("), ")", sep=""),
                               HR=paste(paste(HR, HRsum, sep="_("), ")", sep=""),
                               RBI=paste(paste(RBI, RBIsum, sep="_("), ")", sep=""),
                               SB=paste(paste(SB, SBsum, sep="_("), ")", sep=""),
                               AVG=paste(paste(AVG, AVGsum, sep="_("), ")", sep=""),
                               Wins=paste(paste(Wins, Winsum, sep="_("), ")", sep=""),
                               SO=paste(paste(SO, SOsum, sep="_("), ")", sep=""),
                               S_H=paste(paste(S_H, S_Hsum, sep="_("), ")", sep=""),
                               ERA=paste(paste(ERA, ERAsum, sep="_("), ")", sep=""),
                               WHIP=paste(paste(WHIP, WHIPsum, sep="_("), ")", sep="")) %>%
                        select(Team, R, HR, RBI, SB, AVG, 
                               Wins, SO, S_H, ERA, WHIP, total) %>%
                        arrange(desc(total))
             
             return(dfRanks)
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
         
          renderTeamPitchers(input, output, names(team[1]))
          renderTeamPitchers(input, output, names(team[2]))
          renderTeamPitchers(input, output, names(team[3]))
          renderTeamPitchers(input, output, names(team[4]))
          renderTeamPitchers(input, output, names(team[5]))
          renderTeamPitchers(input, output, names(team[6]))
          renderTeamPitchers(input, output, names(team[7]))
          renderTeamPitchers(input, output, names(team[8]))
          renderTeamPitchers(input, output, names(team[9]))         
         
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
         
          renderPitcherSummary(input, output, "summaryP1", names(team[1]))
          renderPitcherSummary(input, output, "summaryP2", names(team[2]))
          renderPitcherSummary(input, output, "summaryP3", names(team[3]))
          renderPitcherSummary(input, output, "summaryP4", names(team[4]))
          renderPitcherSummary(input, output, "summaryP5", names(team[5]))
          renderPitcherSummary(input, output, "summaryP6", names(team[6]))
          renderPitcherSummary(input, output, "summaryP7", names(team[7]))
          renderPitcherSummary(input, output, "summaryP8", names(team[8]))
          renderPitcherSummary(input, output, "summaryP9", names(team[9]))

          renderRes(input, output, "res1", names(team[1]))
          renderRes(input, output, "res2", names(team[2]))
          renderRes(input, output, "res3", names(team[3]))
          renderRes(input, output, "res4", names(team[4]))
          renderRes(input, output, "res5", names(team[5]))
          renderRes(input, output, "res6", names(team[6]))
          renderRes(input, output, "res7", names(team[7]))
          renderRes(input, output, "res8", names(team[8]))
          renderRes(input, output, "res9", names(team[9]))

          renderPitcherRes(input, output, "resP1", names(team[1]))
          renderPitcherRes(input, output, "resP2", names(team[2]))
          renderPitcherRes(input, output, "resP3", names(team[3]))
          renderPitcherRes(input, output, "resP4", names(team[4]))
          renderPitcherRes(input, output, "resP5", names(team[5]))
          renderPitcherRes(input, output, "resP6", names(team[6]))
          renderPitcherRes(input, output, "resP7", names(team[7]))
          renderPitcherRes(input, output, "resP8", names(team[8]))
          renderPitcherRes(input, output, "resP9", names(team[9]))
         
     }
)
