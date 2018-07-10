library(feather)
library(shiny)
library(shinydashboard)
library(survey)
library(plotly)
library(tidyr)

data <- read_feather("Data")
sap.w <- svydesign(id = ~1, data = data[!is.na(data$w),], weights = ~w)

dashboardPage( skin = "purple",
               dashboardHeader(title = "Afghanistan: A Survey of the Afghan People 2016-2017", titleWidth = 520),
               dashboardSidebar( width = 350,
                 sidebarMenu(
                   menuItem("Table", tabName = "onevar", icon = icon("table")),
                   menuItem("Plot", tabName = "plot1", icon = icon("line-chart")),
                   menuItem("Source code", icon = icon("code"), 
                            href = "https://github.com/Fahim-Ahmad/Survey-of-the-Afghan-People")
                 ),
                 br(),
                 selectInput("var1", "select variable", choices = names(sap.w$variables), selected = "x4"))
  ,
               dashboardBody(
                 tabItems(
                   tabItem(tabName = "onevar", 
                           fluidRow(checkboxInput("crosstab", "Cross tabulation", F),
                                    conditionalPanel("input.crosstab", selectInput("Var2", "Select variable", choices = c(Gender = "z1", `CSO Geographic Code` = "m6b", Province = "m7", Region = "m4", Age = "z2", `Do you yourseld do any activity that generate money?` = "z52", `[Filtered] And what type of activity is that?` = "z53", ` Are you married or single?`= "z9", `Which ethnic group do you belong to?` = "z10", ` Will you please tell me which of the following categories best represents your average total family monthly income? ` = "z13a", `Do female members of the family contribute to this household income?` = "z13b" , ` What is the highest level (grade) of school you have completed, not including schooling in Islamic madrasa?` = "z55" ), selected = "z1")),
                                    downloadButton("Data", "Downlaod as csv  file"),
                                    br(),
                                    tableOutput("table1")
                           )),
                   
                   tabItem(tabName= "plot1",
                           fluidRow(
                             plotlyOutput("plot")
                             
                           )))))

