
# Filename: draft.R

# Contains the functions that do the work of drafting a player

# Takes a BOS team and AL position (such as OF or C, etc) and 
#  returns valid BOS position, (unique position such as OF1, C1, C2, etc)
getPosition <- function(draftingTeam, pos) {

     draftPosition <- "NA"
     if (pos=="1B" | pos=="2B" | pos=="3B" | pos=="SS" | pos=="DH" | pos=="CI" | pos=="MI") {
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
     else if (pos == "ML") {
          if (nrow(dfHitters[BOSTeam==draftingTeam & BOSPos=="ML1"]) == 0){
               draftPosition <- "ML1"
          }
          else if (nrow(dfHitters[BOSTeam==draftingTeam & BOSPos=="ML2"]) == 0) {
               draftPosition <- "ML2"
          }
     }
     else if (pos == "RES") {
          if (nrow(dfHitters[BOSTeam==draftingTeam & BOSPos=="RES1"]) == 0){
               draftPosition <- "RES1"
          }
          else if (nrow(dfHitters[BOSTeam==draftingTeam & BOSPos=="RES2"]) == 0) {
               draftPosition <- "RES2"
          }
          else if (nrow(dfHitters[BOSTeam==draftingTeam & BOSPos=="RES3"]) == 0) {
               draftPosition <- "RES3"
          }
     }
     return(draftPosition)
}

# A player is "drafted" by setting the BOSTeam and BOSPos values
draftPlayer <- function(draftingTeam, playerName, position) {

     if (draftingTeam == "NONE") {   # "UnDraft", Clear team 
          dfHitters[Name==playerName]$BOSTeam <<- "**"  
     }
     else {
          # Determine position for selected player
          # Player may be eligible at more than one position,
          #  strip off the first one
          splitPos <- strsplit(position, split=",")[[1]]
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
                    if (draftPosition == "NA") {
                         # 1B and 3B also eligible at CI
                         if (grepl("1B|3B", position)) {
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

