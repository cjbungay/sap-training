*----------------------------------------------------------------------*
***INCLUDE BC405SSCD_E_SEL_SCREEN_IIF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  DATA_OUT_OCC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DATA_OUT_OCC.

  IF MARK = PA_COL AND MARK = PA_ICO.

    LOOP AT ITAB_SFLIGHT INTO WA_SFLIGHT.
    FREE_SEATS = WA_SFLIGHT-SEATSMAX - WA_SFLIGHT-SEATSOCC.
      ON CHANGE OF WA_SFLIGHT-CONNID.
        WRITE: / WA_SFLIGHT-CARRID,
                 WA_SFLIGHT-CONNID.
      ENDON.
      WRITE: /  WA_SFLIGHT-FLDATE,
                WA_SFLIGHT-SEATSOCC COLOR COL_NORMAL.
      IF WA_SFLIGHT-SEATSOCC LT  WA_SFLIGHT-SEATSMAX.
        WRITE: ICON_GREEN_LIGHT AS ICON.
      ENDIF.
    ENDLOOP.

  ELSEIF SPACE = PA_COL AND MARK = PA_ICO.
    LOOP AT ITAB_SFLIGHT INTO WA_SFLIGHT.
    FREE_SEATS = WA_SFLIGHT-SEATSMAX - WA_SFLIGHT-SEATSOCC.
      ON CHANGE OF WA_SFLIGHT-CONNID.
        WRITE: / WA_SFLIGHT-CARRID,
                 WA_SFLIGHT-CONNID.
      ENDON.
      WRITE: /  WA_SFLIGHT-FLDATE,
                WA_SFLIGHT-SEATSOCC.
      IF WA_SFLIGHT-SEATSOCC LT  WA_SFLIGHT-SEATSMAX.
        WRITE: ICON_GREEN_LIGHT AS ICON.
      ENDIF.
    ENDLOOP.

  ELSEIF MARK = PA_COL AND SPACE =  PA_ICO.
    LOOP AT ITAB_SFLIGHT INTO WA_SFLIGHT.
    FREE_SEATS = WA_SFLIGHT-SEATSMAX - WA_SFLIGHT-SEATSOCC.
      ON CHANGE OF WA_SFLIGHT-CONNID.
        WRITE: / WA_SFLIGHT-CARRID,
                 WA_SFLIGHT-CONNID.
      ENDON.
      WRITE: /  WA_SFLIGHT-FLDATE,
                WA_SFLIGHT-SEATSOCC COLOR COL_NORMAL.
    ENDLOOP.

  ELSEIF SPACE = PA_COL AND SPACE =  PA_ICO.
    LOOP AT ITAB_SFLIGHT INTO WA_SFLIGHT.
    FREE_SEATS = WA_SFLIGHT-SEATSMAX - WA_SFLIGHT-SEATSOCC.
      ON CHANGE OF WA_SFLIGHT-CONNID.
        WRITE: / WA_SFLIGHT-CARRID,
                 WA_SFLIGHT-CONNID.
      ENDON.
      WRITE: /  WA_SFLIGHT-FLDATE,
                WA_SFLIGHT-SEATSOCC.
    ENDLOOP.
  ENDIF.
  ENDFORM.                             " DATA_OUT_OCC
*&---------------------------------------------------------------------*
*&      Form  DATA_OUT_FRE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DATA_OUT_FRE.
  IF MARK = PA_COL AND MARK = PA_ICO.

    LOOP AT ITAB_SFLIGHT INTO WA_SFLIGHT.
    FREE_SEATS = WA_SFLIGHT-SEATSMAX - WA_SFLIGHT-SEATSOCC.
      ON CHANGE OF WA_SFLIGHT-CONNID.
        WRITE: / WA_SFLIGHT-CARRID,
                 WA_SFLIGHT-CONNID.
      ENDON.
      WRITE: /  WA_SFLIGHT-FLDATE,
                FREE_SEATS COLOR COL_NORMAL.
      IF WA_SFLIGHT-SEATSOCC LT  WA_SFLIGHT-SEATSMAX.
        WRITE: ICON_GREEN_LIGHT AS ICON.
      ENDIF.
    ENDLOOP.

  ELSEIF SPACE = PA_COL AND MARK = PA_ICO.
    LOOP AT ITAB_SFLIGHT INTO WA_SFLIGHT.
    FREE_SEATS = WA_SFLIGHT-SEATSMAX - WA_SFLIGHT-SEATSOCC.
      ON CHANGE OF WA_SFLIGHT-CONNID.
        WRITE: / WA_SFLIGHT-CARRID,
                 WA_SFLIGHT-CONNID.
      ENDON.
      WRITE: /  WA_SFLIGHT-FLDATE,
                FREE_SEATS.
      IF WA_SFLIGHT-SEATSOCC LT  WA_SFLIGHT-SEATSMAX.
        WRITE: ICON_GREEN_LIGHT AS ICON.
      ENDIF.
    ENDLOOP.

  ELSEIF MARK = PA_COL AND SPACE =  PA_ICO.
    LOOP AT ITAB_SFLIGHT INTO WA_SFLIGHT.
    FREE_SEATS = WA_SFLIGHT-SEATSMAX - WA_SFLIGHT-SEATSOCC.
      ON CHANGE OF WA_SFLIGHT-CONNID.
        WRITE: / WA_SFLIGHT-CARRID,
                 WA_SFLIGHT-CONNID.
      ENDON.
      WRITE: /  WA_SFLIGHT-FLDATE,
                FREE_SEATS COLOR COL_NORMAL.
    ENDLOOP.

  ELSEIF SPACE = PA_COL AND SPACE =  PA_ICO.
    LOOP AT ITAB_SFLIGHT INTO WA_SFLIGHT.
    FREE_SEATS = WA_SFLIGHT-SEATSMAX - WA_SFLIGHT-SEATSOCC.
      ON CHANGE OF WA_SFLIGHT-CONNID.
        WRITE: / WA_SFLIGHT-CARRID,
                 WA_SFLIGHT-CONNID.
      ENDON.
      WRITE: /  WA_SFLIGHT-FLDATE,
                FREE_SEATS.
    ENDLOOP.
 ENDIF.
