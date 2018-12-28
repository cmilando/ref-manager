## setup

# make directories
system('mkdir lib')
system('mkdir pdfs')
system('mkdir tmp')

# make an empty data.frame
lib_df <- data.frame()
saveRDS(lib_df, 'lib_df.RDS')

select_vars <- data.frame()
saveRDS(select_vars, file = "select_var.RDS")
