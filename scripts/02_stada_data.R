# 02_stada_data.R
# I det här scriptet städar jag datasetet och skapar några nya variabler.

# Laddar paket
library(tidyverse)

# Läser in originaldatasetet
orders <- read_csv("data/raw/ecommerce_orders.csv", show_col_types = FALSE)

# Kontrollerar saknade värden före städning
colSums(is.na(orders))

# Städar datasetet
orders_clean <- orders %>%
  mutate(
    # Städar textvariabler så att extra mellanslag och olika stora/små bokstäver blir mer enhetliga
    city = str_squish(city),
    city = str_to_title(city),
    
    payment_method = str_squish(payment_method),
    payment_method = str_to_lower(payment_method),
    payment_method = case_when(
      payment_method == "card" ~ "Card",
      payment_method == "paypal" ~ "PayPal",
      payment_method == "gift card" ~ "Gift Card",
      payment_method == "invoice" ~ "Invoice",
      payment_method == "swish" ~ "Swish",
      is.na(payment_method) ~ "Unknown",
      TRUE ~ payment_method
    ),
    
    campaign_source = str_squish(campaign_source),
    campaign_source = str_to_lower(campaign_source),
    campaign_source = case_when(
      campaign_source == "email" ~ "Email",
      campaign_source == "social" ~ "Social Media",
      campaign_source == "social media" ~ "Social Media",
      campaign_source == "paid search" ~ "Paid Search",
      campaign_source == "direct" ~ "Direct",
      campaign_source == "organic" ~ "Organic",
      campaign_source == "affiliate" ~ "Affiliate",
      is.na(campaign_source) ~ "Unknown",
      TRUE ~ campaign_source
    ),
    
    # Hanterar saknade värden
    city = if_else(is.na(city), "Unknown", city),
    discount_pct = if_else(is.na(discount_pct), 0, discount_pct),
    shipping_days = if_else(
      is.na(shipping_days),
      median(shipping_days, na.rm = TRUE),
      shipping_days
    ),
    
    # Skapar nya variabler för analys
    gross_order_value = quantity * unit_price,
    discount_amount = gross_order_value * discount_pct,
    order_value = gross_order_value - discount_amount,
    returned_binary = if_else(returned == "Yes", 1, 0),
    order_month = month(order_date, label = TRUE)
  )

# Kontrollerar saknade värden efter städning
colSums(is.na(orders_clean))

# Kontrollerar att städningen fungerade
unique(orders_clean$city)
unique(orders_clean$payment_method)
unique(orders_clean$campaign_source)

# Visar några av de nya variablerna
orders_clean %>%
  select(order_id, quantity, unit_price, discount_pct, gross_order_value, discount_amount, order_value) %>%
  head()

# Sparar den städade datan
write_csv(orders_clean, "data/processed/orders_clean.csv")