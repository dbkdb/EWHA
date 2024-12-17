
PROC IMPORT DATAFILE="D:\���п�\2024-2\�ӻ�����ڷ�м�\PROJECT\DATA\�����\data_new.csv"
    OUT=data
    DBMS=CSV 
    REPLACE;
    GETNAMES=YES;
RUN;


DATA data;
    SET data;
    IF NOT MISSING(pki67) AND NOT MISSING(ski67( ;/* ������ ���� */
    KEEP randf pki67 ski67 ; /* �ʿ��� ������ ���� */
RUN;

DATA data_numeric;
    SET data;
    /* ������ ���� pki67�� ��ġ�� ���� pki67_num���� ��ȯ */
    pki67_num = INPUT(pki67, BEST32.);
    DROP pki67; 
    RENAME pki67_num = pki67; /* �� ���� �̸��� ���� �̸����� ���� */
RUN;


/* Kruskal-Wallis ���� ���� */
PROC NPAR1WAY DATA=data_numeric WILCOXON;
    CLASS randf; /* ġ�ᱺ�� ��Ÿ���� ���� */
    VAR pki67;   /* �м��� ���� */
RUN;

DATA data_numeric;
    SET data;
    /* ������ ���� pki67�� ��ġ�� ���� pki67_num���� ��ȯ */
    ski67_num = INPUT(ski67, BEST32.);
    DROP ski67; 
    RENAME ski67_num = ski67;
RUN;

PROC NPAR1WAY DATA=data_numeric WILCOXON;
    CLASS randf; /* ġ�ᱺ�� ��Ÿ���� ���� */
    VAR ski67;   /* �м��� ���� */
RUN;



