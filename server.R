library(feather)
library(shiny)
library(shinydashboard)
library(survey)
library(plotly)
library(tidyr)

data <- read_feather("Data")
sap.w <- svydesign(id = ~1, data = data[!is.na(data$w),], weights = ~w)

shinyServer(function(input, output) {
  
  formula1 <- reactive(
    as.formula(paste0("~m8+" , input$var1))
  )
  
  table1 <- reactive({
    x <- data.frame(round(prop.table(svytable(formula1(), sap.w), 1)*100,2)) 
    x[x==0] <- NA
    x
  })
  
  formula2a <- reactive(
    as.formula(paste0("~m8+" , input$var1 , "+" , input$Var2))
  )
  table2a <- reactive({
    x <- as.data.frame(round(prop.table(svytable(formula2a(), sap.w), c(1,3))*100,2))
    x[x==0] <- NA
    x
  })    
  
  output$table1 <- renderTable(
    if (input$crosstab==F) {
      table1()  %>% spread(m8, Freq) 
    } else {
      table2a()  %>% spread(m8, Freq)
    }
  )
  
  output$Data <- downloadHandler(
    filename = function() {
      paste("SAP.csv")
    },
    content = function(file) {
      if (input$crosstab==F) {
        write.csv(table1() %>% spread(m8, Freq) , file, row.names = FALSE)
      } else {
        write.csv(table2a() %>% spread(m8, Freq) , file, row.names = FALSE)
      }
    }
  )
  
  output$table2 <- renderDataTable(table2() %>% spread(m8, Freq) ) 
  
  output$plot <- renderPlotly(
    plot_ly(table1(), x = ~m8, y = ~Freq, color = table1()[[2]]) %>% add_lines() %>% layout(yaxis = list(title = ""), xaxis = list(title = ""), legend = list(orientation = "h", xanchor = "center", x = .5))     
  )

})
