
# Application: BOSDraft
# Filename: draft.R

# Contains the functions that do the work of drafting a player

# Takes a BOS team and AL position (such as OF or C, etc) and 
#  returns valid BOS position, (unique position such as OF1, C1, C2, etc)
getPosition <- function(draftingTeam, pos) {

     draftPosition <- "NA"
     if (pos=="1B" | pos=="2B" | pos=="3B" | pos=="SS" | pos=="CI" | pos=="MI" | pos=="DH") {
          if (nrow(dfHitters[BOSTeam==draftingTeam & BOSPos==pos]) == 0){
               draftPosition <- pos
          }
     }
     else if (pos == "OF") {
          if (nrow(dfHitters[BOSTeam==draftingTeam & BOSPos=="OF1"]) == 0){
               draftPosition <- "OF1"
          }
          else if (nrow(dfHitters[BOSTeam==draftingTeam & BOSPos=="OF2"]) == 0) {
               draftPosition <- "OF2"
          }
          else if (nrow(dfHitters[BOSTeam==draftingTeam & BOSPos=="OF3"]) == 0) {
            draftPosition <- "OF3"
          }
          else if (nrow(dfHitters[BOSTeam==draftingTeam & BOSPos=="OF4"]) == 0) {
            draftPosition <- "OF4"
          }
          else if (nrow(dfHitters[BOSTeam==draftingTeam & BOSPos=="OF5"]) == 0) {
            draftPosition <- "OF5"
          }
     }
     else if (pos == "C") {
          if (nrow(dfHitters[BOSTeam==draftingTeam & BOSPos=="C1"]) == 0){
               draftPosition <- "C1"
          }
          else if (nrow(dfHitters[BOSTeam==draftingTeam & BOSPos=="C2"]) == 0) {
               draftPosition <- "C2"
          }
     }
     else if (pos == "SP") {
          if (nrow(dfPitchers[BOSTeam==draftingTeam & BOSPos=="SP1"]) == 0){
               draftPosition <- "SP1"
          }
          else if (nrow(dfPitchers[BOSTeam==draftingTeam & BOSPos=="SP2"]) == 0) {
               draftPosition <- "SP2"
          }
          else if (nrow(dfPitchers[BOSTeam==draftingTeam & BOSPos=="SP3"]) == 0) {
               draftPosition <- "SP3"
          }
          else if (nrow(dfPitchers[BOSTeam==draftingTeam & BOSPos=="SP4"]) == 0) {
               draftPosition <- "SP4"
          }
     }
     else if (pos == "RP") {
          if (nrow(dfPitchers[BOSTeam==draftingTeam & BOSPos=="RP1"]) == 0){
               draftPosition <- "RP1"
          }
          else if (nrow(dfPitchers[BOSTeam==draftingTeam & BOSPos=="RP2"]) == 0) {
               draftPosition <- "RP2"
          }
          else if (nrow(dfPitchers[BOSTeam==draftingTeam & BOSPos=="RP3"]) == 0) {
               draftPosition <- "RP3"
          }
          else if (nrow(dfPitchers[BOSTeam==draftingTeam & BOSPos=="RP4"]) == 0) {
               draftPosition <- "RP4"
          }
     }
     else if (pos == "P") {
          if (nrow(dfPitchers[BOSTeam==draftingTeam & BOSPos=="P1"]) == 0){
               draftPosition <- "P1"
          }
          else if (nrow(dfPitchers[BOSTeam==draftingTeam & BOSPos=="P2"]) == 0) {
               draftPosition <- "P2"
          }
     }
     else if (pos == "RES") {
          if (nrow(dfHitters[BOSTeam==draftingTeam & BOSPos=="RES1"]) == 0) {
               draftPosition <- "RES1"
          }
          else if (nrow(dfHitters[BOSTeam==draftingTeam & BOSPos=="RES2"]) == 0) {
               draftPosition <- "RES2"
          }
          else if (nrow(dfHitters[BOSTeam==draftingTeam & BOSPos=="RES3"]) == 0) {
               draftPosition <- "RES3"
          }
          else if (nrow(dfHitters[BOSTeam==draftingTeam & BOSPos=="RES4"]) == 0) {
            draftPosition <- "RES4"
          }
          else if (nrow(dfHitters[BOSTeam==draftingTeam & BOSPos=="RES5"]) == 0) {
            draftPosition <- "RES5"
          }     
     }
     else if (pos == "RESP") {
       
       if (nrow(dfPitchers[BOSTeam==draftingTeam & BOSPos=="RESP1"]) == 0) {
         draftPosition <- "RESP1"
       }
       else if (nrow(dfPitchers[BOSTeam==draftingTeam & BOSPos=="RESP2"]) == 0) {
         draftPosition <- "RESP2"
       }
       else if (nrow(dfPitchers[BOSTeam==draftingTeam & BOSPos=="RESP3"]) == 0) {
         draftPosition <- "RESP3"
       }
       else if (nrow(dfPitchers[BOSTeam==draftingTeam & BOSPos=="RESP4"]) == 0) {
         draftPosition <- "RESP4"
       }
       else if (nrow(dfPitchers[BOSTeam==draftingTeam & BOSPos=="RESP5"]) == 0) {
         draftPosition <- "RESP5"
       }  
     }
     return(draftPosition)
}

