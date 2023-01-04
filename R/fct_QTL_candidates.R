#' QTL_candidates
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
QTL_candidates <- function(DB, trait_id, chr_id, bp_low = 0, bp_up = 77615747,
                           cM_low = NULL, cM_up = NULL, R2 = 0, max_cM = 181){

  # selection by physical distance or by genetical distance

  if(!is.null(cM_low) & is.null(cM_up)){
    stop('the cM upper bound (cM_up) must also be filled')
  }

  if(is.null(cM_low) & !is.null(cM_up)){
    stop('the cM lower bound (cM_low) must also be filled')
  }

  if(!is.null(cM_low) & !is.null(cM_up)){ # subset by cM

    DB_red <- DB[trait == trait_id & chr %in% chr_id & cM >= cM_low & cM <=cM_up & QTL_un_R2 >= R2,
                 .(QTL_un_id, chr, bp, cM, log10pval, R2, effect)]

  } else { # subset by bp

    DB_red <- DB[trait == trait_id & chr %in% chr_id & bp >= bp_low & bp <= bp_up & QTL_un_R2 >= R2,
                 .(QTL_un_id, chr, bp, cM, log10pval, R2, effect)]

  }

  Q_list <- DB_red[, .(chr = mean(chr, na.rm = TRUE),
                       bp = mean(bp, na.rm = TRUE),
                       cM = round(mean(cM, na.rm = TRUE), 1),
                       logp_av = round(mean(log10pval, na.rm = TRUE), 1),
                       logp_min = round(min(log10pval, na.rm = TRUE), 1),
                       logp_max = round(max(log10pval, na.rm = TRUE), 1),
                       R2_av = round(mean(log10pval, na.rm = TRUE), 1),
                       R2_min = round(min(log10pval, na.rm = TRUE), 1),
                       R2_max = round(max(log10pval, na.rm = TRUE), 1),
                       Eff_min = round(min(effect, na.rm = TRUE), 2),
                       Eff_max = round(max(effect, na.rm = TRUE), 2)),
                   by = .(QTL_un_id)]

  colnames(Q_list)[1] <- 'QTL'
  Q_sign <- Q_list[, 1:7]
  Q_R2 <- Q_list[, c(1:4, 8:10)]
  Q_eff <- Q_list[, c(1:4, 11:12)]

  return(list(Q_sign = Q_sign, Q_R2 = Q_R2, Q_eff = Q_eff))

}
