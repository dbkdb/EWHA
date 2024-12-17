/* 1. 데이터 불러오기 */
PROC IMPORT DATAFILE="D:\대학원\2024-2\임상시험자료분석\PROJECT\DATA\유방암\data_new.csv"
    OUT=E
    DBMS=CSV 
    REPLACE;
    GETNAMES=YES;
RUN;

/* 2. 결측값 제거 및 필요한 변수 유지 */
DATA E;
    SET E;
    IF NOT MISSING(pki67) AND NOT MISSING(ski67); /* 결측값 제거 */
    KEEP randf pki67 ski67 DIFF; /* 필요한 변수만 유지 */
RUN;

/* 3. 문자형 변수를 숫자형으로 변환 */
DATA data_numeric;
    SET E; /* 수정된 부분: data 대신 E 사용 */
    /* 문자형 변수 pki67과 ski67을 숫자형으로 변환 */
    pki67_num = INPUT(pki67, BEST32.);
    ski67_num = INPUT(ski67, BEST32.);
    DROP pki67 ski67; 
    RENAME pki67_num = pki67 ski67_num = ski67; /* 숫자형 변수 이름을 원래 이름으로 변경 */
RUN;

/* 4. GLM 분석 수행 */
PROC GLM DATA=data_numeric;
    CLASS randf;
    MODEL ski67 = randf;
    MEANS randf / T DUNNETT('Arm1'); /* 기준 그룹으로 randf의 특정 레벨 지정 */
RUN;
