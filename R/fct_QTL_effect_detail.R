#' QTL_effect_detail
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
QTL_effect_detail <- function(DB, QTL_id){

  # test if the selected QTL effect is in the DB
  if(!(QTL_id %in% unique(DB$QTL_un_id))){
    stop('The QTL identifier (QTL_id) is not present in the DB')
  }

  unit_lk <- c('[dd]', '[cm]', '[cm]', '[cm]', '[g]', '[kg/ha]') # need to be defined at a higher level (later)
  names(unit_lk) <- c('FLAG', 'PH', 'PAN', 'PED', 'GWGH', 'YIELD')

  tr_nm_ext <- c('Flag leaf', 'Plant height', 'Panicle length', 'Peduncle length',
                 'Grain weight', 'Grain yield')
  names(tr_nm_ext) <- c('FLAG', 'PH', 'PAN', 'PED', 'GWGH', 'YIELD')

  d_q <- DB[QTL_un_id == QTL_id & !is.na(effect)]

  tr_q <- as.character(d_q$trait[1])
  pos_q <- paste0('chr:', d_q$chr[1], ' cM:', round(d_q$cM[1], 2), ' (', d_q$marker[1], ')')

  d_ref <- d_q[, .(pop, RP, par, env, trait, effect, log10pval_Qp)]
  d_ref <- data.table(d_ref[, 1:5], unit = unit_lk[tr_q], d_ref[, 6:7])
  colnames(d_ref)[8] <- '-log10pval'

  d <- d_q[, .(pop, par, env, effect, log10pval_Qp, log10_main, log10_QxE)]

  # main > QxE
  d$effect[(d$log10_main > d$log10_QxE) & d$env != 'main'] <- NA
  # QxE > main
  d$effect[(d$log10_main < d$log10_QxE) & d$env == 'main'] <- NA

  d <- d[, 1:5]
  colnames(d)[5] <- 'log10pval'
  d$log10pval[is.na(d$effect)] <- NA
  d[, 1] <- paste0(d$pop, '_', d$env); colnames(d)[1] <- 'pop_env'
  d <- add_xy_and_dim_id(d = d)

  p <- plot_Qmain_QxE(d = d$d, pop_env_un = d$pop_env_un,
                      par_un = d$p_un, var_unit = unit_lk[tr_q],
                      main = paste(tr_nm_ext[tr_q], '-', pos_q))

  list(p = p, d = d_ref)

}
