# 04_visualiseringar.R
# I det här scriptet skapar jag diagram med ggplot2.

# Laddar paket
library(tidyverse)

# Läser in den städade datan
orders_clean <- read_csv("data/processed/orders_clean.csv", show_col_types = FALSE)

# Skapar mapp för figurer om den inte redan finns
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)

# Diagram 1: Total försäljning per produktkategori
sales_by_category <- orders_clean %>%
  group_by(product_category) %>%
  summarise(
    total_forsaljning = sum(order_value),
    antal_ordrar = n()
  ) %>%
  arrange(desc(total_forsaljning))

plot_sales_category <- ggplot(sales_by_category,
                              aes(x = reorder(product_category, total_forsaljning),
                                  y = total_forsaljning)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Total försäljning per produktkategori",
    x = "Produktkategori",
    y = "Total försäljning"
  ) +
  theme_minimal()

plot_sales_category

ggsave(
  filename = "outputs/figures/total_forsaljning_per_kategori.png",
  plot = plot_sales_category,
  width = 8,
  height = 5
)

# Diagram 2: Ordervärde per kundtyp
plot_order_customer_type <- ggplot(orders_clean,
                                   aes(x = customer_type,
                                       y = order_value)) +
  geom_boxplot() +
  labs(
    title = "Ordervärde per kundtyp",
    x = "Kundtyp",
    y = "Ordervärde"
  ) +
  theme_minimal()

plot_order_customer_type

ggsave(
  filename = "outputs/figures/ordervarde_per_kundtyp.png",
  plot = plot_order_customer_type,
  width = 8,
  height = 5
)

# Diagram 3: Ordervärde för returnerade och ej returnerade ordrar
plot_order_returned <- ggplot(orders_clean,
                              aes(x = returned,
                                  y = order_value)) +
  geom_boxplot() +
  labs(
    title = "Ordervärde för returnerade och ej returnerade ordrar",
    x = "Returnerad order",
    y = "Ordervärde"
  ) +
  theme_minimal()

plot_order_returned

ggsave(
  filename = "outputs/figures/ordervarde_returnerad_order.png",
  plot = plot_order_returned,
  width = 8,
  height = 5
)

# Diagram 4: Försäljning per månad
sales_by_month <- orders_clean %>%
  mutate(order_month_date = floor_date(order_date, "month")) %>%
  group_by(order_month_date) %>%
  summarise(
    total_forsaljning = sum(order_value),
    antal_ordrar = n()
  )

plot_sales_month <- ggplot(sales_by_month,
                           aes(x = order_month_date,
                               y = total_forsaljning)) +
  geom_line() +
  geom_point() +
  labs(
    title = "Total försäljning per månad",
    x = "Månad",
    y = "Total försäljning"
  ) +
  theme_minimal()

plot_sales_month

ggsave(
  filename = "outputs/figures/total_forsaljning_per_manad.png",
  plot = plot_sales_month,
  width = 8,
  height = 5
)

# Diagram 5: Rabatt och ordervärde
plot_discount_order_value <- ggplot(orders_clean,
                                    aes(x = discount_pct,
                                        y = order_value)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Samband mellan rabatt och ordervärde",
    x = "Rabatt",
    y = "Ordervärde"
  ) +
  theme_minimal()

plot_discount_order_value

ggsave(
  filename = "outputs/figures/rabatt_och_ordervarde.png",
  plot = plot_discount_order_value,
  width = 8,
  height = 5
)

# Diagram 6: Returandel per produktkategori
return_rate_category <- orders_clean %>%
  group_by(product_category) %>%
  summarise(
    returandel = mean(returned_binary),
    antal_ordrar = n()
  ) %>%
  arrange(desc(returandel))

plot_return_category <- ggplot(return_rate_category,
                               aes(x = reorder(product_category, returandel),
                                   y = returandel)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Returandel per produktkategori",
    x = "Produktkategori",
    y = "Returandel"
  ) +
  theme_minimal()

plot_return_category

ggsave(
  filename = "outputs/figures/returandel_per_kategori.png",
  plot = plot_return_category,
  width = 8,
  height = 5
)