## Create empty parameter functions for body and sidebar of main app
sampleBody <- function() {
  dashboardBody(
    tabItems(
      # tab item for home tab
      tabItem(tabName = "home"),
      # tab item for graphs tab
      tabItem(tabName = "graphs", graph_UI("sampleGraph")),
      # tab item for models tab
      tabItem(tabName = "models", model_UI("sampleModel")),
      # tab item for data tab
      tabItem(tabName = "data", data_UI("sampleData"))
    )
  )
}

sampleSidebar <- function() {
  dashboardSidebar(
    sidebarMenu(
      # create menu item for home page
      menuItem("Home", tabName = "home", icon = icon("home")),
      # create menu item for graphs
      menuItem("Graphs", tabName = "graphs", icon = icon("chart-line")), 
      # create menu item for modeling
      menuItem("Models", tabName = "models", icon = icon("assistive-listening-systems")),
      # create menu item for data
      menuItem("Data", tabName = "data", icon = icon("users"))
    )
  )
}