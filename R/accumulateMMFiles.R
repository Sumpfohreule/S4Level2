########################################################################################################################
accumulateMMFiles <- function(target.year, output.folder) {
    mm.year.pattern <- paste0("^[[:alpha:]/]+_", target.year)
    
    plm.files <- dir("Data",
        pattern = paste0(mm.year.pattern, "\\.PLM$"),
        full.names = TRUE,
        recursive = TRUE)
    plm.list <- list()
    for (plm.file in plm.files) {
        plm.list[[plm.file]] <- read_delim(plm.file,
            delim = ";",
            col_types = cols(latitude = "c", longitude = "c", vertical_position = "c"))
    }
    full.plm.table <- rbindlist(plm.list, use.names = TRUE, fill = FALSE)
    setkey(full.plm.table, plot, instrument_seq_nr)
    full.plm.table[, `!Sequence` := 1 : .N]
    plm.file.name <- paste0("04", target.year, ".PLM")
    write.table(full.plm.table,
        file = file.path(output.folder,plm.file.name),
        quote = FALSE,
        sep = ";",
        dec = ".",
        row.names = FALSE,
        na = "",
        fileEncoding = "UTF-8")
    print(paste0("Created ", output.folder, "/", plm.file.name))
    
    mem.files <- dir("Data",
        pattern = paste0(mm.year.pattern, "\\.MEM$"),
        full.names = TRUE,
        recursive = TRUE)
    mem.list <- list()
    for (mem.file in mem.files) {
        mem.list[[mem.file]] <- read_delim(mem.file,
            delim = ";",
            col_types = cols())
    }
    full.mem.table <- rbindlist(mem.list, use.names = TRUE, fill = FALSE)
    setkey(full.mem.table, plot, instrument_seq_nr)
    full.mem.table[, `!Sequence` := 1 : .N]
    mem.file.name <- paste0("04", target.year, ".MEM")
    write.table(full.mem.table,
        file = file.path(output.folder, mem.file.name),
        quote = FALSE,
        sep = ";",
        dec = ".",
        row.names = FALSE,
        na = "",
        fileEncoding = "UTF-8")
    print(paste0("Created ", output.folder, "/", mem.file.name))
}
