#' QTLxEC_effect UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_QTLxEC_effect_ui <- function(id){
  ns <- NS(id)
  tagList(

    sidebarLayout(
      sidebarPanel(

        # Input arguments
        tags$strong('QTL position'),
        tags$br(),
        tags$br(),
        "Insert a unique QTL position using unique identifier obtained from
        'select QTLs' module to get some details about the QTLxEC allelic effects",
        tags$br(),
        tags$br(),

        selectInput(inputId = ns('QTL_id'), label = NULL, choices = QTL_list),

        tags$br(),
        tags$br(),

        tags$strong('Population'),
        tags$br(),
        tags$br(),
        "Select a population",
        tags$br(),
        tags$br(),

        selectInput(inputId = ns('pop_id'), label = NULL, choices = pop_list,
                    multiple = FALSE),

        tags$br(),
        tags$br(),

        actionButton(ns("click"),label =  "Plot")

      ),

      mainPanel(

        h4('Visualisation QTLxEC effects'),
        plotOutput(ns('p_Qeff1'), height = "600px"),

        tags$br(),

        h4('Visualisation QTLxEC effects Part 2 (if more than four parent alleles)'),
        plotOutput(ns('p_Qeff2'), height = "600px"),

        tags$br()

      )
    )

  )
}

#' QTLxEC_effect Server Functions
#'
#' @noRd
mod_QTLxEC_effect_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # get the input
    QTL_id <- reactive({input$QTL_id})
    pop_id <- reactive({input$pop_id})

    p_Qeff <- eventReactive(input$click, {QTLxEC_projection(DB = DB, QTL_id = QTL_id(),
                                          pop_id = pop_id())})

   output$p_Qeff1 <- renderPlot({p_Qeff()$p1})
   output$p_Qeff2 <- renderPlot({p_Qeff()$p2})


  })
}

## To be copied in the UI
# mod_QTLxEC_effect_ui("QTLxEC_effect_1")

## To be copied in the server
# mod_QTLxEC_effect_server("QTLxEC_effect_1")
