add_edit <- function(raw_text, edit) {
  
  print(edit)
  
  # on empty, return empty
  if(raw_text == '') {
    return('--')
  }
  
  # first step is to read it in
  write(raw_text, 'tmp.dat')
  tmp <- ReadBib('tmp.dat')
  system('rm tmp.dat')
  
  # read in lib
  lib_df <- readRDS('lib_df.RDS')
  
  # check that it doesn't exist already, if edit = F
  if(!edit) {
    validate(
      need(!(tmp$key %in% rownames(lib_df)), 
           paste(tmp$key, "- this entry already exists. Not added"))
    )
  }

  # make a new bib entry, this is the name for add or edit
  fname <- paste0('lib/',tmp$key)
  WriteBib(tmp,fname)
  
  # update the correct entry in lib.bib / rds or add a new line
  if(edit){
    
  }
  
  # pass this out at last so it can be printed
  return(tmp)
  
}

# delete ref
delete_ref <- function(raw_text) {
  
  write(raw_text, 'tmp.dat')
  tmp <- ReadBib('tmp.dat')
  system('rm tmp.dat')
  
  # delete the *.bib file
  fname <- paste0('lib/',tmp$key, '.bib')
  system(paste('rm', fname))
  
  # remove the entry in the lib_df RDS
  lib_df <- readRDS('lib_df.RDS')
  
  row_to_delete <- which(rownames(lib_df) == tmp$key)
  lib_df <- lib_df[-row_to_delete, ]
  saveRDS(lib_df, 'lib_df.RDS')
  
  # return the key so it can be deleted without a table reload
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


