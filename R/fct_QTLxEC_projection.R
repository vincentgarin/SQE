#' QTLxEC_projection
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
QTLxEC_projection <- function(DB, QTL_id, pop_id = 'GR2012', d_thre = 1.301,
                              year_range = 2014:2020, ref_day = 181){

  n_year <- length(year_range)

  # unit_lk <- c('[dd]', '[cm]', '[cm]', '[cm]', '[g]', '[kg/ha]') # need to be defined at a higher level (later)
  # names(unit_lk) <- c('FLAG', 'PH', 'PAN', 'PED', 'GWGH', 'YIELD')
  #
  # tr_nm_ext <- c('Flag leaf', 'Plant height', 'Panicle length', 'Peduncle length',
  #                'Grain weight', 'Grain yield')
  # names(tr_nm_ext) <- c('FLAG', 'PH', 'PAN', 'PED', 'GWGH', 'YIELD')
  #
  # EC_ref <- c('rain', 'hum', 'VPD', 'SPV', 'ETP', 'PETP', 'Tmin', 'Tmax',
  #             'Trange', 'DD', 'FRUE', 'hSun', 'photoperiod', 'solarRad', 'photothermal')
  #
  # c_EC <- paste0(EC_ref, "_sign")
  # c_M <- c("pop", "par", "log10_main", "log10_QxE")
  #
  # EC_fct_lk <- c('sum', rep('mean', 8), 'sum', 'mean', 'sum', 'mean', 'sum', 'sum')
  # names(EC_fct_lk) <- EC_ref

  # Check what kind of QTL effects we have
  d_q <- DB[QTL_un_id == QTL_id & pop == pop_id & !is.na(effect)]

  d_EC <- d_q[, ..c_EC]
  d_EC[d_EC < d_thre] <- NA
  d_EC[is.na(d_EC)] <- 0
  QEC <- apply(X = d_EC, 1, FUN = function(x) sum(x) > 0)

  d_q_EC <- d_q[QEC, , drop = FALSE]

  if(nrow(d_q_EC) !=0){

    tr_q <- as.character(d_q$trait[1])
    # if(tr_q == 'FLAG'){ tr_q_EC <- 'FLAGDD'} else {tr_q_EC <- tr_q} # need to harmonize later the names of the DB and EC best list
    pos_q <- paste0('chr:', d_q$chr[1], ' cM:', round(d_q$cM[1], 2), ' (', d_q$marker[1], ')')

    # get the main, B and B sign for the QTL position
    d_Qeff <- data.frame(d_q_EC)
    rownames(d_Qeff) <- paste(d_Qeff$pop, d_Qeff$par, sep = '_')

    d_main <- d_Qeff[, 23:37, drop = FALSE]
    d_B <- d_Qeff[, 38:52, drop = FALSE]
    d_sign <- d_cond <-  d_Qeff[, 53:67, drop = FALSE]
    colnames(d_main) <- colnames(d_B) <- colnames(d_sign) <- EC_ref

    d_sign <- red_tab(dt = d_sign, d_cond = d_cond, thre = d_thre)
    d_main <- red_tab(dt = d_main, d_cond = d_cond, thre = d_thre)
    d_B <- red_tab(dt = d_B, d_cond = d_cond, thre = d_thre)
    meta_inf <- strsplit(x = rownames(d_sign), split = '_')
    pop_v <- sapply(X = meta_inf, `[[`, 1)


    EC_pt <- EC_best_list[[pop_id]][[tr_q]][, 1:2]
    EC_pt_list <- rownames(EC_pt)
    n_EC_pt <- length(EC_pt_list)

    EC_mat <- matrix(NA, nrow = length(met_list_ext), ncol = n_EC_pt)

    # loop over the EC and the years
    for(ec in 1:n_EC_pt){

      EC_ec <- EC_pt_list[ec]
      EC_mat_ec <- matrix(NA, nrow = length(met_list_ext), ncol = n_year)

      for(y in 1:n_year){

        EC_vect <- get_EC_val(EC = EC_pt_list[ec], year = year_range[y],
                              stat = EC_fct_lk[EC_ec], grid_list = met_list_ext,
                              start = EC_pt[ec, 1] + ref_day,
                              end = EC_pt[ec, 2] + ref_day)

        EC_mat_ec[, y] <- EC_vect
      }

      EC_mat[, ec] <- rowMeans(x = EC_mat_ec, na.rm = TRUE)

    }

    colnames(EC_mat) <- EC_pt_list
    rownames(EC_mat) <- names(met_list_ext)

    d_EC <- pop_EC_par_mat_form(d_B = d_B, d_main = d_main, d_sign = d_sign,
                                v_sel = pop_v == pop_id,
                                meta_inf = meta_inf)

    # restrict the EC mat to only the selected EC
    EC_mat <- EC_mat[, unique(as.character(d_EC$EC)), drop = FALSE]

    d_p <- EC_proj(d_EC = d_EC, EC_mat = EC_mat, lat_lon = lat_lon)

    title_pt <- paste(pop_id, tr_nm_ext[tr_q], '-', pos_q)

    # number of parent allele
    p_alleles <- as.character(unique(d_p$par))
    p_alleles <- p_alleles[-which(p_alleles == 'EC')]
    n_p_allele <- length(p_alleles)
    list_plot <- vector(mode = 'list', length = 2)

    if(n_p_allele > 4){

      # split the parent to plot into two groups
      n_lim <- ceiling(n_p_allele/2)
      p_alleles_1 <- c('EC', p_alleles[1:n_lim])
      p_alleles_2 <- c('EC', p_alleles[(n_lim + 1):n_p_allele])

      list_plot[[1]] <- plot_QpxEC(d_p = d_p[par %in% p_alleles_1], EC_range = EC_pt,
                                   Mali_layer = Mali_layer,
                                   main = title_pt, var_id = unit_lk[tr_q])

      list_plot[[2]] <- plot_QpxEC(d_p = d_p[par %in% p_alleles_2], EC_range = EC_pt,
                                   Mali_layer = Mali_layer,
                                   main = title_pt, var_id = unit_lk[tr_q])

    } else {

      list_plot[[1]] <- plot_QpxEC(d_p = d_p, EC_range = EC_pt, Mali_layer = Mali_layer,
                                   main = title_pt, var_id = unit_lk[tr_q])

    }

    names(list_plot) <- c('p1', 'p2')

    return(list_plot)

  } else { return(NULL) }

}
