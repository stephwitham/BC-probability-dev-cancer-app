#
## R Shiny Dashboard
## Lifetime Probability of Developing Cancer - BC Cancer

library(shiny)
library(rsconnect)
library(shiny)
library(shinydashboard)
library(bs4Dash)
library(tidyverse)
library(magrittr)
library(readr)
library(DT)
library(readr)
library(shinythemes)
library(waffle)
library(fontawesome)
library(extrafont)
library(emojifont)
library(fresh)
library(shinyWidgets)


#Import data
devcan_master <- read_csv("DevCan_Master_Final.csv")

site_list <- devcan_master %$% unique(Site) 
sex_list <- devcan_master %$% unique(Sex)

#mytheme
mytheme <-
  create_theme(
    bs4dash_vars(
      navbar_light_color = "#bec5cb",
      navbar_light_active_color = "#FFF",
      navbar_light_hover_color = "#FFF"),
    
    bs4dash_yiq( # used to choose text color written in bs4ValueBox with background defined by a status
      contrasted_threshold = 10,
      text_dark = "#FFF", #text when theme is dark
      text_light = "#272c30"), #text colour when theme is light
    
    bs4dash_layout(
      main_bg = "#6f7982", #main background colour
      sidebar_width = "250px"),
    
    bs4dash_sidebar_light(
      bg = "#dde6eb", #navbar background colour
      color = "#272c30", #text colour
      hover_color = "#6f7982",
      submenu_bg = "c", 
      submenu_color = "#6f7982", 
      submenu_hover_color = "#FFF"),
    
    bs4dash_status(
      primary = "#5E81AC", danger = "#BF616A", light = "#272c30"),
    
    bs4dash_color(
      gray_900 = "#343a40")
  )