# A player is "drafted" by setting the BOSTeam and BOSPos values
draftPlayer <- function(draftingTeam, playerName, position) {

     # Pitchers
     if (grepl("RP|SP", position)) {
         if (draftingTeam == "NONE") {
              draftingTeam <- "**"
              draftPosition <- ""
         }
         else {
              draftPosition <- getPosition(draftingTeam, position)
       
              if (draftPosition == "NA"){
                   # SP and RP also eligible at P
                   draftPosition <- getPosition(draftingTeam, "P")
                   if (draftPosition == "NA") {
                          # Try to add to reserve list
                          draftPosition <- getPosition(draftingTeam, "RESP")
                   }
            
            }      
         }
         #Set the BOSPos column
         dfPitchers[Name==playerName]$BOSPos <<- draftPosition
         # Set BOSTeam column 
         dfPitchers[Name==playerName]$BOSTeam <<- draftingTeam
     }
     # Hitters
     else {
         if (draftingTeam == "NONE") {
           draftingTeam <- "**"
           draftPosition <- ""
         }
         else {
          # Determine position for selected player
          # Player may be eligible at more than one position,
          #  strip off the first one
          splitPos <- strsplit(position, split=" ")[[1]]
          draftPosition <- getPosition(draftingTeam, splitPos[1])
          if (draftPosition == "NA") {
               # Try second elegible position
               if (length(splitPos) > 1){
                    draftPosition <- getPosition(draftingTeam, splitPos[2])
                    if (draftPosition == "NA") {
                         # Try third elegible position
                         if (length(splitPos) > 2){
                              draftPosition <- getPosition(draftingTeam, splitPos[3])
                         }
                    }
               }
               if (draftPosition == "NA") {
                    # SS and 2B also eligible at MI
                    if (grepl("SS|2B", position)) {
                         draftPosition <- getPosition(draftingTeam, "MI")
                    }
                    
                    # 1B and 3B also eligible at CI
                    else if (grepl("1B|3B", position)) {
                              draftPosition <- getPosition(draftingTeam, "CI")
                    }   
                }
                if (draftPosition == "NA"){
                    # Try DH
                    draftPosition <- getPosition(draftingTeam, "DH")
                    if (draftPosition == "NA") {
                        # Try to add to reserve list
                        draftPosition <- getPosition(draftingTeam, "RES")
                    }
                }
           }
         }
          # Set the BOSPos column
          dfHitters[Name==playerName]$BOSPos <<- draftPosition
          # Set BOSTeam column 
          dfHitters[Name==playerName]$BOSTeam <<- draftingTeam
        }        
}



