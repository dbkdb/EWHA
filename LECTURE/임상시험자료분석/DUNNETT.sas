/* 1. ������ �ҷ����� */
PROC IMPORT DATAFILE="D:\���п�\2024-2\�ӻ�����ڷ�м�\PROJECT\DATA\�����\data_new.csv"
    OUT=E
    DBMS=CSV 
    REPLACE;
    GETNAMES=YES;
RUN;

/* 2. ������ ���� �� �ʿ��� ���� ���� */
DATA E;
    SET E;
    IF NOT MISSING(pki67) AND NOT MISSING(ski67); /* ������ ���� */
    KEEP randf pki67 ski67 DIFF; /* �ʿ��� ������ ���� */
RUN;

/* 3. ������ ������ ���������� ��ȯ */
DATA data_numeric;
    SET E; /* ������ �κ�: data ��� E ��� */
    /* ������ ���� pki67�� ski67�� ���������� ��ȯ */
    pki67_num = INPUT(pki67, BEST32.);
    ski67_num = INPUT(ski67, BEST32.);
    DROP pki67 ski67; 
    RENAME pki67_num = pki67 ski67_num = ski67; /* ������ ���� �̸��� ���� �̸����� ���� */
RUN;

/* 4. GLM �м� ���� */
PROC GLM DATA=data_numeric;
    CLASS randf;
    MODEL ski67 = randf;
    MEANS randf / T DUNNETT('Arm1'); /* ���� �׷����� randf�� Ư�� ���� ���� */
RUN;
