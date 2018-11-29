add_edit <- function(raw_text, add_edit_delete) {
  
  # on empty, return empty
  if(raw_text == '') return()

  # first step is to read it in and delete the existing .bib file
  write(raw_text, 'tmp.dat')
  tmp <- ReadBib('tmp.dat')
  system('rm tmp.dat')
  fname <- paste0('lib/',tmp$key)

  # read in lib
  lib_df <- readRDS('lib_df.RDS')
  
  # unless you are adding, delete the row
  if(add_edit_delete %in% c('edit', 'delete')) {
    system(paste0('rm ', fname, '.bib'))
    row_to_delete <- which(rownames(lib_df) == tmp$key)
    lib_df <- lib_df[-row_to_delete, ]
  }
  
  # make a new full library entry
  lib_as_bib <- as.BibEntry(lib_df)
  WriteBib(lib_as_bib, 'lib')
  
  if(add_edit_delete %in% c('add', 'edit')) {
    WriteBib(tmp, fname)
    f_lib_out <- file('lib.bib', open = 'a')
    writeLines(raw_text, f_lib_out, sep = '\n')
    close(f_lib_out)
  }
  
  # then read it in
  lib <- ReadBib('lib.bib')
  
  # create the data, this will automatically sort things for you
  lib_df <- as.data.frame(lib)
  lib_df$Actions <- NA
  lib_df$id <- rownames(lib_df)
  lib_df <- lib_df %>% 
    select(Actions, year, title, everything())
  
  saveRDS(lib_df, file = 'lib_df.rds')
  
  return(tmp$key)
  
}


# this is to add buttons in the DT rows.
# source: https://stackoverflow.com/questions/45739303/r-shiny-handle-action-buttons-in-data-table 
shinyInput <- function(FUN, len, id, ...) {
  inputs <- character(len)
  for (i in seq_len(len)) {
    inputs[i] <- as.character(FUN(paste0(id, i), ...))
  }
  inputs
}


