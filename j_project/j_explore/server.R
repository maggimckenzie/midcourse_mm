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
    
    output$plot_scores <- renderGirafe({
        p_s<-ggplot()+
            geom_point_interactive(data = fj_scores,aes(x = air_year, y = score, color = bucket_name, tooltip = text1), alpha = .4, position = 'jitter', size =2.5) +
            scale_color_viridis(discrete = TRUE)+
            scale_y_continuous('Score', breaks=seq(0, 140000, 20000), labels=scales::dollar_format()) +
            scale_x_continuous('Year', breaks=seq(2001, 2021, 1))+
            theme(axis.text.x = element_text(angle= 90), legend.position = 'none', plot.background = element_rect(fill='transparent', color = NA), 
                  panel.background = element_rect(fill='transparent', color = NA), panel.grid.major = element_blank())#close plot creation
        ggiraph(ggobj =  p_s, bg = 'transparent')
    })#close plot_scores/renderGirafe
    
    output$plot_median <- renderGirafe({
        p_m <- fj_median %>% 
            ggplot(aes(x = Year, y = Score))+
            geom_point_interactive(aes(x = air_year, y = high_score, col = 'high_score', tooltip = high_scorer), size = 2, alpha = 0.6)+
            geom_line(aes(x = air_year, y = high_score, col = 'high_score'), size = 2, alpha = 0.6)+
            geom_point_interactive(aes(x = air_year, y = median_score, col = 'median_score'), size = 2, alpha = 0.6)+
            geom_line(aes(x = air_year, y = median_score, col = 'median_score'), size = 2, alpha = 0.6)+
            scale_color_viridis(discrete = TRUE, begin = .6, end = .2, labels = c('High Score', 'Median Score'))+
            scale_y_continuous('Score', breaks=seq(0, 140000, 20000), labels=scales::dollar_format()) +
            scale_x_continuous('Year', breaks=seq(2001, 2021, 1))+
            theme(axis.text.x = element_text(angle= 90), legend.position = 'none', legend.title = element_blank(), panel.grid.minor = element_blank(),
                  plot.background = element_rect(fill='transparent', color = NA), panel.background = element_rect(fill='transparent', color = NA),
                  legend.background = element_rect(fill = 'transparent', color = NA))
        widg_m <- ggiraph(ggobj = p_m, bg='transparent')
        widg_m
    })
    
    output$plot_first <- renderGirafe({
        p_t<-hilo_comp %>% 
            ggplot()+
            geom_bar(aes(x = round_code, y = first_ten_mean, fill = type), position = 'dodge', stat = 'identity', alpha = 0.6) +
            scale_fill_viridis(discrete = TRUE, begin = .6, end = .2) +
            scale_y_continuous('Mean Clue Value', labels=scales::dollar_format())+
            scale_x_discrete(name = element_blank(),labels=c('Double Jeopardy!', 'Jeopardy!'))+
            theme(legend.position = 'bottom', plot.background = element_rect(fill='transparent', color = NA),
                  panel.background = element_rect(fill = 'transparent', color = NA), legend.title = element_blank())
        widg_t <- ggiraph(ggobj = p_t, bg='transparent')
        widg_t  
    })
    
    output$plot_dd <- renderGirafe({
        p_d <- hilo_comp %>% 
            ggplot()+
            geom_bar(aes(x = round_code, y = dd_mean, fill = type), position = 'dodge', stat = 'identity', alpha = 0.6) +
            scale_fill_viridis(discrete = TRUE, begin = .6, end = .2) +
            scale_y_continuous('Mean Wager', labels=scales::dollar_format())+
            scale_x_discrete(name = element_blank(),labels=c('Double Jeopardy!', 'Jeopardy!'))+
            theme(legend.position = 'bottom', plot.background = element_rect(fill='transparent', color = NA),
                  panel.background = element_rect(fill = 'transparent', color = NA), legend.title = element_blank())
        widg_d <- ggiraph(ggobj = p_d, bg='transparent')
        widg_d
    })
    
    output$placeholder_catexp <- renderText(
        'Category exploration goes here.'
    )#close placeholder_catexp
    
    output$plot_catexp <- renderGirafe({
        p <- ggplot()+
            geom_polygon_interactive(data = cat.gg, aes(x, y, group = id, fill = id, tooltip = cat_occurs_gt1$text[id], data_id = as.character(cat_occurs_gt1$category[id])),
                                     alpha = 0.6)+
            scale_fill_viridis() +
            geom_text(data = cat_occurs_gt1, aes(x, y, label = category), size=2.5, fontface = 'bold', color='black') + 
            theme_void()+
            theme(legend.position='none', plot.margin=unit(c(0,0,0,0),'cm'), panel.background = element_rect(fill = 'transparent', color = NA))+
            coord_equal()
        ggiraph(ggobj = p, bg = 'transparent')
    })#close plot_catexp
    
    output$dt_catexp <- DT::renderDT({
        if (!is.null(input$plot_catexp_selected))
            clues %>%
                filter(category == input$plot_catexp_selected) %>%
                select(round_code, clue_value, clue_text, corr_resp) %>% 
                rename('Round' = 'round_code', `Clue Value` = 'clue_value', `Clue Text` = 'clue_text', 'Answer' = 'corr_resp')
    })#close dt_rsexp
    
    output$plot_rspexp <- renderGirafe({
        
        p_r<- ggplot()+
            geom_polygon_interactive(data = resp.gg, aes(x, y, group = id, fill = id, tooltip = resp_occurs_gt1$text[id], data_id = as.character(resp_occurs_gt1$corr_resp[id])), 
                                     alpha = 0.6)+
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
        if (!is.null(input$plot_rspexp_selected))
            clues %>%
                filter(corr_resp == input$plot_rspexp_selected) %>%
                select(round_code, clue_value, category, clue_text) %>%
                rename('Round' = 'round_code', `Clue Value` = 'clue_value', 'Category' = 'category',`Clue Text` = 'clue_text' )
    })#close dt_rspexp

    output$index <- renderUI({
        selectInput('cat_index', 'Category index', choices = as.character(catyr_occurs[catyr_occurs$air_year == input$year, 'cat_index']))
    })#close index
    
    output$categories <- renderUI({
        selectInput('cat_list', 'Categories', choices = as.character(catyr_occurs[(catyr_occurs$air_year == input$year) & 
                                                                                      (catyr_occurs$cat_index == input$cat_index), 'category']))
    })#close categories
    
    output$dt_category <- DT::renderDT({
        if(!is.null(input$cat_list))
            show_nums <- catyr_occurs %>% 
                filter(air_year == input$year) %>% 
                filter(category == input$cat_list) %>% 
                select(category, show_num)
            show_nums <- show_nums %>% 
                inner_join(clues, by = c('category', 'show_num')) %>% 
                select(air_date, round_code, clue_value, clue_text, corr_resp) %>% 
                rename('Air Date' = 'air_date', 'Round' = 'round_code', 'Clue Value' = 'clue_value', 'Clue Text' = 'clue_text', 'Answer' = 'corr_resp')
            
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
