#' plot_QpxEC
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd

# consider a possibility to plot two graph if more than four alleles
# interact

plot_QpxEC <- function(d_p, EC_range, Mali_layer, size_txt = 5, main, var_id,
                       text.size = 18){

  # text information
  d_text <- d_p[, .(B = round(mean(B), 3)), by = .(par, EC)]
  d_text <- d_text[!(par == 'EC')]
  d_text$B <- paste0('B = ', d_text$B)

  EC_range$EC <- factor(rownames(EC_range), levels = levels(d_p$EC))
  EC_range$par = factor('EC', levels = levels(d_p$par))
  EC_range$rg <- paste0('DAS: ', EC_range$start, '-', EC_range$end)

  # filter the EC
  EC_range <- EC_range[as.character(unique(d_p$EC)), ]

  # plot QpxEC
  QEC_plot <- Mali_layer +
    geom_point(data=d_p, shape = 20, aes(long, lat, color = y_pred, size = logpval)) +
    coord_equal() +
    scale_colour_gradient(low = "#2166AC", high = "#B2182B", name = var_id) +
    # facet_grid(rows = vars(EC), cols = vars(par), switch = "y") +
    facet_grid(EC ~ par, switch = "y") +

    geom_text(data = d_text, size = size_txt,
              mapping = aes(x = -7.5, y = 14.7, label = B)) +

    geom_text(data = EC_range, size = size_txt,
              mapping = aes(x = -7.5, y = 14.7, label = rg)) +

    ggtitle(main) + theme(axis.title.x = element_text(size=text.size),
                          axis.title.y = element_text(size=text.size),
                          axis.text.y = element_text(size = text.size-4),
                          axis.text.x = element_text(size = text.size-4),
                          plot.title = element_text(size=(text.size)),
                          strip.text.x =  element_text(size=text.size-2),
                          strip.text.y =  element_text(size=text.size-2),
                          legend.title = element_text(size=(text.size)),
                          legend.text = element_text(size=(text.size)))

  return(QEC_plot)

}
