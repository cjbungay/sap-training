*&---------------------------------------------------------------------*
*& Report  SAPBC405_SSCD_SEL_SCREEN_I                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&     Defining and designing of the selection-screen                  *
*&         - with frame and frame-title                                *
*&---------------------------------------------------------------------*


INCLUDE BC405_SSCD_SEL_SCREEN_ITOP.
INCLUDE <ICON>.

*  Block with frame
   SELECTION-SCREEN BEGIN OF BLOCK CARR WITH FRAME.
    SELECT-OPTIONS: SO_CARR FOR WA_SFLIGHT-CARRID.
   SELECTION-SCREEN END OF BLOCK CARR.

*  Block with frame and title
   SELECTION-SCREEN BEGIN OF BLOCK LIMIT WITH FRAME TITLE TEXT-001.
    PARAMETERS:  PA_LIM_1  RADIOBUTTON GROUP LIM,
                 PA_LIM_2  RADIOBUTTON GROUP LIM,
                 PA_LIM_3  RADIOBUTTON GROUP LIM.
   SELECTION-SCREEN END OF BLOCK LIMIT.


START-OF-SELECTION.
 CASE MARK.
   WHEN PA_LIM_1.
     SELECT CARRID CONNID FLDATE PRICE CURRENCY FROM SFLIGHT
            INTO TABLE ITAB_SFLIGHT
             WHERE CARRID IN SO_CARR
             AND   PRICE LE '200'.
     PERFORM DATA_OUTPUT.
   WHEN PA_LIM_2.
     SELECT CARRID CONNID FLDATE PRICE CURRENCY FROM SFLIGHT
       INTO TABLE ITAB_SFLIGHT
           WHERE CARRID  IN SO_CARR
           AND   PRICE  BETWEEN '200' AND '400'.
     PERFORM DATA_OUTPUT.
   WHEN PA_LIM_3.
     SELECT CARRID CONNID FLDATE PRICE CURRENCY FROM SFLIGHT
       INTO TABLE ITAB_SFLIGHT
           WHERE CARRID IN SO_CARR
           AND   PRICE BETWEEN '400' AND '600'.
     PERFORM DATA_OUTPUT.

 ENDCASE.

IF SY-SUBRC <> 0.
  WRITE: / ICON_RED_LIGHT AS ICON,  TEXT-002.
ENDIF.


*---------------------------------------------------------------------*
*       form data_output                                              *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
 FORM DATA_OUTPUT.
   LOOP AT ITAB_SFLIGHT INTO WA_SFLIGHT.
     WRITE: / WA_SFLIGHT-CARRID,
              WA_SFLIGHT-CONNID,
              WA_SFLIGHT-FLDATE,
              (8) WA_SFLIGHT-PRICE CURRENCY WA_SFLIGHT-CURRENCY,
              WA_SFLIGHT-CURRENCY.
   ENDLOOP.
 ENDFORM.
