## ui

library(shiny)
library(shinydashboard)

# source("./global.R")

shinyUI(navbarPage("Recipes", theme = "bootstrap.css",
	tabPanel("Search Recipies",
		fluidRow(), 
		fluidRow(),
		fluidRow(
			column(2,offset = 5
				textInput("es_search", label = "What do you want to search for?"),
				actionButton("sinsubmit", "GO!")
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
				tags$head(tags$script(HTML('Shiny.addCustomMessageHandler("jsCode",function(message) {eval(message.value);});'))),
				actionButton("save", "Save")
				)
			)
		),
		tabPanel("Modify recipes",
			fluidRow(
				column(width = 3),
				column(width = 8,
					selectInput("revr", "Which recipe would you like to revise?", choices = names),
					actionButton("go", "Find"),
					uiOutput("revisename"),
					uiOutput("reviseingreds"),
					br(),
					uiOutput("reviseinstrs"),
					uiOutput("revisetags"),
					tags$head(tags$script(HTML('Shiny.addCustomMessageHandler("jsCode",function(message) {eval(message.value);});'))),
					actionButton("updt", "Update")
					)
				)
			)
	))
