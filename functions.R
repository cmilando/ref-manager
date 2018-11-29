add_edit <- function(raw_text, edit) {
  
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