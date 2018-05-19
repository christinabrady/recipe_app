## server

function(session, input, output){
  updateSelectizeInput(session, 'tag_search', server = TRUE, choices = tag_names)
  updateSelectizeInput(session, 'rtag', server = TRUE, choices = tag_names)

  observeEvent(input$sinsubmit, {
      results <- Search(index = "recipes", q = input$es_search)$hits$hits
      print(results)
      for(i in 1:length(results)){
        insertUI(
          selector = "#placeholder",
          where = "afterEnd",
          ui = createTabBox(results, i)
        )
      }
  })
  observeEvent(input$taginput, {
    tag_search_qry <- sprintf('{
      "query": {
         "match": { "tags": "%s" }
      }
    }', input$tag_search)

    tag_results <- Search(index = "recipes", body = tag_search_qry)$hits$hits
    for(i in 1:length(tag_results)){
      insertUI(
        selector = "#placeholder",
        where = "afterEnd",
        ui = createTabBox(tag_results, i)
      )
    }
  })


  #### saving new recipes
  observeEvent(input$save, {
    newrecipe <- list()
    newrecipe[["name"]] <- input$rname
    newrecipe[["ingredients"]] <- sapply(strsplit(input$ringred, "\\n")[[1]], trimws)
    newrecipe[["instructions"]] <- sapply(strsplit(input$rinstru, "\\n")[[1]], trimws)
    newrecipe[["tags"]] <- sapply(strsplit(input$rtag, "\\n")[[1]], trimws)
    newrecipe[["date_added"]] <- as.character(Sys.Date())
    js_string <- 'alert("Thanks for the new recipe! I look forward to using it!");'
    session$sendCustomMessage(type='jsCode', list(value = js_string))
    docs_create(index = "recipes", type = "recipes", body = newrecipe, id = paste(input$rname, Sys.Date(), collapse = ""))
    })

  #### revise recipes
  ### get values for text inputs
  observeEvent(input$go, {
    revdat <- m$find(sprintf('{"name":"%s"}', input$revr))
    selected <- revdat$tags[[1]]
    output$revisename <- renderUI({
      textInput("revname", "Name", value = revdat$name)
    })
    output$reviseingreds <- renderUI({
      textareaInput("revingred","Ingredients", value = paste(unlist(revdat$ingredients), collapse = ","), rows = 10, cols = 35)
    })
    output$reviseinstrs <- renderUI({
      textareaInput("revinstru","Instructions", value = paste(unlist(revdat$instructions), collapse = ","), rows = 10, cols = 35)
    })
    output$revisetags <- renderUI({
      selectizeInput("revtag", "Tags", choices = tgs, selected = selected, options = list(create = TRUE), multiple = TRUE)
    })
  })


  observeEvent(input$updt, {
    mongoid <- m$find(sprintf('{"name":"%s"}', input$revr), field = '{"_id":1}')
    revrec <- list()
    revrec[["name"]] <- input$revname
    revrec[["ingredients"]] <- sapply(strsplit(input$revingred, "\\n"), trimws)
    revrec[["instructions"]] <- sapply(strsplit(input$revinstru, "\\n"), trimws)
    revrec[["tags"]] <- sapply(strsplit(input$revtag, "\\n"), trimws)
    print(toJSON(revrec))
    js_string <- 'alert("Thanks for the update!");'
    session$sendCustomMessage(type='jsCode', list(value = js_string))
    m$update(query = paste0('{"_id": { "$oid" : "', mongoid, '" } }'),
             sprintf(update = '{ "$set" : %s }', toJSON(revrec)))
    })

  }
