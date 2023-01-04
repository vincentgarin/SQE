#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    # fluidPage(

    navbarPage("SQE: sorghum QTL effects - Beta",

               tabPanel("Description",

                        fluidRow(

                        column(7,

                        tags$strong('General description:'),'This application allow to search for sorghum QTL effects
                        and visualize their additive effect as well as their
                        interaction with environmental covariates (EC).',

                        tags$br(),
                        tags$br(),

                        'The application is based on the results from three sorghum
                        BCNAM populations analyses (Grinkan, Kenin-Keni, and Lata).
                        Part of those populations where phenotyped during different seasons.
                        So, the population are sub-divided given the year it was phenotype
                        (GR2012, GR2013, KK2012, KK2013, Lata)',

                        tags$br(),
                        tags$br(),

                        'The application is composed of three parts: 1) Select QTLs,
                        2) QTL effects and, 3) QTLxEC projections.',

                        tags$br(),
                        tags$br(),

                        tags$strong('1. Select QTL:'), 'Search for QTL positions in
                        all results for specific trait given physical or genetic
                        position on the genome.',

                        tags$br(),
                        tags$br(),

                        tags$strong('2. QTL effect:'), 'Plot the additive parental
                        allelic effects (x axis) for a given QTL position.
                        Those effect can vary given the genetic background and/or
                        the environment (y axis). The detail of the value is returned
                        in a table below the plot.',

                        tags$br(),
                        tags$br(),

                        tags$strong('3. QTLxEC projections:'), 'Visualisation of the QTLxEC
                        interaction for the parental allele that experienced a significant interaction
                        with at least one of 15 environmental covariates.
                        The effect of those parents is projected on a grid of 60 points
                        representing the average value of and environmental covariate measured
                        at different locations in Mali over the seasons 2014 to 2020.
                        Those EC values are multiplied to the QTL allele sensitivity.
                        The results must be interpreted with respect to a reference parent,
                        which is the recurrent parent of the BCNAM populations.',



                        'Copyright - Vincent Garin - CIRAD, IER, ICRISAT'

                        ),

                        column(5,

                               tags$img(height = 450, width = 370, src = 'www/hex-SQE.png'),

                               # tags$br(),
                               # tags$br(),
                               #
                               # tags$img(height = 200, width = 330, src = 'www/Image_champ_IER.jpg'),
                               #
                               # tags$br(),
                               # tags$br(),

                          )

)

                        ),
               tabPanel("Select QTLs",

                        mod_select_QTL_ui("select_QTL")

                        ),
               tabPanel("QTL effects",

                        mod_QTL_effect_ui("QTL_effect")

                        ),
               tabPanel("QTLxEC projections",

                        mod_QTLxEC_effect_ui("QTLxEC_effect")

                        )
    )

    # )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "SQE"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
