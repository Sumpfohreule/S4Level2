########################################################################################################################
calculateDendroSum <- function(ohm_values, temp_values, sensor_id) {
    if (length(ohm_values) != length(temp_values))
        stop("Two vectors of differing lengths!")
    conversion_table <- data.table::data.table(mu_absolute = calculateAbsoluteMicrometerValue(
            ohm.value = ohm_values,
            temperature = temp_values,
            sensor.id = sensor_id))
    conversion_table[!is.na(mu_absolute), mu_diffs := c(0, diff(na.omit(mu_absolute)))]
    conversion_table[!is.na(mu_absolute), mu_summation := cumsum(mu_diffs)]
    return(conversion_table[, mu_summation])
}
