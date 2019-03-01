library(rvest)
library(XML)
url <- 'https://www.imdb.com/chart/top?ref_=nv_mv_250'
page <- read_html(url)
movie.nodes <- html_nodes(page,'.titleColumn a')
movie.link = sapply(html_attrs(movie.nodes),`[[`,'href')
movie.link = paste0("http://www.imdb.com",movie.link)
movie.cast = sapply(html_attrs(movie.nodes),`[[`,'title')
movie.name = html_text(movie.nodes)
sec <- html_nodes(page,'.secondaryInfo')
year = as.numeric(gsub(")","",                          # Removing )
                       gsub("\\(","",                   # Removing (
                            html_text( sec )                 # get text of HTML node  
                       )))

rating.nodes = html_nodes(page,'.imdbRating')
# Check One node
xmlTreeParse(rating.nodes[[20]])

rating.nodes = html_nodes(page,'.imdbRating strong')
votes = as.numeric(gsub(',','',
                        gsub(' user ratings','',
                             gsub('.*?based on ','',
                                  sapply(html_attrs(rating.nodes),`[[`,'title')
                             ))))

rating = as.numeric(html_text(rating.nodes))


top250 <- data.frame(movie.name, movie.cast, rating, year, votes, movie.link)

