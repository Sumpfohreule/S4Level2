initializeDataLocation("W:/Data")
initializeWithPresetPlots()
S4Level2::updateDatabase(plots = c("Conventwald", "Heidelberg", "Esslingen", "Ochsenhausen", "Rotenfels"),
                         sub_plots = c("Fichte", "Buche", "Freiland"))
# Folgendes macht bei mir probleme
# S4Level2::updateDatabase(plots = "Altensteig",
#                          sub_plots = c("Fichte", "Buche", "Freiland"))