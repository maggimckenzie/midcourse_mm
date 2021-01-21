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
    
    output$plot_catexp <- renderGirafe({
        p <- ggplot()+
            geom_polygon_interactive(data = cat.gg, aes(x, y, group = id, fill = id, tooltip = cat_occurs_gt1$text[id], data_id = id),  alpha = 0.6)+
            scale_fill_viridis() +
            geom_text(data = cat_occurs_gt1, aes(x, y, label = category), size=2.5, fontface = 'bold', color='black') + 
            theme_void()+
            theme(legend.position='none', plot.margin=unit(c(0,0,0,0),'cm'), panel.background = element_rect(fill = 'transparent', color = NA))+
            coord_equal()
        ggiraph(ggobj = p, bg = 'transparent')
    })#close plot_catexp
    
    output$dt_catexp <- DT::renderDT({
        clues %>%
            filter(category == 'AMERICAN HISTORY') %>%
            select(clue_text, corr_resp)
    })#close dt_rsexp
    
    
    output$placeholder_rspexp <- renderText(
        'Response exploration goes here.'
    )#close placeholder_rspexp
    
    output$plot_rspexp <- renderGirafe({
        p_r<- ggplot()+
            geom_polygon_interactive(data = resp.gg, aes(x, y, group = id, fill = id, tooltip = resp_occurs_gt1$text[id], data_id = id),  alpha = 0.6)+
            scale_fill_viridis() +
            geom_text(data = resp_occurs_gt1, aes(x, y, label = corr_resp), size=2.5, fontface = 'bold', color='black') + 
            theme_void()+
            theme(legend.position='none', plot.margin=unit(c(0,0,0,0),'cm'), panel.background = element_rect(fill = 'transparent', color = NA))+
            coord_equal()
        ggiraph(ggobj = p_r, bg = 'transparent')
    })#close plot_rspexp
    
    # observeEvent(input$Plot_rsexp_selected, {
    #     output$dt_rsexp <- DT::renderDT({
    #         react <- clues %>% 
    #             filter(corr_resp == input$plot_rsexp_selected) #[which(clues$corr_resp==input$plot_rsexp_selected),]
    #     })
    # })
    
    output$dt_rspexp <- DT::renderDT({
        clues %>%
            filter(corr_resp == 'Australia') %>%
            select(category, clue_text)
    })#close dt_rspexp

    output$index <- renderUI({
        selectInput('cat_index', 'Category index', choices = as.character(catyr_occurs[catyr_occurs$air_year == input$year, 'cat_index']))
    })#close index
    
    output$categories <- renderUI({
        selectInput('cat_list', 'Categories', choices = as.character(catyr_occurs[(catyr_occurs$air_year == input$year) & 
                                                                                      (catyr_occurs$cat_index == input$cat_index), 'category']))
    })#close categories
    
    output$dt_category <- DT::renderDT({
        show_nums <- catyr_occurs %>% 
            filter(air_year == input$year) %>% 
            filter(category == input$cat_list) %>% 
            select(category, show_num)
        show_nums <- show_nums %>% 
            inner_join(clues, by = c('category', 'show_num')) %>% 
            select(air_date, round_code, clue_text, corr_resp)
    })#close dt_category
    
    
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
