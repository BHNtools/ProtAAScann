#!/usr/local/bin/R
#//////////////////////////////////////////////////////////
#__author__ = "BEN HASSINE Najla(bhndevtools@gmail.com)"#/
#__version__ = "Protaascan - v1.0.0"				            #/
#__copyright__ = "Copyright(c) 2017 BHNtools"           #/
#__license__ = "BHNtools"			                          #/
#////////////////////////////////////////////////////////


#_______________________________________________________________
#R version 3.4.2 (2017-09-28) -- "Short Summer"
#Copyright (C) 2017 The R Foundation for Statistical Computing
#Platform: x86_64-pc-linux-gnu (64-bit)
#"Debian GNU/Linux 9 (stretch)

#PROGRAMME: BHNtools::ShinyApp
#Web API GUI :: Generate Interactive App with Shiny package.

#MODULE: Sever part
#_______________________________________________________________



########################
#SOURCING SCRIPTS
########################
#Scripts dealing with sequence input
source("src/processcripts/proces_InputSeq.R")

#Scripts dealing with plots
source("src/processcripts/proces_plots.R")

#Scripts dealing with tabs
source("src/processcripts/proces_tabs.R")

########################
#Launching server
########################
server <- function(input, output) {
  #Initialization
  #_____ LOGIN PART ________#
  #$$ to define !! if not public app
  USER <<- reactiveValues(Logged = TRUE)
  
  #_____ REACTIVE VALUES PART ______#
  sliderValues <- reactive({
    #USER INPUT SEQ
    seq_input <- input$textareaID
  })
  
  

  #_____ RENDERING VALUES ______#
  #Rendering  tables
  #__ TAB 1 :: Protein infos __
  output$proteinfovalues <- renderTable({
    seq_input <- input$textareaID
    data.frame(
      proteinfo_tab <- proteinfo_tab_fn(seq_input),
      stringsAsFactors = FALSE)
  })
  
  #__ TAB 2 :: AA CLasses __ 
  output$aaclassvalues <- renderTable({
    seq_input <- input$textareaID

    data.frame(
      Name = rownames(aacomp_seq_fn(seq_input)) ,
      Value =aacomp_seq_fn(seq_input) ,
      stringsAsFactors = FALSE)
  })
  
  #__ TAB 3 :: AA Counts and Perc. __ 
  output$aacountingvalues <- renderTable({
    seq_input <- input$textareaID
    data.frame(
      aminoc_acid_perc <- percent_aa_seq_fn(seq_input),
      stringsAsFactors = FALSE)
  })
  
  
  #__ TAB 4 :: SPECIFIC AA amino acid count __ 
  output$specificaavalues <- renderTable({
    seq_input <- input$textareaID
    data.frame(
      aminoc_acid_spec <- specific_aa_seq_fn(seq_input),
      stringsAsFactors = FALSE)
  })
  
  
  #__ TAB 5 :: AA MemBrane Position Prediction __ 
  output$predictiontable= DT::renderDataTable({
    seq_input <- toupper(input$textareaID)
    predposition_mb_seq_fn(seq_input)
  })
  
  
  #Rendering  plots
  #__ PLOT 1 :: AA Counts __ 
  output$plot1aacount<-renderPlot({
    seq_input <- input$textareaID
    ploting_seq_fn(seq_input)
  })
  #__ PLOT 2 :: AA CLasses __
  output$plot2aaclass<-renderPlot({
    seq_input <- toupper(input$textareaID)
    ploting_aa_class_fn(seq_input)
  })
  #__ PLOT 3 :: AA MemBrane Position Prediction __ 
  output$plot3predmb<-renderPlot({
    seq_input <- toupper(input$textareaID)
    ploting_aa_mbpsopred_fn(seq_input)
  })
  
  #_____ UI BODY PART ________#
  #Body 
  output$body <- renderUI({
    if (USER$Logged == TRUE) {
      div(
        dashboardBody(
          width = "95%",
          hight = "95%",
          mainpage)
      )
    }
    else {
      dashboardBody(
        width = "90%",
        hight = "90%"
      )
    }
  })
  #Buttons
  #__ BOUTTON 1 :: SHOW NOTIFICATION __ BEGIN
  # A queue of notification IDs
  ids <- character(0)
  # A counter
  n <- 0
  observeEvent(input$show, {
    a <- tryCatch(warning(Sys.time()), warning=function(w) { w })
    mess <- a$message
    showNotification(mess)
    id <- showNotification(paste("Message", n), duration = NULL)
    ids <<- c(ids, id)
    n <<- n + 1
    #Notif
    seq_input <- str_trim(input$textareaID)
    a <- tryCatch(warning(aacomp_seq_fn(seq_input)), warning=function(w) { w })
    messg <- a$message
    showNotification(messg)
    
  })
  #__ BOUTTON 1 :: SHOW NOTIFICATION __ END
}