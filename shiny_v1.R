library(shiny)
library(RefManageR)

## the files are the article name .ref

server <- function(input, output) {
  ## have a dropdown to select the directory
  ## this will also have a json of project-specific inputs
  ## like what things are in the table currently
  
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

}

ui <- fluidPage(
  titlePanel("Ref Manager v1"),
  sidebarLayout(
    sidebarPanel(
      selectInput("library_loc", "Choose a library:",
                  choices = c("lib"))
    ),
    mainPanel(
      tabsetPanel(
        
        tabPanel("Add", 
                 textAreaInput("raw_bibtex_add", "raw BiBTex",
                               height = '300px', width = '600px'),
                 actionButton("add_ref_to_lib", "Add ref to lib"),
                 br(),br(),
                 verbatimTextOutput("verb")
                 ),
        
        tabPanel("Edit", 
                 verbatimTextOutput('key'),
                 textAreaInput("raw_bibtex_edit", "raw BiBTex",
                               height = '300px', width = '600px'),
                 actionButton("edit_ref_in_lib", "Edit ref in lib"))


      )
    )
  )
)

a <- shinyApp(ui = ui, server = server)

runApp(a)
