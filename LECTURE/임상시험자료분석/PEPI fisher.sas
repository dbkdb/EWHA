
DATA PEPI;
    INFILE 'D:\���п�\2024-2\�ӻ�����ڷ�м�\PROJECT\DATA\�����/PEPI_data.csv' 
           DELIMITER = ',' FIRSTOBS = 2;
    INPUT treatment $ RESP  count;
RUN;

PROC FREQ DATA = PEPI;
    TABLES treatment * RESP / CHISQ CMH TREND EXPECTED NOPERCENT NOCOL; 
    WEIGHT count;
RUN;
