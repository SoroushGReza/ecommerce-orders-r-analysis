# 05_ttest_konfidensintervall.R

# I det här scriptet jämför jag grupper med t-test och konfidensintervall.

# Laddar paket

library(tidyverse)

# Läser in den städade datan

orders_clean <- read_csv("data/processed/orders_clean.csv", show_col_types = FALSE)

# Skapar mappp för tabeller om den inte redan finns

dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

# ------------------------------------------------------------

# 1. Jämförelse: ordervärde för returnerade och ej returnerade ordrar

# ------------------------------------------------------------

summary_returned <- orders_clean %>%
  group_by(returned) %>%
  summarise(
    antal_ordrar = n(),
    medel_ordervarde = mean(order_value),
    standardavvikelse = sd(order_value),
    standardfel = standardavvikelse / sqrt(antal_ordrar),
    ci_lower = medel_ordervarde - qt(0.975, df = antal_ordrar - 1) * standardfel,
    ci_upper = medel_ordervarde + qt(0.975, df = antal_ordrar - 1) * standardfel
  )

print(summary_returned)

ttest_returned <- t.test(order_value ~ returned, data = orders_clean)

print(ttest_returned)

# ------------------------------------------------------------

# 2. Jämförelse: ordervärde för nya och återkåmmande kunder

# ------------------------------------------------------------

new_returning_customers <- orders_clean %>%
  filter(customer_type %in% c("New", "Returning"))

summary_customer_type <- new_returning_customers %>%
  group_by(customer_type) %>%
  summarise(
    antal_ordrar = n(),
    medel_ordervarde = mean(order_value),
    standardavvikelse = sd(order_value),
    standardfel = standardavvikelse / sqrt(antal_ordrar),
    ci_lower = medel_ordervarde - qt(0.975, df = antal_ordrar - 1) * standardfel,
    ci_upper = medel_ordervarde + qt(0.975, df = antal_ordrar - 1) * standardfel
  )

print(summary_customer_type)

ttest_customer_type <- t.test(order_value ~ customer_type, data = new_returning_customers)

print(ttest_customer_type)

# ------------------------------------------------------------

# 3. Jämförelse: rabatt för returerade och ej returnerade ordrar

# ------------------------------------------------------------

summary_discount_returned <- orders_clean %>%
  group_by(returned) %>%
  summarise(
    antal_ordrar = n(),
    medel_rabatt = mean(discount_pct),
    standardavvikelse = sd(discount_pct),
    standardfel = standardavvikelse / sqrt(antal_ordrar),
    ci_lower = medel_rabatt - qt(0.975, df = antal_ordrar - 1) * standardfel,
    ci_upper = medel_rabatt + qt(0.975, df = antal_ordrar - 1) * standardfel
  )

print(summary_discount_returned)

ttest_discount_returned <- t.test(discount_pct ~ returned, data = orders_clean)

print(ttest_discount_returned)

# ------------------------------------------------------------

# Sparar resultaten

# ------------------------------------------------------------

write_csv(summary_returned, "outputs/tables/summary_returned.csv")
write_csv(summary_customer_type, "outputs/tables/summary_customer_type.csv")
write_csv(summary_discount_returned, "outputs/tables/summary_discount_returned.csv")

capture.output(
  ttest_returned,
  file = "outputs/tables/ttest_returned.txt"
)

capture.output(
  ttest_customer_type,
  file = "outputs/tables/ttest_customer_type.txt"
)

capture.output(
  ttest_discount_returned,
  file = "outputs/tables/ttest_discount_returned.txt"
)
