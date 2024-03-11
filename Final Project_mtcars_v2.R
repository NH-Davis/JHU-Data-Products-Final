# This is a script for creating a shiny app that allows users
# to select car types from the mtcars dataset based on two options
# transmission type and mpg

library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Vehicle Selector Based on Transmission and MPG"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("transmission", "Transmission Type:",
                   choices = list("Automatic" = 0, "Manual" = 1)),
      sliderInput("mpg",
                  "Minimum MPG:",
                  min = min(mtcars$mpg),
                  max = max(mtcars$mpg),
                  value = 0.0), # Default value set for a better user experience
      actionButton("submit", "Submit")
    ),
    
    mainPanel(
      textOutput("vehicleList")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  observeEvent(input$submit, {
    # Convert the transmission input to numeric to ensure correct type matching
    transmissionInput <- as.numeric(input$transmission)
    
    cat("Transmission input (after conversion):", transmissionInput, "\n")
    
    # Filter by transmission type
    filteredByTransmission <- mtcars[mtcars$am == transmissionInput, ]
    cat("Filtered by transmission count:", nrow(filteredByTransmission), "\n")
    
    # Filter by MPG
    finalFiltered <- filteredByTransmission[filteredByTransmission$mpg >= input$mpg, ]
    cat("Final filtered count:", nrow(finalFiltered), "\n")
    
    if(nrow(finalFiltered) > 0) {
      vehicleNames <- rownames(finalFiltered)
      outputText <- paste("Here is a list of vehicles that meets your standards:", paste(vehicleNames, collapse = ", "), sep = "\n")
    } else {
      outputText <- "No vehicles meet your standards."
    }
    
    output$vehicleList <- renderText({ outputText })
  })
}

# Run the app
shinyApp(ui = ui, server = server)
