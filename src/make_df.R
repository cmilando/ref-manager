update_library <- function() {
    
    # eject early if empty
    if (length(list.files('lib')) > 0) {
        
        # create a new lib.bib by combining all the various
        # references into one file
        file_names <- list.files(path = "lib", pattern = ".bib", 
            full.names = T)
        n_files <- length(file_names)
        f_out_list <- vector("list", n_files)
        
        unlink("tmp/lib.bib")
        f_lib_out <- file("tmp/lib.bib", open = "a")
        
        for (i in 1:n_files) {
            f_i = readLines(file_names[i])
            writeLines(f_i, f_lib_out, sep = "\n")
        }
        close(f_lib_out)
        
        # then read it in
        lib <- ReadBib("tmp/lib.bib")
        
        # create the data frame
        lib_df <- as.data.frame(lib)
        saveRDS(lib_df, file = "tmp/lib_df.rds")
        
    } else {
        
        cat("> NO lib files => FRESH START\n")
        # then read it in
        lib <- ReadBib("dat/lib_default.bib")
        suppressMessages(WriteBib(lib, 'tmp/lib.bib'))
        suppressMessages(WriteBib(lib, 'lib/default.bib'))
        
        # create the data frame
        lib_df <- as.data.frame(lib)
        saveRDS(lib_df, file = "tmp/lib_df.rds")
        
    }
    
    # create the select vars
    if (!file.exists("tmp/select_var.RDS")) {
      
        select_vars <- data.frame(names = names(lib_df), width = 100, 
            selected = 1, order = 1:length(names(lib_df)))
        saveRDS(select_vars, file = "tmp/select_var.RDS")
        
    }
    
}

create_bib_files <- function() {
    
    # removing a column is drop.cols <- c('thesis') lib_df <-
    # lib_df %>% select(-one_of(drop.cols))
    
    # rename a column is old_name <- 'link' new_name <- 'url'
    # replace_col <- which(names(lib_df) == old_name)
    # names(lib_df)[replace_col] <- new_name
    
    # saveRDS(lib_df, 'lib_df.RDS')
    
    lib_df <- readRDS("tmp/lib_df.rds")
    lib <- as.BibEntry(lib_df)
    
    for (i in 1:length(lib)) {
        bib <- lib[[i]]
        key <- bib$key
        WriteBib(bib = bib, file = paste0("lib/", key, ".bib"))
    }
    
    
}
