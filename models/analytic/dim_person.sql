WITH dim_person__source AS (
SELECT *
FROM `vit-lam-data.wide_world_importers.application__people`
)
, dim_person__rename AS (
SELECT 
  person_id
  , full_name
  , is_employee
  , is_salesperson AS is_sales_person
  , preferred_name
FROM dim_person__source
)

, dim_person__cast_data AS (
SELECT
  CAST (person_id AS integer) AS person_id
  , CAST(full_name AS string) AS full_name
  , CAST(is_employee AS boolean) AS is_employee_boolean
  , CAST(is_sales_person AS boolean) AS is_sales_person_boolean
  , CAST (preferred_name AS string) AS preferred_name
FROM dim_person__rename
)

,dim_person__change_boolean AS (
SELECT
*
  , CASE
      WHEN is_employee_boolean IS TRUE THEN 'Employee'
      WHEN is_employee_boolean IS FALSE THEN 'Not Employee'
      ELSE 'Invalid'
    END AS is_employee
  
  ,  CASE
      WHEN is_sales_person_boolean IS TRUE THEN 'Sales Person'
      WHEN is_sales_person_boolean IS FALSE THEN 'Not Sales Person'
      ELSE 'Invalid'
    END AS is_sales_person
FROM dim_person__cast_data
)


SELECT
COALESCE(person_id , 0) AS person_id
, COALESCE ( full_name , 'Invalid') AS full_name
, COALESCE ( is_employee , 'Invalid') AS is_employee
, COALESCE ( is_sales_person , 'Invalid') AS is_sales_person
FROM dim_person__change_boolean
