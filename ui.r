ui <- fluidPage(
  
  shinyjs::useShinyjs(),
  tags$script("Shiny.addCustomMessageHandler('resetInputValue', function(variableName){
                Shiny.onInputChange(variableName, null);
              });
              "),
  
  titlePanel("Ref Manager v1"),
  
  sidebarLayout(
    sidebarPanel(
      actionButton('backup','Backup DB'),
      uiOutput("checkbox"),
      width = 2
    ),
    
    mainPanel(
      tabsetPanel(id = "inTabset",
        
        tabPanel('Table',width = '50px',
                 textOutput('myText'),
                 DT::dataTableOutput("ref_table")
        ),
        
        tabPanel("Add/Edit", 
                 # column(width = 5,
                 #  uiOutput("refTextInputs")
                 # ),
                 # column(width = 4, offset = 1, 
                   textAreaInput("raw_bibtex", "raw BiBTex",
                                 height = '600px', width = '1000px'),
                  
                   actionButton("add_ref_to_lib", "Add"),
                   actionButton("edit_ref_in_lib", "Save/Edit"),
                   actionButton("delete_ref_in_lib", "Delete")
                   
                 # )
                 
        ),
        
        tabPanel("Table settings",
                 
                 actionButton('update_table', "Update"),
                 rHandsontableOutput("table_settings",width = "100%")
                 
        
        )
        
      )
    )
  )
)