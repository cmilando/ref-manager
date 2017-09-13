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
            #' add the new library object
            if(theObject@n == 0) {
              theObject@library <- c(ref)
            } else {
              theObject@library <- c(theObject@library, ref)
            }
            
            #' iterate library size by 1
            theObject@n <- theObject@n + 1
            
            #' add contents to the hash table
            get_keys <- function(s) {
              s1 <- gsub("\n", " ", s)
              s2 <- gsub("\t", " ", s1)
              s3 <- gsub("[[:punct:]]", "", s2)
              s4a <- strsplit(s3, " ")[[1]]
              s4b <- strsplit(tolower(s3), " ")[[1]]
              s5 <- sort(unique(c(s4a, s4b)))
              return(s5[s5 != ''])
            }
            
            citation_keys <- get_keys(ref@citation)
            abstract_keys <- get_keys(ref@abstract)
            notes_keys <- get_keys(ref@notes)
            keys_to_add <- as.list(unique(c(citation_keys,
                                            abstract_keys, notes_keys)))
            
            add_to_hash <- function(x, v, h) {
              val <- c()
              if(exists(x, h)) val <- get(x, h)
              assign(x, c(v, val), h)
            }
            
            for(key in keys_to_add) 
              add_to_hash(key, theObject@n, theObject@hash)
            
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
            cat('Sources in DB:',row_n,'\n')
            
            raw <- readWorksheet(w, sheet = 'DB', startRow = 1, endRow = row_n + 1)
            
            for(i in 1:row_n) {
              
              ref <- new('ref')
              slot(ref, 'id') <- theObject@n + 1
              slot(ref, 'date_added') <- as.POSIXlt(Sys.time())
              slot(ref, 'link') <- raw[i, 2]
              slot(ref, 'citation') <- raw[i, 1]
              slot(ref, 'abstract') <- raw[i, 3]
              slot(ref, 'notes') <- raw[i, 4]
              
              theObject <- addRef(theObject, ref)
              
            }
            
            return(theObject)
            
          }
)