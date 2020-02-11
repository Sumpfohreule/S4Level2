########################################################################################################################
createMMFiles <- function(xlsx.file) {
    # Import "Gesamt" tables for all sub plots
    full.table <- importAggregateData(xlsx.file)
    # Separate variable (sensor) names into vertical_position, variable and profile_pit
    meo.table <- full.table[str_detect(variable, "[0-9]{2}_(PF|FDR|T_PF)_[XYZ]"),
        separate(.SD,
            col = "variable",
            into = c("vertical_position", "variable", "profile_pit"),
            sep = "(?<!T)_(?!mV)",
            extra = "drop",
            fill = "left")]
    meo.table[, vertical_position := as.factor(as.numeric(vertical_position) / -100)]
    mappings <- data.table(
        pattern = c("^T_PF$", "^PF$", "^FDR$"),
        replacement = c("ST", "MP", "WC"))
    for (pattern.index in mappings[, pattern]) {
        replacement = mappings[pattern == pattern.index, replacement]
        meo.table[, variable := remapLevels(variable,
                pattern = pattern.index,
                replacement = replacement)]
    }

    # Converting hPa to kPa
    meo.table[variable == "MP", value := value / 10]

    plot.name <- str_match(basename(xlsx.file), pattern = "^[[:alpha:]]*(?=_)")
    buche.id <- getEuPlotId(plot.name, "Buche")
    fichte.id <- getEuPlotId(plot.name, "Fichte")
    meo.table[SubPlot == "Fichte", plot := factor(fichte.id)]
    meo.table[SubPlot == "Buche", plot := factor(buche.id)]

    mem.table <- full.table[variable %in% c("AT", "RH", "WS", "WD", "SR", "PR")]
    mem.fi.table <- copy(mem.table)
    mem.fi.table[, plot := factor(fichte.id)]
    mem.bu.table <- copy(mem.table)
    mem.bu.table[, plot := factor(buche.id)]
    mem.double.table <- rbindlist(list(mem.bu.table, mem.fi.table))
    rm(mem.table, mem.bu.table, mem.fi.table)

    # Import template for consistent instrument numbers
    template_file <- system.file("extdata", "042013_template.PLM")
    instrument.template <- as.data.table(
        read_fwf(template_file,
            col_positions = fwf_widths(c(4, 3, 5, 4, 2, 8, 8, 3, 3, 7, 3, 4, 5, 6, 7, 7, 4, 13, NA)),
            col_types = cols(X2 = "i", X3 = "f", X6 = "c", X7 = "c", X10 = "c"),
            skip = 1))
    template.col.names <- unlist(
        read_delim(template_file,
            delim = ",",
            col_names = FALSE,
            col_types = cols(),
            trim_ws = TRUE,
            n_max = 1,
            guess_max = 1))
    setnames(instrument.template, template.col.names)
    setnames(instrument.template,
        old = c("!Sequence", "instrument"),
        new = c("Sequence", "instrument_seq_nr"))
    instrument.template[, ":=" (
            SW_pit = profile_pit,
            profile_pit = str_match(profile_pit, pattern = "[XYZ]$"))]

    # Join data with instrument id tables
    full.meo.join <- merge(
        x = meo.table,
        y = instrument.template,
        by = c("plot", "variable", "vertical_position", "profile_pit"))
    full.mem.join <- merge(
        x = mem.double.table,
        y = instrument.template,
        by = c("plot", "variable"))
    final.full.join <- rbindlist(list(full.meo.join, full.mem.join), use.names = TRUE, fill = TRUE)
    rm(instrument.template, full.meo.join, full.mem.join)
    setkey(final.full.join, SubPlot, variable, vertical_position, profile_pit)

    # Base table with all columns for mem and plm accumulated with completeness calculation of values
    base.table <- final.full.join[, .(
            Sequence = as.numeric(NA),
            country = unique(country),
            location = unique(location),
            latitude = unique(latitude),
            longitude = unique(longitude),
            altitude = unique(altitude),
            variable = unique(variable),
            vertical_position = unique(vertical_position),
            code_recording = 50,
            scanning = unique(scanning),
            storing = unique(storing),
            SW_pit = unique(SW_pit),
            date_monitoring_first = NA,
            date_monitoring_last = NA,
            measuring_days = NA,
            instrument_description = unique(instrument_description),
            other_observations = unique(other_observations),
            mean_sum = NA,
            min = NA,
            max = NA,
            completeness = round(sum(!is.na(value)) * 100 / length(value), digits = 0),
            origin = 1,
            status = 2,
            other_observations = as.character(NA)),
        by = .(
            instrument_seq_nr,
            plot,
            date_observation = as.Date(Datum))]

    mem.fields <- c(
        "Sequence",
        "plot",
        "instrument_seq_nr",
        "variable",
        "date_observation",
        "mean_sum",
        "min",
        "max",
        "completeness",
        "origin",
        "status",
        "other_observations")
    non.value.mem.fields <- setdiff(mem.fields, c("mean_sum", "min", "max"))
    # Create "base" table with static information and calculated completeness
    mem.base.table <- base.table[, ..non.value.mem.fields]

    # Create sensor specific mean, sum, min and max tables
    inst.mean <- c("AT", "RH", "WS", "SR", "UR", "ST", "MP", "WC")
    mem.mean.table <- final.full.join[variable %in% inst.mean, .(
            mean_sum = round(mean(value, na.rm = TRUE), digits = 2)),
        by = .(instrument_seq_nr, plot, date_observation = as.Date(Datum))]

    inst.sum <- c("PR" , "TF" , "SF")
    mem.sum.table <- final.full.join[variable %in% inst.sum, .(
            mean_sum = round(sum(value, na.rm = TRUE), digits = 2)),
        by = .(instrument_seq_nr, plot, date_observation = as.Date(Datum))]
    mean.sum.table <- rbindlist(list(mem.mean.table, mem.sum.table), use.names = TRUE, fill = FALSE)
    mean.sum.table[is.nan(mean_sum), mean_sum := NA]
    rm(mem.mean.table, mem.sum.table)

    inst.min <- c("AT", "RH", "ST", "MP", "WC")
    mem.min.table <- final.full.join[variable %in% inst.min, .(
            min = suppressWarnings(round(min(value, na.rm = TRUE), digits = 2))),
        by = .(instrument_seq_nr, plot, date_observation = as.Date(Datum))]
    mem.min.table[is.infinite(min), min := NA]

    inst.max <- c("AT", "RH", "WS", "ST", "MP", "WC")
    mem.max.table <- final.full.join[variable %in% inst.max, .(
            max = suppressWarnings(round(max(value, na.rm = TRUE), digits = 2))),
        by = .(instrument_seq_nr, plot, date_observation = as.Date(Datum))]
    mem.max.table[is.infinite(max), max := NA]

    mm.key.columns <- c("plot", "instrument_seq_nr", "date_observation")
    min.max.table <- merge(
        x = mem.min.table,
        y = mem.max.table,
        all = TRUE,
        by = mm.key.columns)
    rm(mem.min.table, mem.max.table)

    mem.final.table <- merge(
        x = merge(
            x = mem.base.table,
            y = mean.sum.table,
            by = mm.key.columns),
        y = min.max.table,
        all = TRUE,
        by = mm.key.columns)
    # Setting origin and status to 9 (no data) if completeness is 0.
    # setting mean_sum to NA because sum(NA, na.rm = TRUE) equals 0 and not NA
    mem.final.table[completeness == 0, ":=" (
            mean_sum = NA,
            min = NA,
            max = NA,
            origin = 9,
            status = 9)]

    empty.instruments <- mem.final.table[,
        .(empty = sum(completeness) == 0),
        by = .(instrument_seq_nr)][empty == TRUE, instrument_seq_nr]
    mem.final.table <- mem.final.table[!instrument_seq_nr %in% empty.instruments]
    setkey(mem.final.table, plot, instrument_seq_nr, date_observation)
    setcolorder(mem.final.table, neworder = mem.fields)
    data.year <- mem.final.table[, unique(year(date_observation))]
    plm.date.table <- mem.final.table[!is.na(mean_sum), .(
            date_monitoring_first = min(date_observation, na.rm = TRUE),
            date_monitoring_last = max(date_observation, na.rm = TRUE)),
        by = c("plot", "instrument_seq_nr")]
    plm.date.table[, measuring_days := as.numeric(date_monitoring_last - date_monitoring_first + 1)]

    mem.final.table[, date_observation := format(date_observation, "%d%m%y")]
    mem.final.table[, Sequence := 1:.N]
    setnames(mem.final.table,
        old = "Sequence",
        new = "!Sequence")

    output.file.path <- file.path("Data", "output", plot.name)
    dir.create(output.file.path, showWarnings = FALSE)
    mem.file <- file.path(output.file.path, paste0(plot.name, "_", data.year, ".MEM"))
    write.table(mem.final.table,
        file = mem.file,
        quote = FALSE,
        sep = ";",
        dec = ".",
        row.names = FALSE,
        na = "",
        fileEncoding = "UTF-8")
    print(paste0("Created ", mem.file))

    plm.fields <- c(
        "Sequence",
        "country",
        "plot",
        "instrument_seq_nr",
        "location",
        "latitude",
        "longitude",
        "altitude",
        "variable",
        "vertical_position",
        "code_recording",
        "scanning",
        "storing",
        "SW_pit",
        "date_monitoring_first",
        "date_monitoring_last",
        "measuring_days",
        "instrument_description",
        "other_observations")
    non.date.plm.fields <- setdiff(plm.fields,
        c("date_monitoring_first", "date_monitoring_last", "measuring_days"))
    plm.base.table <- base.table[, ..non.date.plm.fields]
    plm.base.table <- unique(plm.base.table)
    plm.final.table <- merge(
        x = plm.base.table,
        y = plm.date.table,
        all.x = TRUE,
        by = c("plot", "instrument_seq_nr"))

    # Replacing location information (Coordinates, height slope etc.) with updated data for all years
    corrected_coordinate_file <- system.file("extdata", "Koordinaten_Stand_2019_05.csv")
    new_location_data <- read_csv2(
        file = file.path(corrected_coordinate_file),
        col_types = cols_only(
            plot = col_character(),
            latitude = col_character(),
            longitude = col_character(),
            altitude = col_double()))
    plm.final.table <- plm.final.table %>%
        select(-latitude, -longitude, -altitude)
    plm_fixed_location_final <- merge(
        x = plm.final.table,
        y = new_location_data,
        all.x = TRUE,
        by = c("plot"))

    setkey(plm_fixed_location_final, plot, instrument_seq_nr)
    setcolorder(plm_fixed_location_final, plm.fields)

    # Removing plm sensors if no (correct) value was measured the whole year
    plm_fixed_location_final <- plm_fixed_location_final[!is.na(date_monitoring_first)]
    plm_fixed_location_final[, ":=" (
            date_monitoring_first = format(date_monitoring_first, "%d%m%y"),
            date_monitoring_last = format(date_monitoring_last, "%d%m%y"))]
    plm_fixed_location_final[,  Sequence := 1:.N]
    setnames(plm_fixed_location_final,
        old = "Sequence",
        new = "!Sequence")
    plm.file <- file.path(output.file.path, paste0(plot.name, "_", data.year, ".PLM"))
    write.table(plm_fixed_location_final,
        file = plm.file,
        quote = FALSE,
        sep = ";",
        dec = ".",
        row.names = FALSE,
        na = "",
        fileEncoding = "UTF-8")
    print(paste0("Created ", plm.file))
}
