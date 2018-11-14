
library(tools)

system('rm temp.*')
sink("temp.Rnw")

cat('
\\documentclass{article}
\\usepackage[top=0.3in, bottom=0.3in, left=0.3in, right=0.3in]{geometry}
\\usepackage{Sweave}
\\usepackage[utf8]{inputenc}

\\usepackage{hyperref}
\\hypersetup{colorlinks=true,urlcolor=blue,}

\\begin{document}
')

cat("
\\end{document}
")

sink()
Sweave("temp.Rnw")

texi2pdf('temp.tex')
