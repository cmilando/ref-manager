# create a method to assign the value of a coordinate
setGeneric(name="addRef",
           def=function(theObject, ref)
           {
             standardGeneric("addRef")
           }
)

setMethod(f="addRef",
          signature="ref_lib",
          definition=function(theObject,ref)
          {
            if(theObject@n == 0) {
              theObject@library <- c(ref)
            } else {
              theObject@library <- c(theObject@library, ref)
            }
              
            theObject@n <- theObject@n + 1
            
            return(theObject)
          }
)


# create a method to fill from Excel db
setGeneric(name="fillFromExcel",
           def=function(theObject, dir, fname)
           {
             standardGeneric("fillFromExcel")
           }
)


setMethod(f="fillFromExcel",
          signature="ref_lib",
          
          definition=function(theObject, dir, fname)
            
          {
            
            library(XLConnect)
            
            getA1 <- function(w, sht) {
              names(readWorksheet(w, sheet = 'DB',startCol = 1, endCol = 1,
                                  startRow = 1, endRow = 1, readStrategy = "fast"))
            }
            
            w <- loadWorkbook(paste0(dir,fname))
            sht <- 'DB'
            
            A1 <- getA1(w, sht)
            setCellFormula(w, sht, 1, 1, 'VALUE(COUNTA(A2:A200000))')
            row_n <- as.integer(gsub("X","", getA1(w, sht)))
            cat('Rows in DB:',row_n,'\n')
            
            raw <- readWorksheet(w, sheet = 'DB', startRow = 1, endRow = row_n + 1)
            
            for(i in 1:row_n) {
              
              ref <- new('ref')
              slot(ref, 'link') <- raw[i, 2]
              slot(ref, 'citation') <- raw[i, 1]
              slot(ref, 'abstract') <- raw[i, 3]
              slot(ref, 'notes') <- raw[i, 4]
              
              theObject <- addRef(theObject, ref)
              
              
            }
            
            return(theObject)
            
          }
)