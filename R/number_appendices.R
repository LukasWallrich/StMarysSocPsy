library(xml2)
library(magrittr)

###
# START ALPHABETICAL NUMBER FROM THIS MANY CHAPTERS
start_letters <- 11
###

files <- list.files("./_book", pattern = "\\.html$")

purrr::walk(file.path("_book", files), function(file_name) {
browser()
x <- xml2::read_html(file_name)
y <- xml_find_all(x, '//*[@class="chapter"]')
z <- y[xml_find_lgl(y,'not(number(substring(@data-level, 1, 1)+1))')]
z <- z[-1]
cntr <- 1
purrr::map(z, function(x) {
  
  chapter <- x %>% xml_attr("data-level") 
  if(stringr::str_sub(chapter, 1, 1) != LETTERS[cntr]) cntr <<- cntr + 1
  if (cntr < start_letters) {
  xml_text(x) <- chapter %>% stringr::str_replace(LETTERS[cntr], as.character(cntr))
  } else {
  xml_text(x) <- chapter %>% stringr::str_replace(LETTERS[cntr], LETTERS[cntr-start_letters+1])
}})
write_html(x, file_name)
})
