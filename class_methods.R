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
            
            citation_keys <- get_keys(ref@citation)
            abstract_keys <- get_keys(ref@abstract)
            notes_keys <- get_keys(ref@notes)
            keys_to_add <- as.list(unique(c(citation_keys,
                                            abstract_keys, notes_keys)))
            
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

#' method for searching the db


#' method for printing nicely
setGeneric(name="printDB",
           def=function(theObject)
           {
             standardGeneric("printDB")
           }
)

setMethod(f="printDB",
          signature="ref_lib",

          definition=function(theObject)

          {
            library(xtable)
            library(tools)
            library(Unicode)
            
            fname <- substitute(theObject)
            
            cat_list <- get_cat_list(theObject)

            sink(paste0('tmp/',fname,".Rnw"))
            
            cat('
            \\documentclass{article}
            \\usepackage[top=0.3in, bottom=0.3in, left=0.3in, right=0.3in]{geometry}
            \\usepackage{Sweave}
            \\usepackage[utf8]{inputenc}
            
            \\usepackage{hyperref}
            \\hypersetup{colorlinks=true,urlcolor=blue,}
            
            \\usepackage{changepage}
            
            \\begin{document}
            ')
            
            invisible(cat(cat_list))
            
            cat("
            \\end{document}
            ")
            
            sink()
            Sweave(paste0('tmp/',fname,".Rnw"))
            
            texi2pdf(paste0(fname,".tex"),clean = T, quiet = F)
            
            system(paste('mv',paste0(fname,".tex"),
                         paste0('tmp/',fname,".tex")))
            
            system(paste('mv',paste0(fname,".pdf"),
                         paste0('pdfs/',fname,".pdf")))

          }
)