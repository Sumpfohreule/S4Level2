#' Creates an excel which contains all data of a given plot with all its
#' subplots and loggers for a given year
#'
#' The data is converted in a way that is used for manual (visual) fixing and contains
#' graphs for all sensors
#'
#' @param plot_name String with the commonly used name of the Plot
#' (Altensteig, Conventwald, Heidelberg, Esslingen, Ochsenhausen or Rotenfels)
#' @param year Numeric representation of the year to aggregate
#' @param out_path String of the output folder (without the file name)
#' @export
createAggregateExcel <- function(plot_name, year, out_path) {
    data <- getDataForYear(year, paste0(plot_name, "/*/*")) %>%
        .createAggregateExcel(out_path)
}


.createAggregateExcel <- function(aggregate_data, out_path) {
    out_file <- aggregate_data %>%
        select(Datum, Plot) %>%
        mutate(Datum = lubridate::year(Datum)) %>%
        nest_by(Datum, Plot) %>%
        purrr::pmap(~ with(list(...), paste0(Plot, "_Gesamt_", Datum, ".xlsx"))) %>%
        unlist()
    if (file.exists(paste0(out_path, out_file))) {
        stop(sprintf("Achtung die Datei '%s' ist bereits geöffnet und muss vorher geschlossen werden.", out_file))
    }

    aggregate_data <- aggregate_data %>%
        select(-Logger)

    additional.table.list <- calculatePFTable(aggregate_data)
    additional.table.list[["pr_table"]] <- calculatePRTable(aggregate_data)
    additional.table.list[["original"]] <- aggregate_data
    full_table <- additional.table.list %>%
        bind_rows()
    rm(aggregate_data, additional.table.list)

    template_file_name <- stringr::str_replace(
        out_file,
        pattern = "^([A-Za-z]+_Gesamt_)[0-9]{4}\\.xlsx$",
        replacement = "_\\1Template.xlsx")
    template_file <- system.file("extdata", template_file_name, package = "S4Level2", mustWork = TRUE)
    template_workbook <- openxlsx::loadWorkbook(template_file)

    full_table %>%
        select(-Plot) %>%
        group_by(SubPlot) %>%
        group_split() %>%
        purrr::walk(~ {
            sub_plot <- .x %>%
                pull(SubPlot) %>%
                unique() %>%
                as.character()
            wide_table <- .try_pivot_wider(.x, names_from = "variable", values_from = "value") %>%
                select(-SubPlot)
            dates <- wide_table %>%
                pull(Datum) %>%
                MyUtilities::addYearStartEnd() %>%
                MyUtilities::fillDateGaps()
            out.table <- merge(data.table::data.table(Datum = dates), wide_table, all.x = TRUE, by = "Datum")

            template_workbook <- addToWorkbookWithTemplate(
                out.table = out.table,
                workbook = template_workbook,
                sheet = sub_plot)
        })
    output_file_path <- file.path(out_path, out_file)
    openxlsx::saveWorkbook(template_workbook, file = output_file_path, overwrite = TRUE)
    print(paste0("Saved file in path '", output_file_path, "'"))
}

.try_pivot_wider <- function(long_table, names_from, values_from) {
    tryCatch(wide_table <- long_table %>%
                 tidyr::pivot_wider(names_from = all_of(names_from), values_from = all_of(values_from)),
             warning = function(w) {
                 duplicated_rows <- long_table %>%
                     tidyr::pivot_wider(
                         names_from = all_of(names_from),
                         values_from = all_of(values_from),
                         values_fn = list(value = length)) %>%
                     filter_at(vars(-Datum), any_vars(. > 1)) %>%
                     select_if(~ mean(., na.rm = TRUE) > 1)
                 duplicated_dates <- duplicated_rows %>%
                     pull(Datum)
                 first_duplicate <-  min(duplicated_dates)
                 last_duplicate <- max(duplicated_dates)
                 duplicated_columns <- duplicated_rows %>%
                     select(-Datum) %>%
                     names()
                 sheet_name <- long_table %>%
                     pull(SubPlot) %>%
                     unique()
                 stop("Duplicated dates found from ",
                      first_duplicate, " until ", last_duplicate,
                      " in '", sheet_name, "' at the following variables:\n",
                      paste(duplicated_columns, collapse = ", "))
             }
    )
    return(wide_table)
}
