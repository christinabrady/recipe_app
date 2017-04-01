# setwd("Documents/shiny_apps/recipe_app/")
library(jsonlite)

flnmes <- list.files("./recipes/")

recipesToJSON <- function(flnme){
  tmp <- tolower(readLines(sprintf("./recipes/%s", flnme)))
  tmp <- tmp[tmp != ""]
  tmp <- sapply(tmp, trimws)
  nme <- which(tmp == "name")
  ingred <- which(tmp == "ingredients")
  instr <- which(tmp == "instructions")
  tgs <- which(tmp == "tags")
  rlist <- list()
  rlist[["name"]] <- tmp[(nme+1):(ingred - 1)]
  rlist[["ingredients"]] <- tmp[(ingred + 1):(instr -1)]
  rlist[["instructions"]] <- tmp[(instr +1):(tgs -1)]
  rlist[["tags"]] <- tmp[(tgs + 1)]
  toJSON(rlist)
}

starters <- lapply(flnmes, recipesToJSON)
m <- mongo(collection = "recipes")
lapply(starters, function(str) m$insert(str))

#### create a text index in the mongo console:
db.recipes.createIndex({ ingredients: "text"})

#### then I can search text
# db.recipes.find({ $text: { $search: "black beans"}})
# m$find('{"$text": {"$search":"black beans"}}')  ### this searches for 'black' or 'bean'... to search for a phrase, it has to be escaped
# # db.recipes.find({ $text: { $search: "\"black beans\""}})
# m$find('{"$text": {"$search":"\\"black beans\\""}}')
# m$find(sprintf('{"$text": {"$search":"\\"%s\\""}}', "black beans"))
# m$find('{"ingredients":{"$in":"black beans"}}')
