library(shiny)
library(shinydashboard)
library(tidyverse)
library(plotly)
library(ggplot2)
library(stringr)
library(dashboardthemes)
library(packcircles)
library(viridis)
library(ggiraph)
library(DT)

fj_win_scores <- read.csv('fj_win_scores.csv')
cat_occurs <- read.csv('cat_occurs.csv')
resp_occurs <- read.csv('resp_occurs.csv')
clues <- read.csv('j_clues.csv')
catyr_occurs <- read.csv('catyr_occurs.csv')
hilo_comp <- read.csv('hilo_comp.csv')

#prepare data for cat_exp plot
cat_occurs_gt1 <- cat_occurs %>% 
  #filter(occurs >= 100) %>% 
  head(35) %>% 
  mutate(occurs_wt = occurs ** 3) %>% 
  arrange(category)
cat_occurs_gt1$text <- paste('Category: ',cat_occurs_gt1$category, '\n', 'Games Appearing: ',cat_occurs_gt1$occurs, '\n', 'Pct of Games: ', cat_occurs_gt1$pct_of_games)
packing <- circleProgressiveLayout(cat_occurs_gt1$occurs_wt, sizetype = 'area')
packing$radius <- 0.95 * packing$radius
cat_occurs_gt1 <- cbind(cat_occurs_gt1, packing)
cat.gg <- circleLayoutVertices(packing, npoints=50)

#prepare data for resp_exp plot
resp_occurs_gt1 <- resp_occurs %>% 
  #filter(occurs >= 100) %>% 
  head(35) %>% 
  mutate(occurs_wt = occurs ** 3) %>% 
  arrange(corr_resp)
resp_occurs_gt1$text <- paste('Answer: ',resp_occurs_gt1$corr_resp, '\n', 'Games Appearing: ',resp_occurs_gt1$occurs, '\n', 'Pct of Games: ', resp_occurs_gt1$pct_of_games)
packing_r <- circleProgressiveLayout(resp_occurs_gt1$occurs_wt, sizetype = 'area')
packing_r$radius <- 0.95 * packing_r$radius
resp_occurs_gt1 <- cbind(resp_occurs_gt1, packing_r)
resp.gg <- circleLayoutVertices(packing_r, npoints=50)

#prepare data for scores plot
fj_scores <- fj_win_scores %>% 
  mutate(text1 = paste('Player: ', contestant, '\n', 'Score: $', formatC(score, big.mark=','))) %>% 
  filter(season >=18) %>% 
  select(show_num, season, air_year, contestant, bucket_name, score, text1)

#prepare data for high scores plot
fj_median <- fj_win_scores %>% 
  select(season, air_year, score) %>%
  filter(air_year >=2001 & season >= 18) %>% 
  group_by(air_year) %>% 
  summarize(median_score = median(score), mean_score = mean(score), 
            high_score = max(score))
p_m_names <- fj_win_scores %>% 
  group_by(air_year) %>% 
  filter(score == max(score)) %>% 
  select(air_year, contestant, score)
fj_median <- fj_median %>% 
  left_join(p_m_names, by = c('air_year', 'high_score' = 'score'))
fj_median <-fj_median %>% rename('high_scorer' = 'contestant')


custom_colors<-c("#e4941b",
                 "#a8948a",
                 "#333333",
                 "#a48b32",
                 "#103447",
                 "#705b0f",
                 "#320b22",
                 "#545249"
)

#CUSTOM DASHBOARD THEME

people3_customTheme <- shinyDashboardThemeDIY(
  ### general
  appFontFamily = "Arial" # Abel, Fjalla One
  ,appFontColor = "#3C3C3C"
  ,primaryFontColor = "#3C3C3C"
  ,infoFontColor = "#2D2D2D"
  ,successFontColor = "#2D2D2D"
  ,warningFontColor = "#2D2D2D"
  ,dangerFontColor = "#2D2D2D"
  ,bodyBackColor = "#E6E6E6"
  ### header
  ,logoBackColor = "#3C3C3C"
  ,headerButtonBackColor = "#3C3C3C"
  ,headerButtonIconColor = "#DCDCDC"
  ,headerButtonBackColorHover = "#646464"
  ,headerButtonIconColorHover = "#787878"
  ,headerBackColor = "#3C3C3C"
  ,headerBoxShadowColor = ""
  ,headerBoxShadowSize = "0px 0px 0px"
  ### sidebar
  ,sidebarBackColor = "#E6E6E6"
  ,sidebarPadding = "0"
  ,sidebarMenuBackColor = "transparent"
  ,sidebarMenuPadding = "0"
  ,sidebarMenuBorderRadius = 0
  ,sidebarShadowRadius = ""
  ,sidebarShadowColor = "0px 0px 0px"
  ,sidebarUserTextColor = "#737373"
  ,sidebarSearchBackColor = "#F0F0F0"
  ,sidebarSearchIconColor = "#646464"
  ,sidebarSearchBorderColor = "#DCDCDC"
  ,sidebarTabTextColor = "#646464"
  ,sidebarTabTextSize = "14"
  ,sidebarTabBorderStyle = "none"
  ,sidebarTabBorderColor = "none"
  ,sidebarTabBorderWidth = "0"
  ,sidebarTabBackColorSelected = "#E6E6E6"
  ,sidebarTabTextColorSelected = "#000000"
  ,sidebarTabRadiusSelected = "0px"
  ,sidebarTabBackColorHover = "#F5F5F5"
  ,sidebarTabTextColorHover = "#000000"
  ,sidebarTabBorderStyleHover = "none solid none none"
  ,sidebarTabBorderColorHover = "#C8C8C8"
  ,sidebarTabBorderWidthHover = "4"
  ,sidebarTabRadiusHover = "0px"
  ### boxes
  ,boxBackColor = "#FFFFFF"
  ,boxBorderRadius = "5"
  ,boxShadowSize = "none"
  ,boxShadowColor = ""
  ,boxTitleSize = "18"
  ,boxDefaultColor = "#E1E1E1"
  ,boxPrimaryColor = "#5F9BD5"
  ,boxInfoColor = "#B4B4B4"
  ,boxSuccessColor = "#70AD47"
  ,boxWarningColor = "#ED7D31"
  ,boxDangerColor = "#E84C22"
  ,tabBoxTabColor = "#F8F8F8"
  ,tabBoxTabTextSize = "14"
  ,tabBoxTabTextColor = "#646464"
  ,tabBoxTabTextColorSelected = "#2D2D2D"
  ,tabBoxBackColor = "#F8F8F8"
  ,tabBoxHighlightColor = "#C8C8C8"
  ,tabBoxBorderRadius = "5"
  ### inputs
  ,buttonBackColor = "#E59824"
  ,buttonTextColor = "#2D2D2D"
  ,buttonBorderColor = "#969696"
  ,buttonBorderRadius = "5"
  ,buttonBackColorHover = "#E59824"
  ,buttonTextColorHover = "#2D2D2D"
  ,buttonBorderColorHover = "#969696"
  ,textboxBackColor = "#FFFFFF"
  ,textboxBorderColor = "#767676"
  ,textboxBorderRadius = "5"
  ,textboxBackColorSelect = "#F5F5F5"
  ,textboxBorderColorSelect = "#6C6C6C"
  ### tables
  ,tableBackColor = "#F8F8F8"
  ,tableBorderColor = "#EEEEEE"
  ,tableBorderTopSize = "1"
  ,tableBorderRowSize = "1"
)
