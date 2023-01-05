#' select_QTL UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_select_QTL_ui <- function(id){
  ns <- NS(id)
  tagList(

    sidebarLayout(
    sidebarPanel(

        # Description
        tags$strong('Description:'),
        'Search for QTL positions in the database using trait, chromosome, and
    position information. QTL effect can also be subsetted according to R2 value',
        tags$br(),
        tags$br(),

        selectInput(inputId = ns('trait_id'), label = 'Select a trait', choices = trait_list,
                    multiple = FALSE),

        selectInput(inputId = ns('chr_id'), label = 'Select chromosome(s)', choices = chr_list,
                    multiple = TRUE, selected = 1),

        'Select physical boundaries ...',
        fluidRow(column(6, numericInput(inputId = ns('bp_low'),
                                        label = 'Lower boundary [bp]',
                                        value = 0, min = 0, max = 100000000,
                                        width = '100%')),
                 column(6, numericInput(inputId = ns('bp_up'),
                                        label = 'Upper boundary [bp]',
                                        value = 100000000, min = 1, max = 100000000,
                                        width = '100%'))
                 ),
        '... or Genetic boundaries',
        fluidRow(column(6, numericInput(inputId = ns('cM_low'),
                                        label = 'Lower boundary [cM]',
                                        value = 0, min = 0, max = 180,
                                        width = '100%')),
                 column(6, numericInput(inputId = ns('cM_up'),
                                        label = 'Upper boundary [cM]',
                                        value = 1000, min = 1, max = 181,
                                        width = '100%'))
                 ),

        radioButtons(inputId = ns('dist_crit'), label = 'Filter by',
                     choices = list(`Physical distance` = 'ph_dis', `Genetic distance` = 'gen_dis')),

        'Optional filter by R2 value [0-100]',
        numericInput(inputId = ns('R2'), label = 'minimum R2 value',
                     value = 0, min = 0, max = 100),
        tags$br(),

        actionButton(ns("click"),label =  "Search"),

      ),

      mainPanel(

        h4('QTL effect significance [-log10(p-value)]'),
        tags$br(),
        tableOutput(ns('Q_sign')),
        tags$br(),

        h4('QTL R2'),
        tags$br(),
        tableOutput(ns('Q_R2')),
        tags$br(),

        h4('QTL range of additive effects'),
        tags$br(),
        tableOutput(ns('Q_eff')),
        tags$br(),

        'List of unique QTL position that can be copied to get extra information about the QTL effect and the QTLxEC interaction.',
         tags$br(),
         textOutput(ns('QTL_id')),
        tags$br(),
        tags$br()

        )
   )

  )
}

#' select_QTL Server Functions
#'
#' @noRd
mod_select_QTL_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # get the input
    trait_id <- reactive({input$trait_id})
    chr_id <- reactive({input$chr_id})
    bp_low <- reactive({input$bp_low})
    bp_up <- reactive({input$bp_up})
    cM_low <- reactive({input$cM_low})
    cM_up <- reactive({input$cM_up})
    dist_crit <- reactive({input$dist_crit})
    R2_lim <- reactive({input$R2})

    Q_list <- eventReactive(input$click, {
      QTL_candidates_wrapper(DB = DB, trait_id = trait_id(), chr_id = chr_id(),
                             dist_crit = dist_crit(),
                             bp_low = bp_low(), bp_up = bp_up(),
                             cM_low = cM_low(), cM_up = cM_up(), R2 = R2_lim())})

    QTL_id <- reactive({unlist(Q_list()$Q_sign[, 1])})

    output$Q_sign <- renderTable({Q_list()$Q_sign})
    output$Q_R2 <- renderTable({Q_list()$Q_R2})
    output$Q_eff <- renderTable({Q_list()$Q_eff})

    output$QTL_id <- renderText({QTL_id()})

    # output$trait_id <- renderText({trait_id()})



  })
}

## To be copied in the UI
# mod_select_QTL_ui("select_QTL_1")

## To be copied in the server
# mod_select_QTL_server("select_QTL_1")
