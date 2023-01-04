#' red_tab
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
red_tab <- function(dt, d_cond, thre){

  dt[d_cond < thre] <- NA
  dt <- dt[, which(!colSums(is.na(dt)) == nrow(dt)), drop = FALSE]
  dt <- dt[which(!rowSums(is.na(dt)) == ncol(dt)), , drop = FALSE]

  return(dt)

}
