## server

function(session, input, output){
  updateSelectizeInput(session, 'getinstr', server = TRUE, choices = names)
  updateSelectizeInput(session, 'tagsearch', server = TRUE, choices = tgs)
  updateSelectizeInput(session, 'rtag', server = TRUE, choices = tgs)

  observeEvent(input$sinsubmit, {
      dat <- m$find(sprintf('{"$text": {"$search":"\\"%s\\""}}', input$ingred))
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
    print(toJSON(newrecipe))
    m$insert(toJSON(newrecipe))
    })

  }
