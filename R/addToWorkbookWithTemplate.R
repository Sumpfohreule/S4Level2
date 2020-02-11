########################################################################################################################
addToWorkbookWithTemplate <- function(out.table, workbook, sheet) {
    template.cols <- names(readWorkbook(workbook, sheet))
    all.cols <- union(template.cols, names(out.table))
    missing.cols <- setdiff(template.cols, names(out.table))
    if (length(missing.cols) > 0)
        out.table[, (missing.cols) := NA]
    writeData(workbook, sheet, t(all.cols), startRow = 1, colNames = FALSE)
    writeData(workbook, sheet, out.table[, ..all.cols], startRow = 3, colNames = FALSE)

    # Calculate days since 1900 for excel x-axis
    year <- out.table[, unique(year(Datum))]
    if (length(year) != 1) {
        stop("More than one year contained in out.table")
    }
    years.last <- 1900 : (year - 1)
    axis.start <- sum(isLeapYear(years.last)) * 366 + sum(!isLeapYear(years.last)) * 365 + 2
    axis.end <- axis.start + as.numeric(isLeapYear(year)) * 366 + as.numeric(!isLeapYear(year)) * 365 - 1
    
    # Adjust xml charts with new x-axis
    xml.paths <- workbook@.xData$charts
    for (xml.path in xml.paths) {
        xml.doc <- xmlInternalTreeParse(xml.path)
        node.set <- getNodeSet(xml.doc, "//c:numRef//c:f")
        if (str_detect(xmlValue(node.set[[2]]), sheet)) {
            max.rows <- nrow(out.table)
            for (text.node in node.set) {
                xmlValue(text.node) = str_replace(xmlValue(text.node),
                    pattern = "[0-9]+$",
                    replacement = as.character(max.rows + 2))
            }
            pt.node.set <- getNodeSet(xml.doc, "//c:numRef/c:numCache/c:ptCount")
            for (pt.node in pt.node.set) {
                xmlAttrs(pt.node) <- c(val =  max.rows)
            }
            chart.type.node <- getNodeSet(xml.doc, "//c:chart/c:plotArea/*")
            if (xmlName(chart.type.node[[2]]) != "barChart") {
                date.node.min <- getNodeSet(xml.doc, "//c:min")
                xmlAttrs(date.node.min[[1]]) <- c(val = axis.start)
                date.node.max <- getNodeSet(xml.doc, "//c:max")
                xmlAttrs(date.node.max[[1]]) <- c(val = axis.end)
            }
            saveXML(xml.doc, xml.path)
        }
    }
    addStyle(workbook,
        sheet = sheet,
        style = createStyle(numFmt = "Number"),
        rows = 2 : nrow(out.table) + 1,
        cols = 2 : ncol(out.table), gridExpand = TRUE)
    return(workbook)
}