# Define UI for application
ui <- bs4DashPage(
  title = "Lifetime Probability",
  dark = FALSE,
  freshTheme = mytheme,
  skin = "light",
  
  bs4DashNavbar(
    skin = "light",
    #use_theme(mytheme),
    title = HTML("<font size=4 color=\"#021324\"><b> Lifetime Probability<br/>of Developing Cancer in BC </b></font>"
    )),
  
  
  bs4DashSidebar(
    skin = "light",
    sidebarMenu(
      id = "sidebarMenu",
      menuItem(
        "Lifetime Probability",
        tabName = "menu_1",
        icon = icon("chart-bar")
      ),
      menuItem(
        "Datatable",
        tabName = "menu_2",
        icon = icon("table")
      ),
      menuItem(
        "Info",
        tabName = "menu_3",
        icon = icon("info")
      )
    ),
    br(),
    h6(HTML("<font size=4 color=\"#021324\"><b> Data Filters </b></font>")),
    setSliderColor("#7a8791", c(1)),
    sliderInput("num2", 
                label = div(HTML("<font size=4 color=\"#021324\"><b> Select Year </b></font>")),
                value = 2017, min = 1991, max = 2017, ticks = TRUE, sep = "", step = 1),
    pickerInput("sex2", 
                label = div(HTML("<font size=3 color=\"#021324\"><b> Select Sex </b></font>")),
                choices =  sex_list, 
                selected = sex_list[1], 
                multiple = TRUE),
    pickerInput("site2", 
                label = div(HTML("<font size=3 color=\"#021324\"><b> Select Cancer Site </b></font>")),
                choices = site_list, 
                selected = site_list[7],
                multiple = TRUE)
  ),
  
  bs4DashBody(
    #  use_theme(mytheme),
    bs4TabItems(
      bs4TabItem(
        tabName = "menu_1",
        
        #   fluidRow(
        #column(4,
        
        bs4Card(
          title = "Results",
          width = 12,
          overflow = TRUE,
          htmlOutput("text1", height = 100)),  
        #       ),
        
        #  column(8,
        
        bs4Card(
          title = "Wafflechart",
          HTML("This waffle chart visually represents the lifetime probability estimate of the cancer, sex, and year that is selected from the dropdown menu. Each square represents 1%
<br/>
<br/>"),
          width = 12,
          plotOutput("waffle1"))
        #           )
        #  )
      ),
      
      
      bs4TabItem(
        tabName = "menu_2",
        fluidRow(
          bs4Card(
            dataTableOutput("table1"),
            title = "Datatable",
            width = 12
          )
        )
      ),
      
      bs4TabItem(
        tabName = "menu_3",
        fluidRow(
          bs4Card(
            title = "Using the App",
            HTML("Use the side navigation bar to select year, sex, and cancer type to display the probability of developing cancer in the 'Lifetime Probability' tab. You can compare your selections in the 'Datatable' tab.
<br>
Note that the Wafflechart is best used for single selections only (i.e.: female, breast, 2017). If there are multiple selections it will display a cumulative probability of all selections which is not statistically validated in this app."),
            width = 12
          ),
          
          bs4Card(
            title = "About the Project",
            HTML("Together, the Population Oncology unit at BC Cancer, and Cancer Control Research unit at the BC Cancer Research Center, a branch institute of the BC Cancer Agency, work together on population oncology research to help inform, survey, and monitor the cancer burden at the population level in British Columbia (BC)[1]. The BC Cancer Registry is a comprehensive database with personal, tumour, and mortality information on all cancer cases of BC residents since 1969. The registry is linked to multiple data sources across the province (e.g. pathology laboratories, hospital admissions, vital statistics), enabling population-based capture of cases and surveillance through cancer statistics that portray the impact and trends of cancer in BC.
<br/>
<br/>
  By using data from BC Cancer Registry, this project analyzed the estimate of the probability of developing cancer by sex and cancer type in BC, using DevCan statistical software created by the National Cancer Institute [2]. To date, there isn’t much known about the stability of this estimate, even though it is a key measure of the cancer burden reported in the Canadian Cancer Statistics annual publications, among other reports. The aim was to take a closer look at this estimate by analyzing its stability over time by sex, cancer type, and geography, to better understand whether it is a reliable measure to describe the cancer burden. Considering its common use in risk communication, without much known on the stability, this project can help inform the use of this estimate for population oncology research and surveillance and risk communication strategies. Additionally, trends that are found in the probability of developing cancer can be compared to incidence rate trends. This estimate is one way in which we can understand and examine the cancer burden and give insights to the broader oncological community.
<br/>
<br/>
References: 
<br/>
1. BC Cancer Research Center. BC Cancer Research Strategic Plan 2019. [Internet]. Provincial Health Services Authority; 2019. Available from https://www.bccrc.ca/sites/bccrc.ca/files/BC%20Cancer%20Research%20SP%202019%20lowres.pdf
<br/>
2.	National Cancer Institute: Division of Cancer Control & Population Sciences [Internet]. DevCan – Probability of Developing or Dying of Cancer; 2020 Jan 02 [cited March 24]. Available from https://surveillance.cancer.gov/devcan/ 
                "),
            width = 12
          ),
          
          bs4Card(
            title = "Methods",
            HTML("DevCan Software (v6.7.8) was used to calculate the lifetime probability of developing cancer using a life-table method and competing risks framework to statistically estimate the lifetime risk of developing cancer with 95% confidence intervals [1]. DevCan takes cross-sectional data and creates a hypothetical cohort of 10,000,000 with age-conditional probabilities of developing cancer for each 19 five-year age intervals (0-90+) by incorporating the competing risk of all-cause mortality counts [1]. The output includes a life-table, age-conditional table, raw input table, intermediate results, and a cohort summary which shows the total cumulative lifetime risk over the cohort with an open-ended age interval (0-90+). As stated by the Canadian Cancer Statistics report [2], these values should be taken as approximations only and considered on a population-level not an individual level. 
 <br/>
All-cause mortality counts from in British Columbia were only available from 1991 from Statistics Canada, so trends in lifetime probability estimates started from this year. To observe trends over time, the calculated probability was taken for each calender year. 
<br/>
<br/>
References: 
<br/> 
1.National Cancer Institute. Probability of Developing or Dying of Cancer [Internet]. 2020. Available from: https://surveillance.cancer.gov/devcan/
<br/>
2. Canadian Cancer Statistics Advisory Committee. Canadian Cancer Statistics 2019 [Internet]. Toronto, ON: Canadian Cancer Society; 2019 pp. 1–94. Available from: cancer.ca/Canadian-Cancer-Statistics-2019-EN
                "),
            width = 12
          )
        )
      )
    )
  )
)



server <- function(input, output) {
  
  output$text1 <- renderUI({ 
    x <- devcan_master %>% 
      filter(Year == input$num2, 
             Sex %in% input$sex2,
             Site %in% input$site2) %$% Estimate
    
    y <- devcan_master %>% 
      filter(Year == input$num2, 
             Sex %in% input$sex2,
             Site %in% input$site2) %$% `Estimate '1 in'`
    HTML(paste0("<font size=3>In </font>", 
                "<font size=4 color=\"#6391A3\"><b>",input$num2, "</b></font>,", 
                "<font size=3> the lifetime probability of developing </font>", 
                "<font size=4 color=\"#6391A3\"><b>", input$site2, "</b></font>", 
                "<font size=3> cancer among </font>", 
                "<font size=4 color=\"#6391A3\"><b>", input$sex2,"</b></font>", 
                "<font size=3> was </font>", 
                "<font size=4 color=\"#6391A3\"><b>", paste0(x,". "),"</b></font>",
                "<font size=3>In other words, </font>",
                "<font size=4 color=\"#6391A3\"><b>", paste0("1 in ", y," "), "</b></font>",
                "<font size=4 color=\"#6391A3\"><b>", input$sex2, "</b></font>",
                "<font size=3> are expected to develop </b></font>",
                "<font size=4 color=\"#6391A3\"><b>", input$site2, "</b></font>",
                "<font size=3> cancer in their lifetime. </font>", 
                br()))
  })
  
  output$waffle1 <- renderPlot({
    x <- devcan_master %>% 
      filter(Year == input$num2, 
             Sex %in% input$sex2,
             Site %in% input$site2) %>%
      mutate(Estimate = as.numeric(gsub("%", "", Estimate))) %$% sum(Estimate)
    
    basedata <- c('Cancer'= round(x, 0), 'Cancer Free'=  100-round(x, 0))
    
    # Waffle chart
    waffle(
      basedata,
      rows = 10,
      #      use_glyph = "child",
      colors =  c("#6391A3", "#dde6eb"),
      size = 1,
      xlab = "Each square represents 1%",
      title = "Lifetime Probablity of Developing Cancer",
      flip = TRUE
    ) +
      theme(
        plot.title = element_text(hjust = 0.5, size = 27, face = "bold"),
        legend.text = element_text(size = 15),
        legend.position = "bottom"
      )
    
  })
  
  output$table1 <- renderDataTable(
    devcan_master %>% 
      filter(Year == input$num2, 
             Sex %in% c(input$sex2),
             Site %in% c(input$site2)) %>% 
      datatable(., rownames = F))
  
}


# Run the application 
shinyApp(ui = ui, server = server)
