*----------------------------------------------------------------------*
*   INCLUDE BC405_GDAD_CURSOR_OPF01                                    *
*----------------------------------------------------------------------*
FORM DATA_OUTPUT.
DATA POS TYPE I VALUE 40.
  LOOP AT ITAB_SPFLI INTO WA_SPFLI.
    ON CHANGE OF WA_SPFLI-CARRID.
      FORMAT COLOR COL_HEADING INTENSIFIED OFF.
      WRITE: / SY-VLINE, WA_SPFLI-CARRID, WA_SPFLI-CONNID,
               AT POS SY-VLINE,
             / SY-VLINE,  WA_SPFLI-CITYFROM, WA_SPFLI-CITYTO,
               AT POS SY-VLINE.
    ENDON.

    LOOP AT ITAB_SFLIGHT INTO WA_SFLIGHT.
     FORMAT COLOR COL_NORMAL.
        WRITE: / SY-VLINE, WA_SFLIGHT-FLDATE, WA_SFLIGHT-SEATSMAX,
                 WA_SFLIGHT-SEATSOCC, AT POS SY-VLINE.
    ENDLOOP.
  ENDLOOP.

ENDFORM.
