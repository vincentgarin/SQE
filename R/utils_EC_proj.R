#' EC_proj
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
EC_proj <- function(d_EC, EC_mat, lat_lon, nAllele = 1, scale_EC = TRUE){

  d <- c()

  for(i in 1:nrow(d_EC)){

    EC_i <- as.character(d_EC$EC[i])
    y_pred <- (nAllele * d_EC$int[i]) + (d_EC$B[i] * nAllele * EC_mat[, EC_i])
    d_i <- data.frame(pop = d_EC$pop[i], par = d_EC$par[i], EC = EC_i,
                      int = d_EC$int[i], B = d_EC$B[i], lat = lat_lon$lat,
                      long = lat_lon$long, y_pred, logpval = d_EC$sign[i])

    d <- rbind(d, d_i)

  }

  # order according to most sign EC and parent
  EC_freq <- sort(tapply(d$EC, d$EC, length), decreasing = TRUE)
  EC_sign <- d %>% group_by(EC) %>% summarise(sign = mean(logpval))
  EC_tab <- data.frame(EC_sign, freq = EC_freq[EC_sign$EC])
  EC_tab <- EC_tab %>% arrange(desc(freq), desc(sign))

  EC_lev <- EC_tab$EC
  par_lev <- c("EC", names(sort(table(d$par), decreasing = TRUE)))

  y_range <- range(d$y_pred)
  av_sign <- mean(d$logpval, na.rm = TRUE)

  # Add the raw EC values

  for(j in 1:ncol(EC_mat)){

    # scale the value
    y <- EC_mat[, j]

    if(scale_EC){

      EC_range <- range(y)
      Beta <- (y_range[2] - y_range[1])/(EC_range[2] - EC_range[1])
      y <- y_range[1] + (y - EC_range[1]) * Beta

    }

    d_j <- data.frame(pop = d_EC$pop[1], par = 'EC', EC = colnames(EC_mat)[j],
                      int = NA, B = NA, lat = lat_lon$lat, long = lat_lon$long,
                      y_pred = y, logpval = av_sign)

    d <- rbind(d, d_j)

  }

  d$EC <- factor(d$EC, levels = EC_lev)
  d$par <- factor(d$par, levels = par_lev)

  d <- data.table(d)

  return(d)

}
