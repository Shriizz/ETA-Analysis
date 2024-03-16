CREATE DATABASE PROJECT_HEALTHCARE;
use PROJECT_HEALTHCARE;
-- DROP TABLE census;
CREATE TABLE census (
State_UT VARCHAR(100),
District VARCHAR(100) PRIMARY KEY,
Population INT NOT NULL,
Male INT,
Female INT,
Literate INT,
Literate_Male INT NOT NULL,
Literate_Female INT NOT NULL, 
Households_Rural INT,
Households_Urban INT,
Households INT,
Young_and_Adult INT,
Middle_Aged INT,
Senior_Citizen INT NOT NULL,
Age_Not_Stated INT
);
-- DROP TABLE housing;
CREATE TABLE housing (
District VARCHAR(100) PRIMARY KEY,
Households_rural INT,
Households_Rural_Livable INT,
Households_Rural_Dilapidated INT,
Households_Rural_Toilet_premise INT,
Households_Urban INT,
Households_Urban_Livable INT,
Households_Urban_Dilapidated INT,
Households_Urban_Toilet_premise INT,
FOREIGN KEY (District) REFERENCES census(District)
);

CREATE TABLE all_hospitals (
State_UT VARCHAR(100) PRIMARY KEY,
Primary_Health_Centers INT,
Community_Health_Centers INT,
Sub_District_Hospitals INT,
District_Hospitals INT,
Total_Hospitals INT,
Total_Hospital_Beds INT
);

CREATE TABLE government_hospital (
State_UT VARCHAR(100) PRIMARY KEY,
Rural_Government_Hospitals INT,
Rural_Government_Beds INT,
Urban_Government_Hospitals INT,
Urban_Government_Beds INT,
Last_Updated DATE,
FOREIGN KEY (State_UT) REFERENCES all_hospitals(State_UT)
);
-- select * from all_hospitals;
SELECT c.District, c.State_UT, 
    (h.Households_Rural + h.Households_Urban - h.Households_Rural_Toilet_Premise - h.Households_Urban_Toilet_Premise) AS Households_Without_Toilet
FROM census c
JOIN housing h ON c.District = h.District
JOIN all_hospitals ah ON c.State_UT = ah.State_UT
JOIN government_hospital gh ON c.State_UT = gh.State_UT
WHERE ah.Total_Hospital_Beds / c.Population = (
    SELECT MIN(ah.Total_Hospital_Beds / c.Population)
    FROM census c
    JOIN all_hospitals ah ON c.State_UT = ah.State_UT
)
ORDER BY Households_Without_Toilet DESC;


