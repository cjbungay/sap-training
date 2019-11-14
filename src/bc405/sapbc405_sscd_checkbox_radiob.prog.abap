*&---------------------------------------------------------------------*
*& Report  SAPBC405_SSCD_CHECKBOX_RADIOB                               *
*&                                                                     *
*&---------------------------------------------------------------------*
*&      Defining selection criteria (PARAMETERS):
*&           -   with default values
*&           -   AS CHECKBOX
*&           -   RADIOBUTTON GROUP
*&---------------------------------------------------------------------*

REPORT  SAPBC405_SSCD_CHECKBOX_RADIOB.

INCLUDE BC405_SSCD_CHECKBOX_RADIOBTOP.
INCLUDE <ICON>.


PARAMETERS: PA_CARR LIKE SFLIGHT-CARRID DEFAULT 'AA',
            PA_NAME AS CHECKBOX DEFAULT 'X',
            PA_CURR AS CHECKBOX DEFAULT 'X',
            PA_LIM_1  RADIOBUTTON GROUP LIM,
            PA_LIM_2  RADIOBUTTON GROUP LIM,
            PA_LIM_3  RADIOBUTTON GROUP LIM .

CONSTANTS MARK VALUE 'X'.

* Check, if any checkbox has been selected
IF PA_NAME EQ MARK.
  SELECT SINGLE CARRNAME FROM SCARR INTO (SCARR-CARRNAME)
    WHERE CARRID = PA_CARR.
  WRITE: / TEXT-001, SCARR-CARRNAME.
ENDIF.

IF PA_CURR EQ MARK.
  SELECT SINGLE CURRCODE FROM SCARR INTO (SCARR-CURRCODE)
    WHERE CARRID = PA_CARR.
  WRITE: / TEXT-002, SCARR-CURRCODE.
ENDIF.


* Check, which radiobutton has been selected
CASE MARK.
  WHEN PA_LIM_1.
    SELECT CARRID CONNID FLDATE PRICE CURRENCY FROM SFLIGHT
           INTO TABLE ITAB_SFLIGHT
            WHERE CARRID  =  PA_CARR
            AND   PRICE LE '500'.
    PERFORM DATA_OUTPUT.
  WHEN PA_LIM_2.
    SELECT CARRID CONNID FLDATE PRICE CURRENCY FROM SFLIGHT
      INTO TABLE ITAB_SFLIGHT
          WHERE CARRID  =  PA_CARR
          AND   PRICE  BETWEEN '500' AND '1000'.
    PERFORM DATA_OUTPUT.
  WHEN PA_LIM_3.
    SELECT CARRID CONNID FLDATE PRICE CURRENCY FROM SFLIGHT
      INTO TABLE ITAB_SFLIGHT
          WHERE CARRID  =  PA_CARR
          AND   PRICE BETWEEN '1000' AND '1500'.
    PERFORM DATA_OUTPUT.
ENDCASE.

IF SY-SUBRC <> 0.
  WRITE: / ICON_RED_LIGHT AS ICON,  TEXT-003.
ENDIF.

*---------------------------------------------------------------------*
*       FORM DATA_OUTPUT                                              *
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
