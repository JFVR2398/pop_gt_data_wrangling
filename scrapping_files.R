library(rvest)
library(tidyverse)
library(readxl)
library(chromote)

b <-  ChromoteSession$new()

# Scrapping -----
# We will be scrapping directly from INE's web the .xlsx files
# Vamos a descargar directamente de la página del INE los archivos .xlsx

# Read the web page
#Leer la página web

ine_web <- read_html_live('https://www.ine.gob.gt/proyecciones/')
str(ine_web)

# Extract the elements with links from the web
# Extraer los elementos con links de la página

links <- ine_web |> html_elements('a') |> html_attr('href')

# Select only the links that are directed to an xlsx file
# Seleccionar solamente los links directos a los xlsx files

excel_links <- links[grepl("\\.xlsx?$", links, ignore.case = TRUE)]

# In the web there are a total of 47 xlsx related links
# The first link contains only the total population projections for the whole country
# From the 2nd to the 25th element are projections at the ADMIN01 level
# The 24th and 25th elements are ADMIN02 projections only by municipality and sex
# From the 26th to the 47th elements are projection data by municipality, sex, and age group

# En la web hay un total de 47 enlaces relacionados con xlsx
# El primer enlace contiene solo las proyecciones de población total para todo el país
# Del 2do al 25to elemento son proyecciones a nivel ADMIN01
# El 24to y 25to elementos son proyecciones ADMIN02 solo por municipio y sexo
# Del 26to al 47mo elemento son datos de proyecciones por municipio, sexo y grupo etario

# We select only the elements related to municipality, sex, and age.
# Solamente seleccionamos los elementos relacionados a municipalidad, sexo y grupo etario

excel_mun <- excel_links[26:47]

# Download the xlsx files
# Descargar los archivos xlsx

b$Browser$setDownloadBehavior(
  behavior = "allow",
  downloadPath = normalizePath("ine_files", mustWork = TRUE)
)

# Download each file
for (link in excel_mun) {
  b$Page$navigate(link)
  Sys.sleep(3)
}

read_xlsx("ine_files/01-Guatemala.xlsx")
