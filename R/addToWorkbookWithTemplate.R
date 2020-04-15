########################################################################################################################
addToWorkbookWithTemplate <- function(out.table, workbook, sheet) {
    template.cols <- names(openxlsx::readWorkbook(workbook, sheet))
    all.cols <- union(template.cols, names(out.table))
    missing.cols <- setdiff(template.cols, names(out.table))
    if (length(missing.cols) > 0)
        out.table[, (missing.cols) := NA]
    openxlsx::writeData(workbook, sheet, t(all.cols), startRow = 1, colNames = FALSE)
    openxlsx::writeData(workbook, sheet, out.table[, ..all.cols], startRow = 3, colNames = FALSE)

    # Calculate days since 1900 for excel x-axis
    year <- out.table[, unique(data.table::year(Datum))]
    if (length(year) != 1) {
        stop("More than one year contained in out.table")
    }
    years.last <- 1900 : (year - 1)
    years.last_is_leap <- MyUtilities::isLeapYear(years.last)
    axis.start <- sum(years.last_is_leap) * 366 + sum(!years.last_is_leap) * 365 + 2

    target_is_leap <- MyUtilities::isLeapYear(year)
    axis.end <- axis.start + as.numeric(target_is_leap) * 366 + as.numeric(!target_is_leap) * 365 - 1

    # Adjust xml charts with new x-axis
    xml.paths <- workbook@.xData$charts
    for (xml.path in xml.paths) {
        xml.doc <- XML::xmlInternalTreeParse(xml.path)
        node.set <- XML::getNodeSet(xml.doc, "//c:numRef//c:f")
        if (stringr::str_detect(XML::xmlValue(node.set[[2]]), sheet)) {
            max.rows <- nrow(out.table)
            for (text.node in node.set) {
                XML::xmlValue(text.node) = stringr::str_replace(XML::xmlValue(text.node),
                    pattern = "[0-9]+$",
                    replacement = as.character(max.rows + 2))
            }
            pt.node.set <- XML::getNodeSet(xml.doc, "//c:numRef/c:numCache/c:ptCount")
            for (pt.node in pt.node.set) {
                XML::xmlAttrs(pt.node) <- c(val =  max.rows)
            }
            chart.type.node <- XML::getNodeSet(xml.doc, "//c:chart/c:plotArea/*")
            if (XML::xmlName(chart.type.node[[2]]) != "barChart") {
                date.node.min <- XML::getNodeSet(xml.doc, "//c:min")
                XML::xmlAttrs(date.node.min[[1]]) <- c(val = axis.start)
                date.node.max <- XML::getNodeSet(xml.doc, "//c:max")
                XML::xmlAttrs(date.node.max[[1]]) <- c(val = axis.end)
            }
            XML::saveXML(xml.doc, xml.path)
        }
    }
    openxlsx::addStyle(workbook,
        sheet = sheet,
        style = openxlsx::createStyle(numFmt = "Number"),
        rows = 2 : nrow(out.table) + 1,
        cols = 2 : ncol(out.table), gridExpand = TRUE)
    return(workbook)
}
