*&---------------------------------------------------------------------*
*& Report  SAPBC405_GDAD_CURSOR_OP                                     *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*


INCLUDE BC405_GDAD_CURSOR_OPTOP.
INCLUDE BC405_GDAD_CURSOR_OPF01.

START-OF-SELECTION.

OPEN CURSOR C1 FOR
        SELECT MANDT CARRID CONNID CITYFROM CITYTO
         FROM SPFLI
          WHERE CARRID IN SO_CARID
           AND  CONNID IN SO_CONID
          ORDER BY PRIMARY KEY.
OPEN CURSOR C2 FOR
        SELECT MANDT CARRID CONNID FLDATE SEATSMAX SEATSOCC
         FROM SFLIGHT
           WHERE CARRID IN SO_CARID
           AND  CONNID  IN SO_CONID
          ORDER BY PRIMARY KEY.

DO.
  FETCH NEXT CURSOR C1 INTO WA_SPFLI.
   IF SY-SUBRC NE 0. EXIT. ENDIF.
    APPEND WA_SPFLI TO ITAB_SPFLI.

    IF SY-INDEX = 1.
      FETCH NEXT CURSOR C2 INTO WA_SFLIGHT.
       IF SY-SUBRC NE 0. EXIT. ENDIF.
    ENDIF.

  WHILE
     SY-SUBRC = 0
     AND WA_SPFLI-CARRID = WA_SFLIGHT-CARRID
     AND WA_SPFLI-CONNID = WA_SFLIGHT-CONNID.
      APPEND WA_SFLIGHT TO ITAB_SFLIGHT.
       FETCH NEXT CURSOR C2 INTO  WA_SFLIGHT.
  ENDWHILE.

  IF SY-SUBRC NE 0. EXIT. ENDIF.

ENDDO.

PERFORM DATA_OUTPUT.
