## ui

library(shiny)
library(shinydashboard)

# source("./global.R")

shinyUI(navbarPage("Recipes", theme = "bootstrap.css",
	tabPanel("Search Recipies",
		fluidRow(
			column(2,
				textInput("ingred", label = "What ingredient do you want to search for?"),
				actionButton("sinsubmit", "GO!"),
				selectizeInput("tagsearch", "Which tag do you want to look for?", choices = NULL, options = list(create = TRUE)),
				actionButton("stagsubmit", "GO!"),
				selectizeInput("getinstr", "Which recipe do you want to find?", choices = NULL, options = list(create = TRUE)),
				actionButton("snamesubmit", "GO!")
			),
			column(8,
				tags$div(id = "placeholder")
			)
			)
		),
	tabPanel("Add recipes",
		fluidRow(
			column(width = 3),
			column(width = 8,
				textInput("rname", "What is the name of your recipe?"),
				textareaInput("ringred","Copy ingredients here", "", rows = 10, cols = 35),
				br(),
				textareaInput("rinstru","Copy instructions here.", "", rows = 10, cols = 35),
				selectizeInput("rtag", "Would you like to add any tags?", choices = NULL, options = list(create = TRUE), multiple = TRUE),
				actionButton("save", "Save")
				)
			)
		),
		tabPanel("Modify recipes",
			fluidRow(
				column(width = 3),
				column(width = 8,
					selectInput("revr", "Which recipe would you like to revise?", choices = names),
					textInput("revname", "Name"),
					textareaInput("revingred","Ingredients", "", rows = 10, cols = 35),
					br(),
					textareaInput("revinstru","Instructions", "", rows = 10, cols = 35),
					selectizeInput("revtag", "Tags", choices = NULL, options = list(create = TRUE), multiple = TRUE),
					actionButton("updt", "Update")
					)
				)
			)
	))
