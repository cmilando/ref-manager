server <- function(input, output, session) {
  
  #' ////////////////////////////////////////////////////////////////////////
  #' TABLE
  #' ////////////////////////////////////////////////////////////////////////
  
  ## have a dropdown to select the directory
  ## this will also have a json of project-specific inputs
  ## like what things are in the table currently
  
  # this is for the buttons on 
  shinyInput <- function(FUN, len, id, ...) {
    inputs <- character(len)
    for (i in seq_len(len)) {
      inputs[i] <- as.character(FUN(paste0(id, i), ...))
    }
    inputs
  }
  
  # this should read from a summary.Rdata, which can be modified
  df <- reactiveValues()
  
  # so it seems like all formatting has to happen before this
  df$data <- readRDS('lib_df.RDS')
  
  # this makes it reactive
  observe(df$data$Actions <- shinyInput(actionButton, nrow(df$data), 'button_', label = "Edit", 
                                onclick = 'Shiny.onInputChange(\"select_button\",  this.id)' ))
  
  output$ref_table <- DT::renderDataTable(
    df$data, server = FALSE, escape = FALSE, selection = 'none'
  )
  
  observeEvent(input$select_button, {
    selectedRow <- as.numeric(strsplit(input$select_button, "_")[[1]][2])
    ref_id <- rownames(df$data)[selectedRow]
    updateSelectInput(session, 'select_ref', selected = paste0(ref_id, '.bib'))
    updateTabsetPanel(session, "inTabset", selected = "Edit")
  })
  
  
  #' ////////////////////////////////////////////////////////////////////////
  #' ADD
  #' ////////////////////////////////////////////////////////////////////////
  rawBibTex_added <- eventReactive(input$add_ref_to_lib, {
    
    write(input$raw_bibtex_add, 'tmp.dat')
    tmp <- ReadBib('tmp.dat')
    system('rm tmp.dat')
    
    fname <- paste0('lib/',tmp$key)
    WriteBib(tmp,fname)
    paste0(fname,'.bib')
    
  }, ignoreNULL = F)
  
  output$verb <- renderPrint({
    ref <- rawBibTex_added()
    tryCatch({ ReadBib(ref) },
             error = function(e) {})
  })
  
  #' ////////////////////////////////////////////////////////////////////////
  #' EDIT
  #' ////////////////////////////////////////////////////////////////////////
  observeEvent(input$select_ref,{ 

    fname <- paste0('lib/',input$select_ref)
    this_ref <- ReadBib(fname)
    this_ref_raw <- readLines(fname)

    updateTextAreaInput(session, "raw_bibtex_edit", value = paste0(this_ref_raw, collapse = '\n'))
    
  })
}