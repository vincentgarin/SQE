#' QTL_candidates_wrapper
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
QTL_candidates_wrapper <- function(DB, trait_id, chr_id, dist_crit, bp_low, bp_up,
                   cM_low, cM_up, R2_lim){

  if(dist_crit == 'ph_dis'){

   Q_res <- QTL_candidates(DB = DB, trait_id = trait_id, chr_id = chr_id,
                             bp_low = bp_low, bp_up = bp_up, R2_lim = R2_lim)

  } else {

    Q_res <- QTL_candidates(DB = DB, trait_id = trait_id, chr_id = chr_id,
                   cM_low = cM_low, cM_up = cM_up, R2_lim = R2_lim)

  }

  return(Q_res)

}
