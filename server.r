server <- function(input, output, session) {
    
    #' //////////////////////////////////////////////////////////////////////////
    #' TABLE
    #' //////////////////////////////////////////////////////////////////////////
    
    observeEvent(input$backup, {
        cat("> BACKUP DB\n")
        system("cp lib_df.RDS lib_df_backup.RDS")
        showModal(modalDialog(title = "", "database backup successful"))
    })
    
    observeEvent(input$export_to_pdf, {
        cat("> EXPORT DB TO PDF\n")
        output_table_pdf()
        showModal(modalDialog(title = "", "database to pdf successful"))
    })
    
    df <- reactiveValues()
    df$data <- readRDS("lib_df.RDS")
    observe(df$data$Actions <- shinyInput(actionButton, nrow(df$data), "button_", 
        label = "Edit", onclick = "Shiny.onInputChange(\"select_button\",  this.id)"))
    
    # makes the columns selectable
    output$checkbox <- renderUI({
        
        select_vars <- readRDS("select_var.RDS")
        s_rows <- which(select_vars$selected == 1)
        
        checkboxGroupInput(inputId = "select_var", label = "Select table columns", 
            choices = select_vars$names, selected = select_vars$names[s_rows])
    })
    
    df_sel <- reactive({
        # overwrite the current cols.rds
        req(input$select_var)
        
        select_vars <- readRDS("select_var.RDS")
        select_vars$selected <- 0
        s_rows <- which(select_vars$names %in% input$select_var)
        select_vars$selected[s_rows] <- 1
        saveRDS(select_vars, "select_var.RDS")
        
        df$data[is.na(df$data)] <- "-"
        
        df_sel <- df$data %>% select(Actions, input$select_var) %>% arrange(year)
        
    })
    
    output$ref_table <- DT::renderDataTable({
        my_table <- df_sel()
        if ("url" %in% names(my_table)) {
            my_table$url <- createLink(my_table$url)
        }
        return(my_table)
    }, server = FALSE, escape = FALSE, selection = "none", rownames = FALSE, options = list(pageLength = 100, 
        autoWidth = TRUE, scrollX = TRUE, scrollY = 500, columnDefs = get_widths()))
    
    # ----------------------------------------------------------
    observeEvent(input$select_button, {
        cat("> EDIT ROW CLICKED\n")
        selectedRow <- as.numeric(strsplit(input$select_button, "_")[[1]][2])
        session$sendCustomMessage(type = "resetInputValue", message = "select_button")
        
        action_col <- which(colnames(df$data) == "Actions")
        row_as_bib <- as.BibEntry(df$data[selectedRow, -action_col])
        suppressMessages(WriteBib(row_as_bib, "tmp"))
        this_ref_raw <- readLines("tmp.bib")
        
        updateTextAreaInput(session, "raw_bibtex", value = paste0(this_ref_raw, collapse = "\n"))
        
        updateTabsetPanel(session, "inTabset", selected = "Add/Edit")
        
    })
    
    
    #' ////////////////////////////////////////////////////////////////////////
    #' ADD / EDIT / DELETE
    #' ////////////////////////////////////////////////////////////////////////
    
    observeEvent(input$add_ref_to_lib, {
        add_edit(input$raw_bibtex, "add")
        df$data <- readRDS("lib_df.RDS")
        updateTabsetPanel(session, "inTabset", selected = "Table")
        showNotification(paste("Ref add successful"), duration = 3, type = "message")
    })
    
    observeEvent(input$edit_ref_in_lib, {
        add_edit(input$raw_bibtex, "edit")
        df$data <- readRDS("lib_df.RDS")
        updateTabsetPanel(session, "inTabset", selected = "Table")
        showNotification(paste("Ref edit successful"), duration = 3, type = "message")
    })
    
    observeEvent(input$delete_ref_in_lib, {
        key_to_delete <- add_edit(input$raw_bibtex, "delete")
        df$data <- readRDS("lib_df.RDS")
        updateTabsetPanel(session, "inTabset", selected = "Table")
        showNotification(paste("Ref delete successful"), duration = 3, type = "message")
    })
    
    #' ////////////////////////////////////////////////////////////////////////
    #' TABLE SETTINGS
    #' ////////////////////////////////////////////////////////////////////////
    
    output$table_settings = renderRHandsontable({
        req(input$select_var)
        DF <- readRDS("select_var.RDS")
        
        rhandsontable(DF) %>% hot_table(highlightCol = TRUE, highlightRow = TRUE) %>% 
            hot_cols(colWidths = c(125, 100, 100, 100), manualColumnResize = T, columnSorting = T) %>% 
            hot_col(col = "names", readOnly = T)
    })
    
    observeEvent(input$update_table, {
        
        output_table <- hot_to_r(input$table_settings) %>% arrange(order)
        saveRDS(output_table, "select_var.RDS")
        
    })
    
}
