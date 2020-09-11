#!/usr/bin/env Rscript

bookdown::render_book("index.Rmd", "bookdown::gitbook")

file.copy("files", "_book", recursive=TRUE)
