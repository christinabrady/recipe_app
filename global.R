library(elastic)
connect(es_host = "192.168.1.6")

distinct_tags_qry <- '{
    "aggs" : {
      "tags" : {
        "terms" : { "field" : "tags.keyword", "size" : 1000}
    }
  }
}'

distinct_recipe_qry <- '{
    "aggs" : {
      "tags" : {
        "terms" : { "field" : "name.keyword", "size" : 1000}
    }
  }
}'


tag_names <- sapply(Search(index="recipes", body=distinct_tags_qry)$aggregations$tags$buckets, function(tg) return(tg$key))
recipe_names <- sapply(Search(index="recipes", body=distinct_recipe_qry)$aggregations$tags$buckets, function(tg) return(tg$key))

textareaInput <- function(id, label, value, rows=20, cols=35, class="form-control"){
  tags$div(
    class="form-group shiny-input-container",
    tags$label('for'=id,label),
    tags$textarea(id=id,class=class,rows=rows,cols=cols,value))
  }

ingredientformat <- function(ingred_list){
  if(length(ingred_list) != 0){
    sprintf('
    <p style="padding-center: 100px;"><span style="color: #000000;">%s</span></p>
    ', paste(unlist(ingred_list), collapse = "<br/>")
    )
  } else{
    '<p style="padding-center: 100px;"><span style="color: #000000;"><strong></strong></span></p>'
  }
}

createTabBox <- function(dat, n){
  tabBox(width = 6, title = HTML(sprintf("<strong>%s</strong>", dat[[n]]$`_source`$name)),
    tabPanel("Ingredients",
      HTML(ingredientformat(dat[[n]]$`_source`$ingredients))
      ),
    tabPanel("Instructions",
      HTML(paste(dat[[n]]$`_source`$instructions, collapse = "<br/>"))
      )
  )
}
