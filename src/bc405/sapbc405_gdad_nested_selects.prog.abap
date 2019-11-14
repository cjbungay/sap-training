*&---------------------------------------------------------------------*
*& Report  SAPBC405_GDAD_NESTED_SELECTS                                *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

INCLUDE BC405_GDAD_NESTED_SELECTSTOP.
INCLUDE BC405_GDAD_NESTED_SELECTSF01.

START-OF-SELECTION.

 SELECT CARRID CONNID CITYFROM AIRPFROM CITYTO AIRPTO DEPTIME ARRTIME
   INTO WA_SPFLI FROM SPFLI
     WHERE CITYFROM IN SO_CITYF
     AND   CITYTO   IN SO_CITYT.
       APPEND WA_SPFLI TO ITAB_SPFLI.
    SELECT  CARRID CONNID FLDATE SEATSMAX SEATSOCC
      INTO WA_SFLIGHT FROM SFLIGHT
        WHERE CARRID = WA_SPFLI-CARRID
        AND   CONNID = WA_SPFLI-CONNID.
         APPEND WA_SFLIGHT TO ITAB_SFLIGHT.
      SELECT BOOKID CUSTOMID CUSTTYPE CLASS
        INTO WA_SBOOK FROM SBOOK
          WHERE CARRID = WA_SFLIGHT-CARRID
          AND   CONNID = WA_SFLIGHT-CONNID
          AND   FLDATE = WA_SFLIGHT-FLDATE.
           APPEND WA_SBOOK TO ITAB_SBOOK.
      ENDSELECT.
    ENDSELECT.
 ENDSELECT.


PERFORM DATA_OUTPUT.
