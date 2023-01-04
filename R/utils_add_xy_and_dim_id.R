#' add_xy_and_dim_id
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
add_xy_and_dim_id <- function(d){

  d <- data.frame(d)

  # pop_env lk
  pop_env_un <- unique(as.character(d[, 1]))
  pop_env_lk <- length(pop_env_un):1
  names(pop_env_lk) <- pop_env_un

  # par lk
  p_un <- unique(as.character(d[, 2]))
  p_lk <- 1:length(p_un)
  names(p_lk) <- p_un

  d$y <- pop_env_lk[as.character(d[, 1])]
  d$x <- p_lk[as.character(d[, 2])]


  # Reduce the parent names to plot
  p_un <- as.character(p_un)
  p_un[p_un == 'IS15401'] <- 'IS15'
  p_un[p_un == 'IS23540'] <- 'IS23'
  p_un[p_un == 'SC56614'] <- 'SC56'

  return(list(d = d, pop_env_un = pop_env_un,  p_un = p_un))

}
