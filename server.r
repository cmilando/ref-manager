server <- function(input, output, session) {
  
  #' //////////////////////////////////////////////////////////////////////////
  #' TABLE
  #' //////////////////////////////////////////////////////////////////////////
  
  df <- reactiveValues()
  df$data <- readRDS('lib_df.RDS')
  observe(df$data$Actions <- 
            shinyInput(actionButton, nrow(df$data), 'button_', label = "Edit", 
                       onclick = 'Shiny.onInputChange(\"select_button\",  this.id)'))
  
  # makes the columns selectable
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

    selectedRow <- as.numeric(strsplit(input$select_button, "_")[[1]][2])
    ref_id <- rownames(df$data)[selectedRow]
    session$sendCustomMessage(type = 'resetInputValue', message =  "select_button")
    
    fname <- paste0('lib/',ref_id, '.bib')
    this_ref <- ReadBib(fname)
    this_ref_raw <- readLines(fname)
    
    updateTextAreaInput(session, "raw_bibtex", 
                        value = paste0(this_ref_raw, collapse = '\n'))
    
    updateTabsetPanel(session, "inTabset", selected = "Add/Edit")
  
  })
  

  #' ////////////////////////////////////////////////////////////////////////
  #' ADD / EDIT / DELETE
  #' ////////////////////////////////////////////////////////////////////////
  
  observeEvent(input$add_ref_to_lib, {
    add_edit(input$raw_bibtex, 'add')
    df$data <- readRDS('lib_df.RDS')
    updateTabsetPanel(session, "inTabset", selected = "Table")
  })
  
  observeEvent(input$edit_ref_in_lib, {
    add_edit(input$raw_bibtex, 'edit')
    df$data <- readRDS('lib_df.RDS')
    updateTabsetPanel(session, "inTabset", selected = "Table")
  })
  
  observeEvent(input$delete_ref_in_lib, {
    key_to_delete <- add_edit(input$raw_bibtex, "delete")
    row_to_delete <- which(rownames(df$data) == key_to_delete)
    df$data <- df$data[-row_to_delete, ]
    updateTabsetPanel(session, "inTabset", selected = "Table")
  })
  

}