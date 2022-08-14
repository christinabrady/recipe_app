library(elastic)
library(jsonlite)

es_conn <- connect(es_host = "localhost") ## to be run on the server
recipe_dat <- Search(conn = es_conn, index='recipes', size = 1000)

## name, ingredients, instructions, tags, date_added
rnames <- lapply(recipe_dat$hits$hits, function(x) return(x$`_source`$name))
ringred <- lapply(recipe_dat$hits$hits, function(x) return(paste(x$`_source`$ingredients, collapse = " | ")))
rinstr <- lapply(recipe_dat$hits$hits, function(x) return(paste(x$`_source`$instructions, collapse = " | ")))
recipetags <- lapply(recipe_dat$hits$hits, function(x) return(paste(x$`_source`$tags, collapse = " | ")))
rdate <- lapply(recipe_dat$hits$hits, function(x) return(x$`_source`$date_added))
# fix nulls so that they don't resolve to nothing
rdate <- lapply(rdate, function(x) if(is.null(x)) return(NA) else(return(x)))

ret <- data.frame(
  cbind(
    unlist(rnames),
    unlist(ringred),
    unlist(rinstr),
    unlist(recipetags),
    unlist(rdate)
  )
)
colnames(ret) <- c("recipe_name", "ingredients", "instructions", "recipe_tags", "date_added")
write.csv(ret, "Documents/data/recipe_backup.csv", row.names = FALSE)
