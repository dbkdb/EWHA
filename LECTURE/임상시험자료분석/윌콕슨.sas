PROC IMPORT DATAFILE="D:\���п�\2024-2\�ӻ�����ڷ�м�\PROJECT\DATA\�����\E.csv"
    OUT=E
    DBMS=CSV 
    REPLACE;
    GETNAMES=YES;
RUN;

PROC IMPORT DATAFILE="D:\���п�\2024-2\�ӻ�����ڷ�м�\PROJECT\DATA\�����\A.csv"
    OUT=A
    DBMS=CSV 
    REPLACE;
    GETNAMES=YES;
RUN;

PROC IMPORT DATAFILE="D:\���п�\2024-2\�ӻ�����ڷ�м�\PROJECT\DATA\�����\L.csv"
    OUT=L
    DBMS=CSV 
    REPLACE;
    GETNAMES=YES;
RUN;


DATA E;
    SET E;
    IF NOT MISSING(pki67) AND NOT MISSING(ski67); /* ������ ���� */
    DIFF = ski67 - pki67;   /* ���� ��� */
    KEEP randf pki67 ski67 DIFF; /* �ʿ��� ������ ���� */
RUN;

PROC UNIVARIATE NORMAL DATA=E;
    VAR DIFF; /* �������� �ִ� �������� �ڵ� ���� */
RUN;

DATA A;
    SET A;
    IF NOT MISSING(pki67) AND NOT MISSING(ski67); /* ������ ���� */
    DIFF = ski67 - pki67;   /* ���� ��� */
    KEEP randf pki67 ski67 DIFF; /* �ʿ��� ������ ���� */
RUN;

PROC UNIVARIATE NORMAL DATA=A;
    VAR DIFF; /* �������� �ִ� �������� �ڵ� ���� */
RUN;


DATA L;
    SET L;
    IF NOT MISSING(pki67) AND NOT MISSING(ski67); /* ������ ���� */
    DIFF = ski67 - pki67;   /* ���� ��� */
    KEEP randf pki67 ski67 DIFF; /* �ʿ��� ������ ���� */
RUN;

PROC UNIVARIATE NORMAL DATA=L;
    VAR DIFF; /* �������� �ִ� �������� �ڵ� ���� */
RUN;