ENDFORM.                               " DATA_OUT_FRE
*&---------------------------------------------------------------------*
*&      Form  DATA_OUT_ALL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DATA_OUT_ALL.
  IF MARK = PA_COL AND MARK = PA_ICO.

    LOOP AT ITAB_SFLIGHT INTO WA_SFLIGHT.
    FREE_SEATS = WA_SFLIGHT-SEATSMAX - WA_SFLIGHT-SEATSOCC.
      ON CHANGE OF WA_SFLIGHT-CONNID.
        WRITE: / WA_SFLIGHT-CARRID,
                 WA_SFLIGHT-CONNID.
      ENDON.
      WRITE: /  WA_SFLIGHT-FLDATE,
                WA_SFLIGHT-SEATSMAX COLOR COL_NORMAL,
                WA_SFLIGHT-SEATSOCC COLOR COL_NORMAL,
                FREE_SEATS COLOR COL_NORMAL.
      IF WA_SFLIGHT-SEATSOCC LT  WA_SFLIGHT-SEATSMAX.
        WRITE: ICON_GREEN_LIGHT AS ICON.
      ENDIF.
    ENDLOOP.

  ELSEIF SPACE = PA_COL AND MARK = PA_ICO.
    LOOP AT ITAB_SFLIGHT INTO WA_SFLIGHT.
    FREE_SEATS = WA_SFLIGHT-SEATSMAX - WA_SFLIGHT-SEATSOCC.
      ON CHANGE OF WA_SFLIGHT-CONNID.
        WRITE: / WA_SFLIGHT-CARRID,
                 WA_SFLIGHT-CONNID.
      ENDON.
      WRITE: /  WA_SFLIGHT-FLDATE,
                WA_SFLIGHT-SEATSMAX,
                WA_SFLIGHT-SEATSOCC,
                FREE_SEATS.
      IF WA_SFLIGHT-SEATSOCC LT  WA_SFLIGHT-SEATSMAX.
        WRITE: ICON_GREEN_LIGHT AS ICON.
      ENDIF.
    ENDLOOP.

  ELSEIF MARK = PA_COL AND SPACE =  PA_ICO.
    LOOP AT ITAB_SFLIGHT INTO WA_SFLIGHT.
    FREE_SEATS = WA_SFLIGHT-SEATSMAX - WA_SFLIGHT-SEATSOCC.
      ON CHANGE OF WA_SFLIGHT-CONNID.
        WRITE: / WA_SFLIGHT-CARRID,
                 WA_SFLIGHT-CONNID.
      ENDON.
      WRITE: /  WA_SFLIGHT-FLDATE,
                WA_SFLIGHT-SEATSMAX COLOR COL_NORMAL,
                WA_SFLIGHT-SEATSOCC COLOR COL_NORMAL,
                FREE_SEATS COLOR COL_NORMAL.
    ENDLOOP.

  ELSEIF SPACE = PA_COL AND SPACE =  PA_ICO.
    LOOP AT ITAB_SFLIGHT INTO WA_SFLIGHT.
    FREE_SEATS = WA_SFLIGHT-SEATSMAX - WA_SFLIGHT-SEATSOCC.
      ON CHANGE OF WA_SFLIGHT-CONNID.
        WRITE: / WA_SFLIGHT-CARRID,
                 WA_SFLIGHT-CONNID.
      ENDON.
      WRITE: /  WA_SFLIGHT-FLDATE,
                WA_SFLIGHT-SEATSMAX,
                WA_SFLIGHT-SEATSOCC,
                FREE_SEATS.
    ENDLOOP.
ENDIF.
ENDFORM.                    " DATA_OUT_ALL
