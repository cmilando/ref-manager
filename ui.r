ui <- fluidPage(
  titlePanel("Ref Manager v1"),
  sidebarLayout(
    sidebarPanel(
      selectInput("library_loc", "Choose a library:",
                  choices = c("lib")),
      width = 2
    ),
    mainPanel(
      tabsetPanel(id = "inTabset",
        
        tabPanel('Table',
                 textOutput('myText'),
                 DT::dataTableOutput("ref_table")
                 
        ),
        
        tabPanel("Add", 
                 textAreaInput("raw_bibtex_add", "raw BiBTex",
                               height = '300px', width = '600px'),
                 actionButton("add_ref_to_lib", "Add ref to lib"),
                 br(),br(),
                 verbatimTextOutput("verb")
        ),
        
        tabPanel("Edit", 
                 selectInput('select_ref', 'Select Reference', 
                             choices = list.files(path = 'lib', pattern = '.bib')),
                 verbatimTextOutput('key'),
                 textAreaInput("raw_bibtex_edit", "raw BiBTex",
                               height = '300px', width = '600px'),
                 actionButton("edit_ref_in_lib", "Edit ref in lib"))
        
        
      )
    )
  )
)