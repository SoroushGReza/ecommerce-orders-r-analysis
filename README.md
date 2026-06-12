# E-commerce Orders R Analysis

Det här projektet är en individuell skoluppgift i R. Uppgiften var egentligen tänkt som en gruppuppgift, men jag genomför den individuellt.

I projektet analyserar jag ett dataset med e-handelsordrar. Målet är att träna på att importera data, städa data, göra explorativ analys, skapa visualiseringar med ggplot2 och genomföra enklare statistiska analyser.

## Syfte

Syftet med projektet är att undersöka försäljning och kundbeteende i ett e-commerce dataset.

Jag vill bland annat undersöka:

- vilka produktkategorier som har högst försäljning
- om ordervärde skiljer sig mellan olika kundtyper
- om rabatter verkar påverka ordervärde
- om det finns skillnader mellan returnerade och icke-returnerade ordrar
- om ordervärde kan förklaras med hjälp av variabler som antal produkter, pris, rabatt och kundtyp

## Dataset

Datasetet ligger i:

`data/raw/ecommerce_orders.csv`

Datasetet innehåller 1000 rader och 16 kolumner. Varje rad motsvarar en order.

Exempel på variabler i datasetet:

- order_id
- order_date
- customer_id
- customer_segment
- customer_type
- region
- city
- product_category
- product_subcategory
- payment_method
- campaign_source
- quantity
- unit_price
- discount_pct
- shipping_days
- returned

## Projektstruktur

Projektet är uppdelat i följande mappar:

- `data/raw/` innehåller originaldatasetet
- `data/processed/` används för städad data
- `R/` används för egna R-funktioner
- `scripts/` innehåller R-script för analysen
- `outputs/figures/` används för diagram
- `outputs/tables/` används för tabeller
- `report/` innehåller rapporten

## Plan för analysen

Projektet kommer att göras i flera steg:

1. Importera och granska datasetet
2. Städa data och hantera saknade värden
3. Skapa nya variabler, till exempel ordervärde
4. Göra explorativ analys med dplyr
5. Skapa diagram med ggplot2
6. Jämföra grupper med t-test och konfidensintervall
7. Göra enkel och multipel regression
8. Kontrollera modellen och tolka resultatet
9. Skriva en kort rapport med resultat och reflektion

## Verktyg

Jag använder:

- R
- RStudio
- tidyverse
- ggplot2
- dplyr
- Git och GitHub

## Kommentar

Eftersom jag gör uppgiften individuellt försöker jag hålla projektet tydligt och lagom avancerat. Fokus ligger på att visa att jag kan använda de metoder vi har gått igenom i kursen.

