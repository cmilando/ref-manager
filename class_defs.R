ref <- setClass(
  
  #' Class name
  "ref",
  
  #' define slots
  slots = c(
    link     = 'character',
    citation = 'character',
    abstract = 'character',
    notes    = 'character'
  )
  
)

ref_lib <- setClass( 
  
  #' Class name
  "ref_lib",
  
  #' define slots
  slots = c(
    library = 'list',
    n = 'numeric'
  ),
  
  prototype = list(
    library = list(),
    n = 0
  )
  
  
)



