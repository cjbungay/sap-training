*&---------------------------------------------------------------------*
*& Report  SAPBC405_SSCD_SEL_SCREEN_II                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*&     Defining and designing of the selection-screen                  *
*&         - with frame and frame-title                                *
*&         - radiobutton group displayed in one line                   *
*&---------------------------------------------------------------------*

INCLUDE BC405_SSCD_SEL_SCREEN_IITOP.
INCLUDE <ICON>.

*  Block with frame
   SELECTION-SCREEN BEGIN OF BLOCK FLIGHT WITH FRAME.
    SELECT-OPTIONS: SO_CARR FOR WA_SFLIGHT-CARRID.
    SELECT-OPTIONS: SO_FLDT FOR WA_SFLIGHT-FLDATE.
   SELECTION-SCREEN END OF BLOCK FLIGHT.
*  Nested blocks with frame and title
*  Radiobutton group
*  Parameters displayed in one line
 SELECTION-SCREEN BEGIN OF BLOCK OUT_PUT  WITH FRAME TITLE TEXT-S01.
* Radiobutton group with frame and frame text
   SELECTION-SCREEN BEGIN OF BLOCK SEATS WITH FRAME TITLE TEXT-S02.
     PARAMETERS PA_OCC RADIOBUTTON GROUP SEAT.
     PARAMETERS PA_FRE RADIOBUTTON GROUP SEAT.
     PARAMETERS PA_ALL RADIOBUTTON GROUP SEAT.
   SELECTION-SCREEN END OF BLOCK SEATS.
* Parameters displayed in one line
     SELECTION-SCREEN  BEGIN OF LINE.
       SELECTION-SCREEN COMMENT 1(20) TEXT-S03.
       SELECTION-SCREEN COMMENT POS_LOW(8) TEXT-S04.
       PARAMETERS PA_COL AS CHECKBOX.
       SELECTION-SCREEN COMMENT POS_HIGH(8) TEXT-S05.
       PARAMETERS PA_ICO AS CHECKBOX.
     SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN END OF BLOCK OUT_PUT.

START-OF-SELECTION.
  SELECT CARRID CONNID FLDATE SEATSMAX SEATSOCC FROM SFLIGHT
         INTO TABLE ITAB_SFLIGHT
          WHERE CARRID IN SO_CARR
          AND   FLDATE IN SO_FLDT.

END-OF-SELECTION.

* Radiobutton group
CASE MARK.
 WHEN PA_OCC.
  PERFORM DATA_OUT_OCC.
 WHEN PA_FRE.
  PERFORM DATA_OUT_FRE.
 WHEN PA_ALL.
  PERFORM DATA_OUT_ALL.
ENDCASE.

TOP-OF-PAGE.
 IF MARK = PA_OCC.
  WRITE:     TEXT-00A.
  ULINE.
  WRITE:   /15 TEXT-00B.
  ULINE.

 ELSEIF MARK = PA_FRE.
  WRITE:     TEXT-00A.
  ULINE.
  WRITE:  /15 TEXT-00C.
  ULINE.

 ELSEIF MARK = PA_ALL.
  WRITE:     TEXT-00A.
  ULINE.
  WRITE: /15 TEXT-00D,
             TEXT-00B,
             TEXT-00C.
 ENDIF.

INCLUDE BC405_SSCD_SEL_SCREEN_IIF01.
*INCLUDE BC405SSCD_E_SEL_SCREEN_IIF01.
