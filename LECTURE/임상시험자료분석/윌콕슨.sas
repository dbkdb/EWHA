PROC IMPORT DATAFILE="D:\대학원\2024-2\임상시험자료분석\PROJECT\DATA\유방암\E.csv"
    OUT=E
    DBMS=CSV 
    REPLACE;
    GETNAMES=YES;
RUN;

PROC IMPORT DATAFILE="D:\대학원\2024-2\임상시험자료분석\PROJECT\DATA\유방암\A.csv"
    OUT=A
    DBMS=CSV 
    REPLACE;
    GETNAMES=YES;
RUN;

PROC IMPORT DATAFILE="D:\대학원\2024-2\임상시험자료분석\PROJECT\DATA\유방암\L.csv"
    OUT=L
    DBMS=CSV 
    REPLACE;
    GETNAMES=YES;
RUN;


DATA E;
    SET E;
    IF NOT MISSING(pki67) AND NOT MISSING(ski67); /* 결측값 제거 */
    DIFF = ski67 - pki67;   /* 차이 계산 */
    KEEP randf pki67 ski67 DIFF; /* 필요한 변수만 유지 */
RUN;

PROC UNIVARIATE NORMAL DATA=E;
    VAR DIFF; /* 결측값이 있는 관측값은 자동 제외 */
RUN;

DATA A;
    SET A;
    IF NOT MISSING(pki67) AND NOT MISSING(ski67); /* 결측값 제거 */
    DIFF = ski67 - pki67;   /* 차이 계산 */
    KEEP randf pki67 ski67 DIFF; /* 필요한 변수만 유지 */
RUN;

PROC UNIVARIATE NORMAL DATA=A;
    VAR DIFF; /* 결측값이 있는 관측값은 자동 제외 */
RUN;


DATA L;
    SET L;
    IF NOT MISSING(pki67) AND NOT MISSING(ski67); /* 결측값 제거 */
    DIFF = ski67 - pki67;   /* 차이 계산 */
    KEEP randf pki67 ski67 DIFF; /* 필요한 변수만 유지 */
RUN;

PROC UNIVARIATE NORMAL DATA=L;
    VAR DIFF; /* 결측값이 있는 관측값은 자동 제외 */
RUN;



