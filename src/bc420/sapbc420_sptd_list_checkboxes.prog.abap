*&---------------------------------------------------------------------*
*& Report   SAPBC420_SPTD_LIST_CHECKBOXES
*&
*& Generates a list with KNA1-Data :
*& Each row can be selected via check-box !
*& This program is used to show BI-recording on interactive lists !
*&----------------------------------------------------------------------
REPORT  sapbc420_sptd_list_checkboxes LINE-SIZE 150 .

NODES: kna1.
DATA: wa_kna1 LIKE kna1, mark.

INITIALIZATION.
*################
  dd_kunnr-low = 'Z-00-00000'.
  dd_kunnr-high = 'Z-99-99999'.
  dd_kunnr-option = 'BT'.
  APPEND dd_kunnr.

GET kna1.
* Formatted output of data from table spfli
  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  WRITE: / mark AS CHECKBOX,
        3 kna1-kunnr,
        15 kna1-name1,
        AT sy-linsz space.
* Sending information to the hide area
  HIDE: kna1-kunnr .



END-OF-SELECTION.
************************
  SET PF-STATUS 'BASELIST'.
* SET TITLEBAR 'BASETITLE'.
  CLEAR kna1-kunnr.

AT LINE-SELECTION.
***********************
  CHECK NOT kna1-kunnr IS INITIAL.
  SET PF-STATUS 'BASELIST' EXCLUDING 'PICK'.
  SET TITLEBAR 'TEXT'.
  DO.
    CLEAR mark.
*  Read list line by line
    READ LINE sy-index FIELD VALUE mark.
*  If end of list is reached
    IF sy-subrc <> 0. EXIT. ENDIF.
*  Check whether line is selected
    CHECK mark <> space.
    FORMAT COLOR COL_GROUP.
*    WRITE: /(4) SPFLI-CARRID  NO-GAP,
*               SPFLI-CONNID , AT SY-LINSZ SPACE.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    SELECT name1 stras ort01 pstlz
           INTO CORRESPONDING FIELDS OF wa_kna1 FROM kna1
           WHERE kunnr = kna1-kunnr.
      WRITE : /5 wa_kna1-name1.
      WRITE : /5 wa_kna1-stras.
      WRITE : /5 wa_kna1-pstlz.
      WRITE : 15 wa_kna1-ort01.
    ENDSELECT.
    SKIP.
*  Modify line which is currently used by the READ statement
    MODIFY CURRENT LINE
           FIELD VALUE  mark FROM space.
*          FIELD FORMAT MARK INPUT OFF
*          LINE FORMAT INTENSIFIED.
  ENDDO.
  CLEAR kna1-kunnr.


TOP-OF-PAGE DURING LINE-SELECTION.
  CASE sy-lsind.
    WHEN '1'.
      FORMAT COLOR COL_HEADING.
      WRITE: 5 'Kunden Adresse'(001).
      ULINE.
  ENDCASE.
