update_library <- function() {
    
    # create a new lib.bib by combining all the various references into one file
    file_names <- list.files(path = "lib", pattern = ".bib", full.names = T)
    n_files <- length(file_names)
    f_out_list <- vector("list", n_files)
    
    system("rm lib.bib")
    f_lib_out <- file("lib.bib", open = "a")
    
    for (i in 1:n_files) {
        f_i = readLines(file_names[i])
        writeLines(f_i, f_lib_out, sep = "\n")
    }
    close(f_lib_out)
    
    # then read it in
    lib <- ReadBib("lib.bib")
    
    # create the data frame
    lib_df <- as.data.frame(lib)
    saveRDS(lib_df, file = "lib_df.rds")
    
    # create the select vars
    if (!file.exists("select_var.RDS")) {
        select_vars <- data.frame(names = names(lib_df), width = 100, selected = 1, 
            order = 1:length(names(lib_df)))
        saveRDS(select_vars, file = "select_var.RDS")
    }
    
}

create_bib_files <- function() {
    
    # removing a column is drop.cols <- c('thesis') lib_df <- lib_df %>%
    # select(-one_of(drop.cols)) saveRDS(lib_df, 'lib_df.RDS')
    
    lib_df <- readRDS("lib_df.rds")
    lib <- as.BibEntry(lib_df)
    
    for (i in 1:length(lib)) {
        bib <- lib[[i]]
        key <- bib$key
        WriteBib(bib = bib, file = paste0("lib/", key, ".bib"))
    }
    
    
}
