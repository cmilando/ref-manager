library(RefManageR)

# create a new lib.bib by combining all the various references into one file


# then read it in
lib <- ReadBib('lib.bib')

# create the data
lib_df <- as.data.frame(lib)
lib_df$Actions <- NA

# get this list from a text box or output file

# some thing where you can choose the columns
lib_df <- lib_df[, c('Actions','title', 'author')]

saveRDS(lib_df, file = 'lib_df.rds')


# - not run
# for (i in 1:length(lib)) {
#   fname <- paste0('lib/',lib[[i]]$key)
#   WriteBib(lib[[i]],fname)
# }

