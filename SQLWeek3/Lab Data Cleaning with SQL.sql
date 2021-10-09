use marketing_customer_analysis;

-- 1) REAMING TABLE

-- 
ALTER TABLE `marketing_customer_analysis`.`data_marketing_customer_analysis_round2` 
RENAME TO  `marketing_customer_analysis`.`customer_data` ; 
--

-- check how the table looks like
select * from customer_data;


-- 2) STANDARDIZING COLUMN NAMES:

-- Change the column names to lower size and replace space with low connector

-- Again DONE IT VIA rightklick on the table (in the Schemas section) and "use alter table"

-- 
ALTER TABLE `marketing_customer_analysis`.`customer_data` 
CHANGE COLUMN `MyUnknownColumn` `myunknowncolumn` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Customer` `customer` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `State` `state` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Customer Lifetime Value` `customer_lifetime_value` DOUBLE NULL DEFAULT NULL ,
CHANGE COLUMN `Response` `response` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Coverage` `coverage` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Education` `education` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Effective To Date` `effective_to_date` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `EmploymentStatus` `employmentstatus` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Gender` `gender` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Income` `income` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Location Code` `location_code` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Marital Status` `marital_status` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Monthly Premium Auto` `monthly_premium_auto` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Months Since Last Claim` `months_since_last_claim` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Months Since Policy Inception` `months_since_policy_inception` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Number of Open Complaints` `number_of_open_complaints` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Number of Policies` `number_of_policies` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Policy Type` `policy_type` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Policy` `policy` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Renew Offer Type` `renew_offer_type` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Sales Channel` `sales_channel` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Total Claim Amount` `total_claim_amount` DOUBLE NULL DEFAULT NULL ,
CHANGE COLUMN `Vehicle Class` `vehicle_class` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Vehicle Size` `vehicle_size` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Vehicle Type` `vehicle_type` TEXT NULL DEFAULT NULL ;
--


-- 3) DROPPING myunknowncolumn (maybe later customer) COLUMNS

Alter table customer_data
Drop myunknowncolumn;


-- 4) DROP DUPLICATES (and reset index)

-- isolate the duplicates the proposal from Bita -> could be done as well, EASIER OPTION actualy, you dont need to type every column name manually
WITH abc AS (
SELECT *, COUNT(*) AS count
FROM customer_data
GROUP BY customer,state,customer_lifetime_value, response, coverage,education, effective_to_date, employmentstatus, gender,income,location_code,marital_status, monthly_premium_auto, number_of_policies,policy_type, policy, renew_offer_type,sales_channel,vehicle_class, vehicle_size, vehicle_type
HAVING COUNT(*) > 1)
 SELECT customer from abc
        where count > 1;

-- also did I delete these records but only after deleting the duplicates via the real solution below
delete from customer_data
where customer in (WITH abc AS (
SELECT *, COUNT(*) AS count
FROM customer_data
GROUP BY customer,state,customer_lifetime_value, response, coverage,education, effective_to_date, employmentstatus, gender,income,location_code,marital_status, monthly_premium_auto, number_of_policies,policy_type, policy, renew_offer_type,sales_channel,vehicle_class, vehicle_size, vehicle_type
HAVING COUNT(*) > 1)
 SELECT customer from abc
        where count > 1);

-- REAL SOLUTION (proposed by Darinka): only isolate the customer (id)

WITH cte AS (
SELECT customer,
ROW_NUMBER() OVER (
PARTITION BY state, customer_lifetime_value,
response,
coverage,
gender,
effective_to_date,
employmentstatus,
location_code,
marital_status,
monthly_premium_auto,
months_since_last_claim,
months_since_policy_inception, 
number_of_open_complaints,
number_of_policies,
policy_type,
policy,
renew_offer_type,
sales_channel,
total_claim_amount,
vehicle_class,
vehicle_size,
income
			
            ORDER BY
            state, customer_lifetime_value,
response,
coverage,
gender,
effective_to_date,
employmentstatus,
location_code,
marital_status,
monthly_premium_auto,
months_since_last_claim,
months_since_policy_inception, 
number_of_open_complaints,
number_of_policies,
policy_type,
policy,
renew_offer_type,
sales_channel,
total_claim_amount,
vehicle_class,
vehicle_size,
income
            ) row_num
		FROM customer_data
        ) 
        SELECT customer from cte
        where row_num > 1;


-- do the deleting of the isolated duplicated customer(IDs) with a subquery from above

SET SQL_SAFE_UPDATES = 0;


delete from customer_data
where customer in (WITH cte AS (
SELECT customer,
ROW_NUMBER() OVER (
PARTITION BY state, customer_lifetime_value,
response,
coverage,
gender,
effective_to_date,
employmentstatus,
location_code,
marital_status,
monthly_premium_auto,
months_since_last_claim,
months_since_policy_inception, 
number_of_open_complaints,
number_of_policies,
policy_type,
policy,
renew_offer_type,
sales_channel,
total_claim_amount,
vehicle_class,
vehicle_size,
income
			
            ORDER BY
            state, customer_lifetime_value,
response,
coverage,
gender,
effective_to_date,
employmentstatus,
location_code,
marital_status,
monthly_premium_auto,
months_since_last_claim,
months_since_policy_inception, 
number_of_open_complaints,
number_of_policies,
policy_type,
policy,
renew_offer_type,
sales_channel,
total_claim_amount,
vehicle_class,
vehicle_size,
income
            ) row_num
		FROM customer_data
        ) 
        SELECT customer from cte
        where row_num > 1);


-- how many records are in the overall table customer_data? we have 372 records less!
SELECT COUNT(*) from customer_data;


-- ARCHIVE -> DELETE FULL VERSION of DARINKA (not tested)
Deleting 

WITH cte AS (
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY 
state,
customer_lifetime_value,
response,
coverage,
education,
effective_to_date,
gender,
income,
location_code,
marital_status,
monthly_premium_auto,
months_since_last_claim,
months_since_policy_inception, 
number_of_open_complaints,
number_of_policies,
policy_type,
policy,
renew_offer_type,
sales_channel,
total_claim_amount,
vehicle_class,
vehicle_size,
vehicle_type

			
            ORDER BY
           state,
customer_lifetime_value,
response,
coverage,
education,
effective_to_date,
gender,
income,
location_code,
marital_status,
monthly_premium_auto,
months_since_last_claim,
months_since_policy_inception, 
number_of_open_complaints,
number_of_policies,
policy_type,
policy,
renew_offer_type,
sales_channel,
total_claim_amount,
vehicle_class,
vehicle_size,
vehicle_type
            ) row_num
		FROM customer_analysis
        ) 
        DELETE from cte
        where row_num > 1;



-- 5) REPLACING NULL VALUES

-- FOR "number_of_open_complaints" fill nan values with zero

SELECT number_of_open_complaints FROM customer_data
WHERE number_of_open_complaints NOT IN (1,2,3,4,5);

SET SQL_SAFE_UPDATES = 0;


UPDATE customer_data
SET number_of_open_complaints = 0
WHERE number_of_open_complaints NOT IN (1,2,3,4,5);


SET SQL_SAFE_UPDATES = 1;

-- FOR "months_since_last_claim", use the mean "value"

-- isolate the empty values first
SELECT months_since_last_claim from customer_data 
where months_since_last_claim= "";

-- isolate the average number for months_since_last_claim
Select Round(AVG(months_since_last_claim)) From customer_data;


-- override the empty value with the above result being 14

SET SQL_SAFE_UPDATES = 0;

UPDATE customer_data
SET months_since_last_claim = 14
WHERE months_since_last_claim="";

SET SQL_SAFE_UPDATES = 1;

SELECT months_since_last_claim, customer from customer_data
Group by customer
order by months_since_last_claim
desc;

-- FOR "income", use the mean "value"

-- isolate the empty values first
SELECT income, count(customer) from customer_data 
where income= "";

-- isolate the average income of the data set
Select Round(AVG(income)) From customer_data;


-- override the empty value with the above result being 37552

SET SQL_SAFE_UPDATES = 0;

UPDATE customer_data
SET income = 37552
WHERE income="";

SET SQL_SAFE_UPDATES = 1;


