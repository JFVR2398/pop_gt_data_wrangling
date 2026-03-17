library(tidyverse)
library(readxl)
library(janitor)

# This script is for cleaning the Excel's files with the data
# Este script es para limpiar los datos de los archivos Excel

# Prototype 1 -----

data <- read_xlsx("ine_files/01-Guatemala.xlsx")

# Remove the first 5 rows because there is nothing interesting there
# Remover las primeras cinco filas porque no hay nada interesante ahí

data_cl <- data[-c(1:5, 268), ]

# Extracting the name of the department and municipality so it is in the rows
# Extraer el nombre del departamento y la municipalidad para que estén en las columnas

name_admin <- colnames(data_cl[ , 1])

admin01_name <- str_extract(name_admin,
                            pattern = '^.*?(?=,)')

admin02_name <- str_extract(name_admin,
                            pattern = '(?<=municipio[:space:]).*')

# Make the row values to name of columns because we care about the year value
# Hacer los valores de la primera fila los nombres de las columnas, pues nos interesa el año

data_cl <- row_to_names(data_cl,
                        row_number = 1)

colnames(data_cl)[1] <- 'whatever'


# One more row to delete
# Una fila más para borrar

data_cl <- data_cl[-1, ]

# Filter out the rows that have an age range insted of a single age
# Borrar las filas que tienen un rango etario en vez de un único valor

data_cl <- data_cl |> 
  filter(!grepl(' a ', whatever))

# First, create a new column only with the values 'Hombre', 'Mujer' and 'Total'
# Primero, crear una nueva columna solamente con los valores de 'Hombre', 'Mujer' y 'Total'

data_cl <- data_cl |> 
  mutate(gender = whatever) |> 
  mutate(match_text = case_when(
           gender == 'Total' ~ TRUE,
           gender == 'Hombres' ~ TRUE,
           gender == 'Mujeres' ~ TRUE,
           TRUE ~ FALSE
         ))

for(i in 1:nrow(data_cl)){
  
  if(data_cl[i, ncol(data_cl)] != 'TRUE'){
    
    data_cl[i, ncol(data_cl) - 1] <- NA
    
  }
  
}








