#' pop_EC_par_mat_form
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
pop_EC_par_mat_form <- function(d_B, d_main, d_sign, v_sel, meta_inf){

  pop_vect <- sapply(X = meta_inf[v_sel], FUN = `[[`, 1)
  par_vect <- sapply(X = meta_inf[v_sel], FUN = `[[`, 2)

  d_m <- data.table(pop = pop_vect, par = par_vect, d_main[v_sel, , drop = FALSE])
  d_B <- data.table(pop = pop_vect, par = par_vect, d_B[v_sel, , drop = FALSE])
  d_s <- data.table(pop = pop_vect, par = par_vect, d_sign[v_sel, , drop = FALSE])

  d_m <- melt(data = d_m, id.vars = c('pop', 'par'))
  d_B <- melt(data = d_B, id.vars = c('pop', 'par'))
  d_s <- melt(data = d_s, id.vars = c('pop', 'par'))

  d_m <- d_m[!is.na(value)]
  d_B <- d_B[!is.na(value)]
  d_s <- d_s[!is.na(value)]

  d_EC <- data.table(d_m, B = d_B$value, sign = d_s$value)
  colnames(d_EC)[3:4] <- c('EC', 'int')

  return(d_EC)

}
