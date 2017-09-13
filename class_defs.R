ref <- setClass(
  
  #' Class name
  "ref",
  
  #' define slots
  slots = c(
    id         = 'numeric',
    date_added = 'POSIXlt',
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
    n = 'numeric',
    hash = 'environment'
  ),
  
  prototype = list(
    library = list(),
    n = 0,
    hash = new.env(hash=TRUE, parent=emptyenv(), size=100L)
  )
  
  
)



