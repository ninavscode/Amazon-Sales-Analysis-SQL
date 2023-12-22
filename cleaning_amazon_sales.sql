WITH 
	nonsym -- transforming columns to ideal form for analysis and preparing for data type conversion
	AS
		(SELECT 
		 	product_id,
		 	product_name,
			SUBSTRING(category FROM 0 FOR POSITION('|' in category)) AS category,
			REPLACE(SUBSTRING(discounted_price, 2, LENGTH(discounted_price)),',','') AS discount_price, 
			REPLACE(SUBSTRING(actual_price, 2, LENGTH(actual_price)),',','') AS actual_price,
			SUBSTRING(discount_percentage FROM 0 FOR POSITION('%' in discount_percentage)) AS discount_perc,
			REPLACE(rating,'|','0') AS rating,
			REPLACE(rating_count,',','') AS rating_count,
			review_title
		FROM public.amazon_sales2),
	dataconv
	AS
		(SELECT
		 	product_id,
		 	product_name,
		 	category,
			CAST(discount_price AS numeric),
		 	CAST(actual_price AS numeric),
		 	CAST(discount_perc AS numeric),
		 	CAST(rating AS numeric),
		 	CAST(rating_count AS numeric),
		 	review_title
		FROM nonsym)
SELECT 
	product_id,
	product_name,
	category,
	ROUND((discount_price * 0.0120),2) AS discount_price_USD, -- currency conversion from INR to USD
	ROUND((actual_price * 0.0120),2) AS actual_price_USD, -- currency conversion from INR to USD
	discount_perc,
	rating,
	COALESCE(rating_count,0) AS rating_count, -- remove null value that came as result of data type conversion
	review_title
FROM dataconv;