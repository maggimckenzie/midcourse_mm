#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$placeholder_welcome <- renderText(
        'Welcome!'
    )#close placeholder_welcome
    
    
    
    output$placeholder_winners <- renderText(
        'Winners stats go here.'
    )#close placeholder_winners
    
    output$plot_scores <- renderPlotly({
        ggplotly(
            fj_win_scores %>% 
                select(show_num, season, air_year, contestant, bucket_name, score) %>% 
                ggplot(aes(y = air_year, x = score, color = bucket_name)) +
                geom_point()+
                scale_x_continuous(breaks=seq(0, 150000, 10000)) +
                theme(axis.text.x = element_text(angle= 90))#close plot creation
        )#close ggplotly
    })#close plot_scores/renderPlotly
    
    
    
    output$placeholder_catexp <- renderText(
        'Category exploration goes here.'
    )#close placeholder_catexp
    
    
    
    output$placeceholder_rspexp <- renderText(
        'Response exploration goes here.'
    )#close placeholder_rspexp
    
    
    
    output$placeholder_test <- renderText(
        'Test your knowledge goes here.'
    )#close placeholder_test
    
    
    
    output$placeholder_buzzer <- renderText(
        'Buzzer challenge goes here.'
    )#close placeholder_buzzer
    
    
    
    # output$distPlot <- renderPlot({
    # 
    #     # generate bins based on input$bins from ui.R
    #     x    <- faithful[, 2]
    #     bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # 
    #     # draw the histogram with the specified number of bins
    #     hist(x, breaks = bins, col = 'darkgray', border = 'white')
# 
#     })

})#close shinyServer
