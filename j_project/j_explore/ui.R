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
    title = 'Winning Strategies for Jeopardy!', 
    titleWidth =  350
)#close dashboardHeader
#header <- dashboardHeader(title = h4(HTML("This title<br/>is just way too long")))


sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Jeopardy! Winning Scores", tabName = 'winners', icon = NULL),
        menuItem('Board Strategy', tabName = 'board', icon = NULL),
        menuItem('Category Explorer', tabName = 'cat_exp', icon = NULL),
        menuItem('Response Explorer', tabName = 'rsp_exp', icon = NULL),
        menuItem('Test Your Knowledge', tabName = 'test', icon = NULL),
        menuItem('Other Strategies', tabName = 'other', icon = NULL)
        
    )#close sidebarMenu
)#close dashboardSidebar

body <- dashboardBody(
    tabItems(
        tabItem(
            tabName = 'winners',
            #fluidRow(
                #div(style = "height:800px"),
                column(
                    width = 6,
                    align = 'center',
                    h2('Jeopardy! Game Scores 2001 - 2021'),
                    h2(''),
                    girafeOutput('plot_scores', width = '100%')
                ),
                column(
                    width = 6,
                    align = 'center',
                    h2('Jeopardy! Median and High Scores 2001 - 2021'),
                    h2(''),
                    girafeOutput('plot_median', width = '100%')
                )
            #)
        ),

                tabItem(
            tabName = 'board',
            #fluidRow(
                column(
                    width = 6,
                    align = 'center',
                    h2('First Ten Clues Chosen'),
                    h2(''),
                    girafeOutput('plot_first')
                ),
                column(
                    width = 6,
                    align = 'center',
                    h2('Daily Double Wagers'),
                    h2(''),
                    girafeOutput('plot_dd')
                )
            #)
        ),
        
        
        tabItem(
            tabName = 'cat_exp',
            
            fluidRow(
                column(
                    width = 6,
                    align = 'center',
                    h2('35 Most Frequent Jeopardy! Categories'),
                    h2(''),
                    girafeOutput('plot_catexp', width = '100%')
                ),
            #),
            #fluidRow(
                column(
                    width = 6,
                    DT::DTOutput('dt_catexp')
                )
            )
        ),
        
        tabItem(
            tabName = 'rsp_exp',

            fluidRow(
                column(
                    align = 'center',
                    h2('35 Most Frequent Jeopardy! Answers'),
                    h2(''),
                    width = 6,
                    girafeOutput('plot_rspexp', width = '100%')
                 ),
            #),
            #fluidRow(
                column(
                    width = 6,
                    DT::DTOutput('dt_rspexp')
                )
            )
        ),
        
        tabItem(
            tabName = 'test',
            align = 'left',
            h2('Browse All Categories and Clues'),
            h2(''),
            
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
            tabName = 'other',
            fluidRow(
                column(
                    align = 'left',
                    width = 12,
                    h2('Other Winning Strategies')#,
                    #h2(HTML('<br/>'))
                )
            ),
            fluidRow(
                column(
                    width = 1
                ),
                column(
                    width = 11,
                    h3('Buzzer Practice'),
                    
                    h3('Math Practice - Final Jeopardy Betting'),
                    
                    h3('Take the Jeopardy! Test at jeopardy.com'),
                    h3(HTML('<br/>')),
                    h3(HTML('<br/>')),
                    h3(HTML('<br/>')),
                    h3(HTML('<br/>')),
                    h3(HTML('<br/>')),
                    h4('Sources: All Jeopardy! game data retrieved from the J! Archive, a fan-created site, at j-archive.com.'),
                    h4('The Jeopardy! game show and all elements thereof are property of Jeopardy Productions, Inc.')
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