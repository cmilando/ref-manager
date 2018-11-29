update_library <- function() {

  # create a new lib.bib by combining all the various references into one file
  file_names <- list.files(path = 'lib', pattern = '.bib', full.names = T)
  n_files <- length(file_names)
  f_out_list <- vector('list', n_files)
  
  system('rm lib.bib')
  f_lib_out <- file('lib.bib', open = 'a')
  
  for (i in 1:n_files) {
    f_i = readLines(file_names[i])
    writeLines(f_i, f_lib_out, sep = '\n')
  }
  close(f_lib_out)
  
  # then read it in
  lib <- ReadBib('lib.bib')
  
  # create the data
  lib_df <- as.data.frame(lib)
  lib_df$Actions <- NA
  lib_df$id <- rownames(lib_df)
  lib_df <- lib_df %>% 
    select(Actions, year, title, everything())
  
  saveRDS(lib_df, file = 'lib_df.rds')
  saveRDS(names(lib_df), file = 'select_var.RDS')
  
}

# - not run
# for (i in 1:length(lib)) {
#   fname <- paste0('lib/',lib[[i]]$key)
#   WriteBib(lib[[i]],fname)
# }


update_index <- function(key, new_entry) {
  
  lib <- ReadBib('lib.bib')
  
}
