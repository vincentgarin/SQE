#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import data.table
#' @importFrom dplyr group_by summarise %>% arrange
#' @import ggplot2
#'
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  # test module
  # counterServer("counter1")

  # QTL selection
  mod_select_QTL_server("select_QTL")

  # QTL effects
  mod_QTL_effect_server("QTL_effect")

  # QTLxEC effects
  mod_QTLxEC_effect_server("QTLxEC_effect")
}
