
PROC IMPORT DATAFILE="D:\대학원\2024-2\임상시험자료분석\PROJECT\DATA\유방암\data_new.csv"
    OUT=data
    DBMS=CSV 
    REPLACE;
    GETNAMES=YES;
RUN;


DATA data;
    SET data;
    IF NOT MISSING(pki67) AND NOT MISSING(ski67( ;/* 결측값 제거 */
    KEEP randf pki67 ski67 ; /* 필요한 변수만 유지 */
RUN;

DATA data_numeric;
    SET data;
    /* 문자형 변수 pki67을 수치형 변수 pki67_num으로 변환 */
    pki67_num = INPUT(pki67, BEST32.);
    DROP pki67; 
    RENAME pki67_num = pki67; /* 새 변수 이름을 원래 이름으로 변경 */
RUN;


/* Kruskal-Wallis 검정 수행 */
PROC NPAR1WAY DATA=data_numeric WILCOXON;
    CLASS randf; /* 치료군을 나타내는 변수 */
    VAR pki67;   /* 분석할 변수 */
RUN;

DATA data_numeric;
    SET data;
    /* 문자형 변수 pki67을 수치형 변수 pki67_num으로 변환 */
    ski67_num = INPUT(ski67, BEST32.);
    DROP ski67; 
    RENAME ski67_num = ski67;
RUN;

PROC NPAR1WAY DATA=data_numeric WILCOXON;
    CLASS randf; /* 치료군을 나타내는 변수 */
    VAR ski67;   /* 분석할 변수 */
RUN;



