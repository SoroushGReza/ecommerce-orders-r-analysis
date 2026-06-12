# 06_regression.R
# I det här scriptet gör jag enkel och multipel linjär regression.

# Laddar paket
library(tidyverse)

# Läser in den städade datan
orders_clean <- read_csv("data/processed/orders_clean.csv", show_col_types = FALSE)

# Skapar mappar för resultat om de inte redan finns
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)

# ------------------------------------------------------------
# Förbereder data för regression
# ------------------------------------------------------------

orders_model <- orders_clean %>%
  mutate(
    customer_type = as.factor(customer_type),
    product_category = as.factor(product_category),
    returned = as.factor(returned)
  )

# ------------------------------------------------------------
# 1. Enkel linjär regression
# ------------------------------------------------------------
# Här undersöker jag om rabatt kan förklara ordervärde.

model_simple <- lm(order_value ~ discount_pct, data = orders_model)

print(summary(model_simple))

# ------------------------------------------------------------
# 2. Multipel linjär regression
# ------------------------------------------------------------
# Här undersöker jag om flera variabler tillsammans kan förklara ordervärde.
# Jag använder quantity, unit_price, discount_pct, shipping_days och customer_type.

model_multiple <- lm(
  order_value ~ quantity + unit_price + discount_pct + shipping_days + customer_type,
  data = orders_model
)

print(summary(model_multiple))

# ------------------------------------------------------------
# 3. Jämförelse av modeller
# ------------------------------------------------------------

model_comparison <- tibble(
  model = c("Enkel regression", "Multipel regression"),
  r_squared = c(
    summary(model_simple)$r.squared,
    summary(model_multiple)$r.squared
  ),
  adjusted_r_squared = c(
    summary(model_simple)$adj.r.squared,
    summary(model_multiple)$adj.r.squared
  )
)

print(model_comparison)

# ------------------------------------------------------------
# 4. Prediktioner från den multipla modellen
# ------------------------------------------------------------

orders_predictions <- orders_model %>%
  mutate(
    predicted_order_value = predict(model_multiple),
    residuals = residuals(model_multiple)
  )

head(
  orders_predictions %>%
    select(order_id, order_value, predicted_order_value, residuals)
)

# ------------------------------------------------------------
# 5. Enkel modellkontroll
# ------------------------------------------------------------
# Residualer används för att kontrollera hur väl modellen passar datan.

plot_residuals <- ggplot(orders_predictions,
                         aes(x = predicted_order_value,
                             y = residuals)) +
  geom_point(alpha = 0.5) +
  geom_hline(yintercept = 0) +
  labs(
    title = "Residualer mot predikterat ordervärde",
    x = "Predikterat ordervärde",
    y = "Residualer"
  ) +
  theme_minimal()

plot_residuals

ggsave(
  filename = "outputs/figures/residualer_regression.png",
  plot = plot_residuals,
  width = 8,
  height = 5
)

# QQ-plot för residualer
png("outputs/figures/qqplot_residualer.png", width = 800, height = 500)
qqnorm(residuals(model_multiple))
qqline(residuals(model_multiple))
dev.off()

# ------------------------------------------------------------
# 6. Sparar resultat
# ------------------------------------------------------------

write_csv(model_comparison, "outputs/tables/model_comparison.csv")

capture.output(
  summary(model_simple),
  file = "outputs/tables/model_simple_summary.txt"
)

capture.output(
  summary(model_multiple),
  file = "outputs/tables/model_multiple_summary.txt"
)

write_csv(
  orders_predictions %>%
    select(order_id, order_value, predicted_order_value, residuals),
  "outputs/tables/regression_predictions.csv"
)