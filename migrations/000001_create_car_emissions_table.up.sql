/* create key tables */ 
CREATE TABLE IF NOT EXISTS EXAMPLE.CAR_EMISSIONS
(
        GUID SERIAL PRIMARY KEY, 
        MAKE VARCHAR(50) NOT NULL,
        MODEL VARCHAR(100) NOT NULL,
        FUEL_TYPE VARCHAR(100) NOT NULL,
        CO2_EMISSIONS_G_PER_KM NUMERIC NOT NULL,
        THC_EMISSIONS_MG_PER_KM NUMERIC,--not in all data
        CO_EMISSIONS_MG_PER_KM NUMERIC,--not in all data
        NO_PARTICULATES_EMISSIONS_MG_PER_KM NUMERIC, --not in all data
        NOX_EMISSIONS_MG_PER_KM NUMERIC,--not in all data
        NEDC_CO2_G_PER_KM NUMERIC, --not in all data
        WLTP_CO2_G_PER_KM NUMERIC --not in all data
)
TABLESPACE EXAMPLE_DATA;
