add_edit <- function(raw_text, add_edit_delete) {
    
    # on empty, return empty
    if (raw_text == "") 
        return()
    
    # first step is to read it in and delete the existing .bib file
    write(raw_text, "tmp.dat")
    tmp <- ReadBib("tmp.dat")
    system("rm tmp.dat")
    fname <- paste0("lib/", tmp$key)
    
    # read in lib
    lib_df <- readRDS("lib_df.RDS")
    
    # unless you are adding, delete the row
    if (add_edit_delete %in% c("edit", "delete")) {
        system(paste0("rm ", fname, ".bib"))
        row_to_delete <- which(rownames(lib_df) == tmp$key)
        lib_df <- lib_df[-row_to_delete, ]
    }
    
    # make a new full library entry
    lib_as_bib <- as.BibEntry(lib_df)
    WriteBib(lib_as_bib, "lib")
    
    if (add_edit_delete %in% c("add", "edit")) {
        WriteBib(tmp, fname)
        f_lib_out <- file("lib.bib", open = "a")
        writeLines(raw_text, f_lib_out, sep = "\n")
        close(f_lib_out)
    }
    
    # then read it in
    lib <- ReadBib("lib.bib")
    
    # create the data, this will automatically sort things for you
    lib_df <- as.data.frame(lib)
    
    saveRDS(lib_df, file = "lib_df.rds")
    
    # update the select_var
    select_var_prev <- readRDS('select_var.RDS')
    select_var_prev$names <- as.character(select_var_prev$names)
    if(!identical(sort(names(lib_df)), sort(select_var_prev$names))) {
      xx <- data.frame(names = names(lib_df), 
                                width = 100, 
                                selected = 0, 
                                order = length(names(lib_df)),
                       stringsAsFactors = F)
      for(i in 1:nrow(xx)) {
        if(xx$names[i] %in% select_var_prev$names) {
          j <- which(select_var_prev$names == xx$names[i])
          xx[i, ] <- select_var_prev[j, ]
        }
      }
      saveRDS(xx, 'select_var.RDS')
    }
    
    return(tmp$key)
    
}


# this is to add buttons in the DT rows.  source:
# https://stackoverflow.com/questions/45739303/r-shiny-handle-action-buttons-in-data-table
shinyInput <- function(FUN, len, id, ...) {
    inputs <- character(len)
    for (i in seq_len(len)) {
        inputs[i] <- as.character(FUN(paste0(id, i), ...))
    }
    inputs
}

get_widths <- function() {
    select_vars <- readRDS("select_var.RDS")
    select_vars_T <- filter(select_vars, selected == 1)
    out <- lapply(0:nrow(select_vars_T), function(i) {
        if (i == 0) {
            list(targets = i, width = "20px")  # for the action column
        } else {
            list(targets = i, width = paste0(select_vars_T$width[i], "px"))
        }
    })
    print('re-render table')
    print(do.call(rbind, out))
    return(out)
}

createLink <- function(vals) {
  vals_out <- vector('character', length(vals))
  for(i in 1:length(vals)) {
    val <- vals[i]
    if(val != '-') {
      vals_out[i] <- sprintf('<a href="%s" target="_blank" class="btn btn-primary">link</a>',val)
    } else {
      vals_out[i] <-val
    }
  }
  return(vals_out)
}

# output$refTextInputs <- renderUI({ tmp <- ReadBib('tmp.dat') flat_tmp
# <- unlist(tmp) unique_names <- make.unique(names(flat_tmp))
# names(flat_tmp) <- unique_names n_elements <- length(unlist(tmp))
# lapply(1:n_elements, function(i) { val <- flat_tmp[[i]]
# if(length(val) > 1) val <- paste(val, collapse = '|')
# textAreaInput(inputId = paste0('refText_', unique_names[i]), label =
# unique_names[i], value = val, width = '500px') }) })
