#' plot_Qmain_QxE
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
plot_Qmain_QxE <- function(d, pop_env_un, par_un, var_unit, main, text.size = 18){

  # define the bolded text.y [could be removed later if problem with ggplot2]
  face.y <- rep('plain', length(pop_env_un))
  face.y[grep(pattern = '_main', x = pop_env_un)] <- 'bold'

  p <- ggplot(d, aes(x=x, y=y, fill = effect)) +
    geom_point(aes(size = log10pval, shape='tested')) +
    geom_point(data=subset(d, not_tested), aes(shape='not tested'), size=3) +
    scale_fill_gradient2(low = "red", mid = "white", high = "blue",
                         guide = guide_colorbar(order = 1), name = var_unit) +
    scale_shape_manual(values=c('tested'=21, 'not tested'=4), breaks = c('tested', 'not tested'), name = 'status') +
    scale_y_continuous(breaks = 1:length(pop_env_un), labels = rev(pop_env_un)) +
    scale_x_continuous(breaks = 1:length(par_un), labels = as.character(par_un),
                       position = "top") +
    xlab("Parents") + ylab("Population x Environment") +
    ggtitle(main) +
    theme(axis.title.x = element_text(size=text.size),
          axis.title.y = element_text(size=text.size),
          axis.text.y = element_text(size = text.size-2, face = rev(face.y)),
          axis.text.x = element_text(size = text.size-4, angle = 45),
          plot.title = element_text(size=(text.size+2)),
          strip.text.x =  element_text(size=text.size),
          legend.title = element_text(size=(text.size)),
          legend.text = element_text(size=(text.size)))

  return(p)

}
