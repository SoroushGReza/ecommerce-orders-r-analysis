# 01_import_granska_data.R
# I det här scriptet importerar jag datasetet och gör en första granskning.

# Laddar paket
library(tidyverse)

# Läser in datasetet
orders <- read_csv("data/raw/ecommerce_orders.csv")

# Visar de första raderna
head(orders)

# Visar antal rader och kolumner
dim(orders)

# Visar kolumnnamn
names(orders)

# Visar struktur på datasetet
glimpse(orders)

# Visar en sammanfattning av variablerna
summary(orders)

# Kontrollerar saknade värden per kolumn
colSums(is.na(orders))

# Kontrollerar unika värden i några kategoriska variabler
unique(orders$customer_type)
unique(orders$region)
unique(orders$city)
unique(orders$product_category)
unique(orders$payment_method)
unique(orders$returned)