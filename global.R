library(mongolite)
library(jsonlite)
m  <- mongo(collection = "recipes")
names <- m$distinct("name")
tgs <- m$distinct("tags")
# tags <- tags[!is.na(tags)]

textareaInput <- function(id, label, value, rows=20, cols=35, class="form-control"){
  tags$div(
    class="form-group shiny-input-container",
    tags$label('for'=id,label),
    tags$textarea(id=id,class=class,rows=rows,cols=cols,value))
  }

ingredientformat <- function(df){
  if(nrow(df) != 0){
    sprintf('
    <p style="padding-center: 100px;"><span style="color: #000000;">%s</span></p>
    ', paste(unlist(df$ingredients), collapse = "<br/>")
    )
  } else{
    '<p style="padding-center: 100px;"><span style="color: #000000;"><strong></strong></span></p>'
  }
}

createTabBox <- function(dat, n){
  tabBox(width = 6, title = HTML(sprintf("<strong>%s</strong>", dat$name[[n]])),
    tabPanel("Ingredients",
      HTML(ingredientformat(dat[n, ]))
      ),
    tabPanel("Instructions",
      HTML(paste(dat$instructions[[n]], collapse = "<br/>"))
      )
  )
}
