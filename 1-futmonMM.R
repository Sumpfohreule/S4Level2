########################################################################################################################
setwd("O:/TRANSP/IsenbergLars/Projekte/S4Level2")
rm(list = ls(all.names = TRUE))
source("init.R")


########################################################################################################################
target.year <- 2018

at.corrected.path <- file.path(getCorrectedAggregatePath(loadL2Object("Altensteig")), target.year)
at.gesamt.file <- getLastModifiedFile(at.corrected.path)
createMMFiles(xlsx.file = at.gesamt.file)

co.corrected.path <- file.path(getCorrectedAggregatePath(loadL2Object("Conventwald")), target.year)
co.gesamt.file <- getLastModifiedFile(co.corrected.path)
createMMFiles(xlsx.file = co.gesamt.file)

es.corrected.path <- file.path(getCorrectedAggregatePath(loadL2Object("Esslingen")), target.year)
es.gesamt.file <- getLastModifiedFile(es.corrected.path)
createMMFiles(xlsx.file = es.gesamt.file)

hd.corrected.path <- file.path(getCorrectedAggregatePath(loadL2Object("Heidelberg")), target.year)
hd.gesamt.file <- getLastModifiedFile(hd.corrected.path)
createMMFiles(xlsx.file = hd.gesamt.file)

oc.corrected.path <- file.path(getCorrectedAggregatePath(loadL2Object("Ochsenhausen")), target.year)
oc.gesamt.file <- getLastModifiedFile(oc.corrected.path)
createMMFiles(xlsx.file = oc.gesamt.file)

accumulateMMFiles(target.year, file.path(getwd(), "Data", "output"))
