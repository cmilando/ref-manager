ui <- fluidPage(
  
  shinyjs::useShinyjs(),
  tags$script("Shiny.addCustomMessageHandler('resetInputValue', function(variableName){
                Shiny.onInputChange(variableName, null);
              });
              "),
  
  titlePanel("Ref Manager v1"),
  
  sidebarLayout(
    sidebarPanel(
      uiOutput("checkbox"),
      width = 2
    ),
    
    mainPanel(
      tabsetPanel(id = "inTabset",
        
        tabPanel('Table',
                 textOutput('myText'),
                 DT::dataTableOutput("ref_table")
        ),
        
        tabPanel("Add/Edit", 
                 
                 textAreaInput("raw_bibtex", "raw BiBTex",
                               height = '300px', width = '600px'),
                 
                 actionButton("add_ref_to_lib", "Add"),
                 actionButton("edit_ref_in_lib", "Edit"),
                 actionButton("delete_ref_in_lib", "Delete"),
                 
                 h5('Console output'),
                 verbatimTextOutput("verb", placeholder = T)
        )
        
      )
    )
  )
)