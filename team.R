
# Application: BOSDraft
# Filename: team.R
# Contains helper functions for rendering hitter, 
#   pitcher and summary tables for each team


# Build the callback string for a team data table
# The action is on click of table row
# The user selects the row for a player to be drafted
# When a row is selected, the data for that row is saved in "input$rows"
getCallBack <- function(teamName) {
  return(paste("function(", teamName, ") {", teamName, 
               ".on('click.dt', 'tr', function() {$(this).toggleClass('selected');Shiny.onInputChange('rows',",
               teamName, ".row(this).data());});}", sep=""))
}

# Render the hitter data table for a team
renderTeam <- function(input, output, teamName) {
  
  output[[paste(teamName, "hitter", sep="")]] <- renderDataTable({
    if (input$draft > 0 | input$updatePos > 0){ }
    return(dfHitters %>% filter(BOSTeam==teamName) %>% 
             select(one_of(c("BOSPos", playerCol, statCol, flanaprog))) %>%
             filter(!grepl("RES", BOSPos)) %>%
             filter(!grepl("NA", BOSPos)) %>%
             arrange(BOSPos))
  }
  , options=list(info=FALSE, paging=FALSE, searching=FALSE, ordering=FALSE)
  , callback = getCallBack(teamName)
  )
}

# Render the pitcher data table for a team
renderTeamPitchers <- function(input, output, teamName) {
  
  output[[paste(teamName, "pitcher", sep="")]] <- renderDataTable({
    if (input$draft > 0 | input$updatePos > 0){ }
    return(dfPitchers %>% filter(BOSTeam==teamName) %>% 
             select(one_of(c("BOSPos", playerCol, pitcherStatCol, flanaprog))) %>%
             filter(!grepl("RES", BOSPos)) %>%
             filter(!grepl("NA", BOSPos)) %>%
             arrange(BOSPos))
  }
  , options=list(info=FALSE, paging=FALSE, searching=FALSE, ordering=FALSE)
  , callback = getCallBack(teamName)
  )
}

renderRes <- function(input, output, res, teamName) {
     output[[res]] <- renderDataTable({
          if (input$draft > 0) { }
          return(dfHitters %>% 
                 filter(BOSTeam==teamName) %>%
                 select(one_of(c("BOSPos", playerCol, statCol, flanaprog))) %>%
                 filter(grepl("RES|NA", BOSPos)))
     }
     , options=list(info=FALSE, paging=FALSE, searching=FALSE, ordering=FALSE)
     , callback = getCallBack(teamName)
     )  
}

renderPitcherRes <- function(input, output, res, teamName) {
  output[[res]] <- renderDataTable({
    if (input$draft > 0) { }
    return(dfPitchers %>% 
             filter(BOSTeam==teamName) %>%
             select(one_of(c("BOSPos", playerCol, pitcherStatCol, flanaprog))) %>%
             filter(grepl("RES|NA", BOSPos)))
  }
  , options=list(info=FALSE, paging=FALSE, searching=FALSE, ordering=FALSE)
  , callback = getCallBack(teamName)
  )  
}

# Render hitter summary data table for a team
renderSummary <- function(input, output, summary, teamName) {
  
     output[[summary]] <- renderDataTable({
          if (input$draft > 0) {  }  
               dfHitters %>% filter(BOSTeam==teamName) %>%
                             filter(!grepl("RES", BOSPos)) %>%
                             filter(!grepl("NA", BOSPos)) %>%
                             summarize(AB = sum(AB, na.rm=TRUE),
                                       R = sum(R, na.rm=TRUE),
                                       HR = sum(HR, na.rm=TRUE),
                                       RBI = sum(RBI, na.rm=TRUE),
                                       SB = sum(SB, na.rm=TRUE),
                                       AVG = format(sum(AB*AVG)/sum(AB), nsmall=3, digits=3, width=4),
                                       Tiering = sum(Tiering, na.rm=TRUE),
                                       Rating = sum(Rating, na.rm=TRUE)) %>%
                             rbind(HITTER_TARGETS) %>%
                             mutate(Summary = c("TOTALS", "TARGET")) %>%
                             select(one_of(c("Summary", statCol, flanaprog)))
     }
     , options=list(info=FALSE, paging=FALSE, searching=FALSE, ordering=FALSE)
     )
}

# Render pitcher summary data table for a team
renderPitcherSummary <- function(input, output, summary, teamName) {
  
     output[[summary]] <- renderDataTable({
          if (input$draft > 0) {  }  
               dfPitchers %>% filter(BOSTeam==teamName) %>%
                              filter(!grepl("RES", BOSPos)) %>%
                              filter(!grepl("NA", BOSPos)) %>%
                              summarize(IP = sum(IP, na.rm=TRUE),
                                        Wins = sum(Wins, na.rm=TRUE),
                                        SO = sum(SO, na.rm=TRUE),
                                        S_H = sum(S_H, na.rm=TRUE),
                                        ERA = format(sum(IP*ERA)/sum(IP), nsmall=3, digits=3, width=4),
                                        WHIP = format(sum(IP*WHIP)/sum(IP), nsmall=3, digits=3, width=4),
                                        Tiering = sum(Tiering, na.rm=TRUE),
                                        Rating = sum(Rating, na.rm=TRUE)) %>%
                              rbind(PITCHER_TARGETS) %>%
                              mutate(Summary = c("TOTALS", "TARGET")) %>%
                              select(one_of(c("Summary", pitcherStatCol, flanaprog)))
     }
     , options=list(info=FALSE, paging=FALSE, searching=FALSE, ordering=FALSE)
     )
}
