drop table if exist;
  create table supply_chain
  (
Product_type varchar(30),
SKU varchar(50),
Price float,
Availability int,
Number_of_products_sold int,
Revenue_generated float,
Customer_demographics varchar(50),
Stock_levels int,
Lead_times int,
Order_quantities int,
Shipping_times int,
Shipping_carriers varchar(50),
Shipping_costs float,
Supplier_name varchar(100),
Location varchar(50),
Lead_time int,
Production_volumes int,
Manufacturing_lead_time int,
Manufacturing_costs float,
Inspection_results varchar(100),
Defect_rates float,
Transportation_modes varchar(100),
Routes varchar(100),
Costs float

  );


 
 select*from supply_chain;
 --sku profitablity ranking
SELECT 
    sku,
    SUM(revenue_generated) AS total_revenue,
    SUM(costs + manufacturing_costs + shipping_costs) AS total_cost,
    SUM(revenue_generated) - SUM(costs + manufacturing_costs + shipping_costs) AS profit,
    ROUND(
        (
            (SUM(revenue_generated) - SUM(costs + manufacturing_costs + shipping_costs)) 
            / NULLIF(SUM(revenue_generated),0) * 100
        )::numeric,
        2
    ) AS profit_margin_pct
FROM supply_chain
GROUP BY sku
ORDER BY profit DESC;
--Loss-Making Products (Critical Risk)
SELECT 
    sku,
    SUM(revenue_generated) AS revenue,
    SUM(costs + manufacturing_costs + shipping_costs) AS total_cost,
    SUM(revenue_generated) - SUM(costs + manufacturing_costs + shipping_costs) AS profit
FROM supply_chain
GROUP BY sku
HAVING SUM(revenue_generated) - SUM(costs + manufacturing_costs + shipping_costs) < 0;

--Supplier Performance Scorecard
SELECT 
    supplier_name,
    AVG(defect_rates) AS avg_defect_rate,
    AVG(manufacturing_lead_time) AS avg_mfg_lead_time,
    AVG(manufacturing_costs) AS avg_mfg_cost,
    COUNT(DISTINCT sku) AS sku_count
FROM supply_chain
GROUP BY supplier_name
ORDER BY avg_defect_rate ASC, avg_mfg_cost ASC;

--Logistics Efficiency (Cost vs Speed)
SELECT 
    shipping_carriers,
    AVG(shipping_times) AS avg_shipping_time,
    AVG(shipping_costs) AS avg_shipping_cost
FROM supply_chain
GROUP BY shipping_carriers
ORDER BY avg_shipping_cost;

--Inventory Risk Detection
SELECT 
    sku,
    stock_levels,
    SUM(number_of_products_sold) AS total_sold,
    AVG(lead_times) AS avg_lead_time
FROM supply_chain
GROUP BY sku, stock_levels
HAVING stock_levels < 20 AND AVG(lead_times) > 10;

--High Defect Cost Impact
SELECT 
    sku,
    SUM(revenue_generated) AS revenue,
    AVG(defect_rates) AS avg_defect_rate,
    SUM(revenue_generated) * AVG(defect_rates)/100 AS estimated_defect_loss
FROM supply_chain
GROUP BY sku
ORDER BY estimated_defect_loss DESC;

--Transportation Mode Cost Comparison
SELECT 
    transportation_modes,
    AVG(costs) AS avg_transport_cost,
    AVG(shipping_times) AS avg_delivery_time
FROM supply_chain
GROUP BY transportation_modes
ORDER BY avg_transport_cost;

--Revenue by Demographics & Product Type
SELECT 
    customer_demographics,
    product_type,
    SUM(revenue_generated) AS total_revenue
FROM supply_chain
GROUP BY customer_demographics, product_type
ORDER BY total_revenue DESC;

--Route Cost Optimization
SELECT 
    routes,
    AVG(costs + shipping_costs) AS avg_total_logistics_cost,
    AVG(shipping_times) AS avg_time
FROM supply_chain
GROUP BY routes
ORDER BY avg_total_logistics_cost DESC;




--Route Cost Optimization


SELECT 
    sku,
    AVG(production_volumes) AS avg_production,
    AVG(manufacturing_costs) AS avg_mfg_cost,
    ROUND(
        (AVG(manufacturing_costs) 
        / NULLIF(AVG(production_volumes),0))::numeric,
        2
    ) AS cost_per_unit
FROM supply_chain
GROUP BY sku
ORDER BY cost_per_unit DESC;







 