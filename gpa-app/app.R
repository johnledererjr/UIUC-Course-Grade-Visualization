library(shiny)
library(tidyverse)
library(bslib)

gpa = read_csv("data/uiuc-gpa-dataset.csv")

gpa = gpa %>%
    mutate("Proportion of A's" = (gpa$`A+` + gpa$A + gpa$`A-`) / 
               (gpa$`A+` + gpa$A + gpa$`A-` + gpa$`B+` + gpa$B + gpa$`B-` +
                    gpa$`C+` + gpa$C + gpa$`C-` + gpa$`D+` + gpa$D + gpa$`D-` +
                    gpa$F)) %>%
    mutate(
        "Average GPA" = (
            gpa$`A+` * 4 + gpa$A * 4 + gpa$`A-` * 3.67 + gpa$`B+` * 3.33 +
                gpa$B * 3 + gpa$`B-` * 2.67 + gpa$`C+` * 2.33 + gpa$C * 2 +
                gpa$`C-` * 1.67 + gpa$`D+` * 1.33 + gpa$D + gpa$`D-` *
                .67
        )
        / (
            gpa$`A+` + gpa$A + gpa$`A-` + gpa$`B+` + gpa$B + gpa$`B-` +
                gpa$`C+` + gpa$C + gpa$`C-` + gpa$`D+` + gpa$D + gpa$`D-` +
                gpa$F
        ))

ui = navbarPage(
    theme = bs_theme(bootswatch = "united"),
    title = "UIUC  Average Course Grades",
    tabPanel(
        title = "App",
        titlePanel("UIUC Course Grade Data"),
        sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "subject", label = "Subject", choices = unique(gpa$Subject)),
            selectInput(inputId = "number", label = "Level", choices = unique(gpa$Number)),
            selectInput(inputId = "instructor", label = "Professor", choices = unique(gpa$`Primary Instructor`)),
            checkboxInput(inputId = "aspercent", label = "Percent?")
        ),
        mainPanel(plotOutput("plot")))
    ),
    tabPanel(title = "Table", dataTableOutput("table")),
    tabPanel(title = "About", includeMarkdown("about.Rmd"))
)

server = function(input, output) {
    
    gpa_subject = reactive({
        gpa %>%
            filter(Subject == input$subject)
    })
    
    observeEvent(
        eventExpr = input$subject,
        handlerExpr = {
            updateSelectInput(inputId = "number", choices = unique(gpa_subject()$Number))
        })
    
    gpa_subject_number = reactive({
        gpa_subject() %>%
            filter(Number == input$number)
    })
    
    observeEvent(
        eventExpr = input$number,
        handlerExpr = {
            updateSelectInput(inputId = "instructor", choices = unique(gpa_subject_number()$`Primary Instructor`))
        })
    
    gpa_subject_number_professor = reactive({
        gpa_subject_number_professor = gpa_subject_number() %>%
            filter(`Primary Instructor` == input$instructor)
        
        if(input$aspercent) {
            gpa_subject_number_professor = gpa_subject_number_professor %>%
                mutate(across(`Proportion of A's`, percent))
        }
        gpa_subject_number_professor    
    })
    
    output$table = renderDataTable(gpa_subject_number_professor())
    output$plot = renderPlot({
        ggplot(data = gpa_subject_number_professor(), aes(x = `Proportion of A's`, y = `Average GPA`)) +
            geom_point() + 
            theme_bw()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
