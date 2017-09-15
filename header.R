
library(tools)
library(dplR)
library(tools)

source('custom_functions.r')
source('class_defs.R')
source('class_methods.R')

#' Fill from Excel
aim3_lib <- ref_lib()
objects(aim3_lib@hash)

dir <- '../../Research/3 - Aim 3/'
fname = 'Lit_Review v2.xlsx'

aim3_lib <- fillFromExcel(aim3_lib, dir, fname)

printDB(aim3_lib)


