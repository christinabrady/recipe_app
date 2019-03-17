
library(jsonlite)
library(elastic)
connect(es_host = "localhost")

dpath <- "~/Documents/codebase/shiny_apps/recipe_app"
fls <- list.files(dpath, pattern = "json", full.names = T)
backup <- fromJSON(fls)
recipes <- backup[[4]]$hits$`_source`
docs_bulk(recipes, index = "recipes", es_ids = T)

# curl -X PUT "localhost:9200/recipes" -H 'Content-Type: application/json' -d'
#  {
#    "mappings": {
#      "_doc": {
#        "properties": {
#          "tags": {
#            "type": "text",
#            "fields": {
#              "keyword": {
#                "type": "keyword"
#              }
#            }
#          }
#        }
#      }
#    }
#  }'
