library(feather)
library(shiny)
library(shinydashboard)
library(survey)
library(plotly)
library(tidyr)

data <- read_feather("Data")
sap.w <- svydesign(id = ~1, data = data[!is.na(data$w),], weights = ~w)

dashboardPage( skin = "blue",
               dashboardHeader(title = "Survey of Afghan People", titleWidth = 300),
               dashboardSidebar(
                 sidebarMenu(
                   menuItem("Table", tabName = "onevar", icon = icon("table")),
                   menuItem("Plot", tabName = "plot1", icon = icon("line-chart")),
                   menuItem("Source code", icon = icon("code"), 
                            href = "https://github.com/Fahim-Ahmad")
                 ),
                 br(),
                 selectInput("var1", "select variable", choices = names(sap.w$variables), selected = "x4")
               ),
               dashboardBody(
                 tabItems(
                   tabItem(tabName = "onevar", 
                           fluidRow(checkboxInput("crosstab", "Cross tabulation", F),
                                    conditionalPanel("input.crosstab", selectInput("Var2", "Select variable", choices = c(Gender = "z1", `CSO Geographic Code` = "m6b", Province = "m7", Region = "m4", Age = "age", `do you yourseld do any activity that generate money` = "z52", ` Are you married or single?`= "z9", `Which ethnic group do you belong` = "z10"), selected = "z1")),
                                    downloadButton("Data", "Downlaod as csv  file"),
                                    br(),
                                    tableOutput("table1")
                           )),
                   
                   tabItem(tabName= "plot1",
                           fluidRow(
                             plotlyOutput("plot")
                             
                           )))))

