#' get_EC_val
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
get_EC_val <- function(EC, stat = 'mean', year = 2012, grid_list, start = 172, end = 292){

  n_pt <- length(grid_list)
  EC_val <- rep(NA, n_pt)

  for(i in 1:n_pt){

    m_i <- grid_list[[i]]
    m_i <- m_i[m_i$YEAR == year, ]
    EC_vect <- m_i[start:end, EC]

    if(stat == 'sum'){
      m_EC <- mean(EC_vect, na.rm = TRUE)
      EC_vect[is.na(EC_vect)] <- m_EC
      EC_val[i] <- sum(EC_vect)
    } else {
      EC_val[i] <- mean(EC_vect, na.rm = TRUE)
    }

  }

  return(EC_val)

}
