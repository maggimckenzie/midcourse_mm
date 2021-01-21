#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
header <- dashboardHeader(
    title = 'Jeopardy Strategies'
)#close dashboardHeader

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem('Welcome!', tabName = 'welcome', icon = NULL),
        menuItem("What's the Take?", tabName = 'winners', icon = NULL),
        menuItem('Category Explorer', tabName = 'cat_exp', icon = NULL),
        menuItem('Response Explorer', tabName = 'rsp_exp', icon = NULL),
        menuItem('Test Your Knowledge', tabName = 'test', icon = NULL),
        menuItem('Buzzer Challenge', tabName = 'buzzer', icon = NULL)
        
    )#close sidebarMenu
)#close dashboardSidebar

body <- dashboardBody(
    tabItems(
        tabItem(
            tabName = 'welcome',
            fluidRow(
                column(
                    width = 12,
                    textOutput('placeholder_welcome')
                )
            )
        ),
        
        tabItem(
            tabName = 'winners',
            fluidRow(
                #div(style = "height:800px"),
                column(
                    width = 12,
                    textOutput('placeholder_winners')
                )
            ),
            fluidRow(
                column(
                    width = 12,
                    
                    plotlyOutput('plot_scores')
                )
            )
        ),
        
        tabItem(
            tabName = 'cat_exp',
            fluidRow(
                column(
                    width = 12,
                    textOutput('placeholder_catexp')
                )
            ),
            fluidRow(
                column(
                    width = 12,
                    girafeOutput('plot_catexp')
                )
            ),
            fluidRow(
                column(
                    width = 12,
                    DT::DTOutput('dt_catexp')
                )
            )
        ),
        
        tabItem(
            tabName = 'rsp_exp',
            fluidRow(
                column(
                    #style='height:10vh',
                    width = 12,
                    textOutput('placeholder_rspexp')
                )
            ),
            fluidRow(
                column(
                    #style='height:90vh',
                    width = 12,
                    girafeOutput('plot_rspexp')
                 )
            ),
            fluidRow(
                column(
                    width = 12,
                    DT::DTOutput('dt_rspexp')
                )
            )
        ),
        
        tabItem(
            tabName = 'test',
            
            selectInput('year',
                        'Choose a year',
                        multiple = FALSE,
                        selected = sort(unique(catyr_occurs$air_year))[1],
                        choices = sort(unique(catyr_occurs$air_year))
            ),
            
            uiOutput('index'),
            
            uiOutput('categories'),
            
            fluidRow(
                column(
                    width = 12,
                    DT::DTOutput('dt_category')
                )
            )
        ),
        
        tabItem(
            tabName = 'buzzer',
            fluidRow(
                column(
                    width = 12,
                    textOutput('placeholder_buzzer')
                )
            )
        )#close last tabItem
        
    )#close tabItems
    
)#close dashboardBody


# # Define UI for application that draws a histogram
# shinyUI(fluidPage(
# 
#     # Application title
#     titlePanel("Old Faithful Geyser Data"),
# 
#     # Sidebar with a slider input for number of bins
#     sidebarLayout(
#         sidebarPanel(
#             sliderInput("bins",
#                         "Number of bins:",
#                         min = 1,
#                         max = 50,
#                         value = 30)
#         ),
# 
#         # Show a plot of the generated distribution
#         mainPanel(
#             plotOutput("distPlot")
#         )
#     )
# ))

shinyUI(
    dashboardPage(people3_customTheme,
                  header=header,
                  sidebar = sidebar,
                  body=body
    )
)