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
  
  # add the action button
  observe(df$data$Actions <- shinyInput(actionButton, nrow(df$data), 'button_', label = "Edit", 
                                        onclick = 'Shiny.onInputChange(\"select_button\",  this.id)'))
  
  output$checkbox <- renderUI({
    checkboxGroupInput(inputId = "select_var", 
                       label = "Select Feature variables", 
                       choices = names(df$data),
                       selected = readRDS('select_var.RDS'))
  })
  
  df_sel <- reactive({
    
    #overwrite the current cols.rds
    req(input$select_var)
    saveRDS(input$select_var, 'select_var.RDS')
    
    df_sel <- df$data %>% select(input$select_var)
  })
  
  output$ref_table <- DT::renderDataTable({
      df_sel()
    }, server = FALSE, escape = FALSE, 
           selection = 'none', rownames= FALSE)
  
  observeEvent(input$select_button, {
    
    print('>> EDIT REFERENCE CLICKED FROM DT')
    selectedRow <- as.numeric(strsplit(input$select_button, "_")[[1]][2])
    ref_id <- rownames(df$data)[selectedRow]
    session$sendCustomMessage(type = 'resetInputValue', message =  "select_button") # this is bc reactive
    
    fname <- paste0('lib/',ref_id, '.bib')
    this_ref <- ReadBib(fname)
    this_ref_raw <- readLines(fname)
    
    updateTextAreaInput(session, "raw_bibtex", 
                        value = paste0(this_ref_raw, collapse = '\n'))
    
    updateTabsetPanel(session, "inTabset", selected = "Add/Edit")
  
  })
  

  #' ////////////////////////////////////////////////////////////////////////
  #' ADD / EDIT
  #' ////////////////////////////////////////////////////////////////////////
  rawBibTex_added <- eventReactive(input$add_ref_to_lib, {
    add_edit(input$raw_bibtex, edit = F)
  }, ignoreNULL = F)
  
  rawBibTex_edited <- eventReactive(input$edit_ref_in_lib, {
    add_edit(input$raw_bibtex, edit = T)
  }, ignoreNULL = F)
  
  output$verb <- renderPrint({
    rawBibTex_added()
    rawBibTex_edited()
  })
  
  
}