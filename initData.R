
# Filename: initData.R
#
# Set up the data table

# Read from data that was saved from a previous execution of BOSDraft
if (file.exists("./dfOut.csv")) {
      dfHitters <<- read.csv("./dfOut.csv", stringsAsFactors=FALSE)
      dfHitters <<- data.table(dfHitters)
      dfHitters <<- mutate(dfHitters, 
                           BOSPos = factor(BOSPos, levels=BOSPositions, ordered=TRUE), 
                           ALPos = factor(ALPos, levels=BOSPositions, ordered=TRUE))
} else {  # Read data from projected stats
     dfHitters <- read.csv("./projections_tier.csv", stringsAsFactors=FALSE)
     dfHitters <- data.table(dfHitters)
     
     # Add columns for BOSTeam, BOSPos, and ALPos
     dfHitters[, BOSTeam:="**"]
     dfHitters[, BOSPos:=factor("", levels=BOSPositions, ordered=TRUE)]
     dfHitters[, ALPos:=factor("", levels=BOSPositions, ordered=TRUE)]
     
     # Some team names have trailing white space, trim this
     # Remove this for new .csv file
     dfHitters <- mutate(dfHitters, Team=str_trim(Team))
     
     # Give each AL player a unique position, (such as OF1, OF2, etc)
     for (i in 1:nrow(dfHitters)) {
       draftPlayer(dfHitters[i]$Team, dfHitters[i]$Name, dfHitters[i]$Pos)
     }
     dfHitters <- mutate(dfHitters, ALPos=BOSPos, BOSPos="", BOSTeam="**")     
}

# Initialize the table used for league standings
dfRanks <- data.table()

