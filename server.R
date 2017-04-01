## server

function(session, input, output){
  updateSelectizeInput(session, 'getinstr', server = TRUE, choices = sort(names))
  updateSelectizeInput(session, 'tagsearch', server = TRUE, choices = tgs)
  updateSelectizeInput(session, 'rtag', server = TRUE, choices = tgs)

  observeEvent(input$sinsubmit, {
      dat <- m$find(sprintf('{"$text": {"$search":"\\"%s\\""}}', tolower(input$ingred)))
      sch$insert(toJSON(createSearchList("ingredient", tolower(input$ingred))))
      for(i in 1:nrow(dat)){
        insertUI(
          selector = "#placeholder",
          where = "afterEnd",
          ui = createTabBox(dat, i)
        )
      }
  })
  observeEvent(input$stagsubmit, {
    dat <- m$find(sprintf('{"tags":"%s"}', input$tagsearch))
    sch$insert(toJSON(createSearchList("tag", tolower(input$tagsearch))))
    for(i in 1:nrow(dat)){
      insertUI(
        selector = "#placeholder",
        where = "afterEnd",
        ui = createTabBox(dat, i)
      )
    }
  })

  observeEvent(input$snamesubmit, {
    dat <- m$find(sprintf('{"name":"%s"}', input$getinstr))
    sch$insert(toJSON(createSearchList("recipe_name", tolower(input$getinstr))))
    for(i in 1:nrow(dat)){
      insertUI(
        selector = "#placeholder",
        where = "afterEnd",
        ui = createTabBox(dat, i)
      )
    }
  })

  #### saving new recipes
  observeEvent(input$save, {
    newrecipe <- list()
    newrecipe[["name"]] <- input$rname
    newrecipe[["ingredients"]] <- sapply(strsplit(input$ringred, "\\n"), trimws)
    newrecipe[["instructions"]] <- sapply(strsplit(input$rinstru, "\\n"), trimws)
    newrecipe[["tags"]] <- sapply(strsplit(input$rtag, "\\n"), trimws)
    # newrecipe[["date_added"]] <- as.character(Sys.Date())
    print(toJSON(newrecipe))
    js_string <- 'alert("Thanks for the new recipe! I look forward to using it!");'
    session$sendCustomMessage(type='jsCode', list(value = js_string))
    m$insert(toJSON(newrecipe))
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
