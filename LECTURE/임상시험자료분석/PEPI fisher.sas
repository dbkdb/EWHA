
DATA PEPI;
    INFILE 'D:\대학원\2024-2\임상시험자료분석\PROJECT\DATA\유방암/PEPI_data.csv' 
           DELIMITER = ',' FIRSTOBS = 2;
    INPUT treatment $ RESP  count;
RUN;

PROC FREQ DATA = PEPI;
    TABLES treatment * RESP / CHISQ CMH TREND EXPECTED NOPERCENT NOCOL; 
    WEIGHT count;
RUN;
