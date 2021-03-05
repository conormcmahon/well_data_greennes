This export file contains 3 files with a prefix corresponding to the following data type:
GWStation - station (well) header data
GWLevel - groundwater level data
GWPerforations - well perforation details 

The data files are in CSV-delimited format. Each file contains a header row 
describing the contents of the file.
The field descriptions for each file are given below.
*******************************************************************************
GWStation
        Field   Field Name              Data Type          Description
        =====   ===========             =========          ============================
          1     SITE_CODE               Char               Location-based 18 character alphanumeric code assigned to each well
          2     SWN                     Char               DWR State Well Number
          3     WELL_NAME               Char               Local well identification/local well name, number, or code
          4     LATITUDE                Number             Latitude (NAD83)
          5     LONGITUDE               Number             Longitude (NAD83)
          6     BASIN_CODE              Char               Basin or subbasin code the well is located within, as defined by DWR
          6     BASIN_NAME              Char               Basin or subbasin name the well is located within, as defined by DWR
          8     WELL_DEPTH              Number             The well's total casing depth or open borehole depth in feet below ground surface
          9     WELL_USE                Char               Description of well use (Domestic, Irrigation, Monitoring, etc.)

GWLevel
        Field   Field Name              Data Type          Description                             	 
        =====   ===========             =========          ============================            	 
          1     SITE_CODE               Char               Location-based 18 character alphanumeric code assigned to each well
          2     MSMT_DATE               Date               Date/Time (PST) the groundwater level measurement was collected
          3     RPE                     Number             Reference point elevation in feet (NAVD88)
          4     GSE                     Number             Ground surface elevation in feet (NAVD88)
          5     RDNG_WS                 Number             Reading on the measurement device at water surface
          6     RDNG_RP                 Number             Reading shown on the measurement device at reference point
          7     WLM_QA_DESC             Char               Quality assurance description for groundwater level measurement (questionable or no measurment)
          8     WLM_ORG_NAME            Number             Agency which collected the water level measurement
          9     MSMT_CMT                Char               Comments about a specific measurement

GWPerforation
        Field   Field Name              Data Type           Description                                   	 
        =====   ===========             =========           ============================                  	 
          1     SITE_CODE          	Char                Location-based 18 character alphanumeric code assigned to each well
          2     TOP_PERF_INT            Number              Depth to the top of the perforation/screen for this interval in feet 
          3     BOT_PERF_INT            Number              Depth to the bottom of the perforation/screen for this interval in feet

*******************************************************************************
The horizontal datum for all coordinates is NAD83.
The vertical datum for all elevations is NAVD88.
All depth measurements are in feet.
*******************************************************************************
If you encounter problems, find any errors, or have any suggestions,
please contact the WDL administrator at wdlweb@water.ca.gov
Last updated 10/12/2020
*******************************************************************************

