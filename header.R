source('class_defs.R')
source('class_methods.R')

#' Fill from Excel
test_lib <- new('ref_lib')

dir <- '../../Research/3 - Aim 3/'
fname = 'Lit_Review v2.xlsx'

test_lib <- fillFromExcel(test_lib, dir, fname)

