# 03_explorativ_analys.R
# I det här scriptet gör jag en explorativ analys av den städade datan.

# Laddar paket
library(tidyverse)

# Läser in den städade datan
orders_clean <- read_csv("data/processed/orders_clean.csv", show_col_types = FALSE)

# Grundläggande översikt
glimpse(orders_clean)

# Sammanfattning av numeriska variabler
summary(orders_clean)

# Total försäljning och antal ordrar
total_summary <- orders_clean %>%
  summarise(
    antal_ordrar = n(),
    total_forsaljning = sum(order_value),
    genomsnittligt_ordervarde = mean(order_value),
    median_ordervarde = median(order_value),
    total_antal_produkter = sum(quantity),
    returandel = mean(returned_binary)
  )

total_summary

# Försäljning per produktkategori
sales_by_category <- orders_clean %>%
  group_by(product_category) %>%
  summarise(
    antal_ordrar = n(),
    total_forsaljning = sum(order_value),
    genomsnittligt_ordervarde = mean(order_value),
    returandel = mean(returned_binary)
  ) %>%
  arrange(desc(total_forsaljning))

sales_by_category

# Försäljning per kundtyp
sales_by_customer_type <- orders_clean %>%
  group_by(customer_type) %>%
  summarise(
    antal_ordrar = n(),
    total_forsaljning = sum(order_value),
    genomsnittligt_ordervarde = mean(order_value),
    returandel = mean(returned_binary)
  ) %>%
  arrange(desc(genomsnittligt_ordervarde))

sales_by_customer_type

# Försäljning per region
sales_by_region <- orders_clean %>%
  group_by(region) %>%
  summarise(
    antal_ordrar = n(),
    total_forsaljning = sum(order_value),
    genomsnittligt_ordervarde = mean(order_value),
    returandel = mean(returned_binary)
  ) %>%
  arrange(desc(total_forsaljning))

sales_by_region

# Försäljning per månad
sales_by_month <- orders_clean %>%
  group_by(order_month) %>%
  summarise(
    antal_ordrar = n(),
    total_forsaljning = sum(order_value),
    genomsnittligt_ordervarde = mean(order_value)
  )

sales_by_month

# Jämförelse mellan returnerade och ej returnerade ordrar
sales_by_return_status <- orders_clean %>%
  group_by(returned) %>%
  summarise(
    antal_ordrar = n(),
    genomsnittligt_ordervarde = mean(order_value),
    median_ordervarde = median(order_value),
    genomsnittlig_rabatt = mean(discount_pct),
    genomsnittlig_leveranstid = mean(shipping_days)
  )

sales_by_return_status

# De 10 största ordrarna
top_orders <- orders_clean %>%
  select(order_id, customer_type, product_category, quantity, unit_price, discount_pct, order_value, returned) %>%
  arrange(desc(order_value)) %>%
  head(10)

top_orders

# Sparar några sammanfattande tabeller
write_csv(total_summary, "outputs/tables/total_summary.csv")
write_csv(sales_by_category, "outputs/tables/sales_by_category.csv")
write_csv(sales_by_customer_type, "outputs/tables/sales_by_customer_type.csv")
write_csv(sales_by_region, "outputs/tables/sales_by_region.csv")
write_csv(sales_by_month, "outputs/tables/sales_by_month.csv")
write_csv(sales_by_return_status, "outputs/tables/sales_by_return_status.csv")
write_csv(top_orders, "outputs/tables/top_orders.csv")