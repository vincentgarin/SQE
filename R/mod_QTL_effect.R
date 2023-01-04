#' QTL_effect UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_QTL_effect_ui <- function(id){
  ns <- NS(id)
  tagList(

    sidebarLayout(
      sidebarPanel(

        # Description
        tags$strong('QTL position'),
        tags$br(),
        tags$br(),
        "Insert a unique QTL position using unique identifier obtained from
        'select QTLs' module to get some details about the QTL allelic effects",
        tags$br(),
        tags$br(),

        selectInput(inputId = ns('QTL_id'), label = NULL, choices = QTL_list),

        tags$br(),
        tags$br(),

        actionButton(ns("click"),label =  "Plot")

      ),

      mainPanel(

        h4('Visualisation QTL effects'),
        tags$br(),
        plotOutput(ns('p_Qeff'), height = "600px"),

        tags$br(),
        tags$br(),

        h4('Detail QTL allelic effects'),
        tags$br(),
        tableOutput(ns('d_eff'))

      )
    )
  )
}

#' QTL_effect Server Functions
#'
#' @noRd
mod_QTL_effect_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # get the input
    QTL_id <- reactive({input$QTL_id})
    p_Qeff <- eventReactive(input$click, {QTL_effect_detail(DB = DB, QTL_id())})

    output$p_Qeff <- renderPlot({p_Qeff()$p})
    output$d_eff <- renderTable({p_Qeff()$d})

  })
}

## To be copied in the UI
# mod_QTL_effect_ui("QTL_effect_1")

## To be copied in the server
# mod_QTL_effect_server("QTL_effect_1")
