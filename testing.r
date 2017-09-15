
library(tools)
library(dplR)
library(tools)

cat_list <- aim3_lib@library[[9]]@abstract
cat_list_u <- latexify(cat_list, doublebackslash = F)

fname <- 'test'

sink(paste0('tmp/',fname,".Rnw"))

cat('
    \\documentclass{article}
    \\usepackage[top=0.3in, bottom=0.3in, left=0.3in, right=0.3in]{geometry}
    \\usepackage[utf8]{inputenc}
    \\usepackage{textgreek}    

    \\usepackage{hyperref}
    \\hypersetup{colorlinks=true,urlcolor=blue,}
    \\begin{document}
    ')

invisible(cat(cat_list_u))

cat("
    \\end{document}
    ")

sink()
Sweave(paste0('tmp/',fname,".Rnw"))








texi2pdf(paste0(fname,".tex"), clean = T)
