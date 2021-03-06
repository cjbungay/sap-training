*----------------------------------------------------------------------*
*   INCLUDE   BC405_GDAD_NESTED_SELECTSF01                             *
*----------------------------------------------------------------------*
FORM DATA_OUTPUT.
DATA POS TYPE I VALUE 60.
  LOOP AT ITAB_SPFLI INTO WA_SPFLI.
    ON CHANGE OF WA_SPFLI-CARRID.
      FORMAT COLOR COL_HEADING INTENSIFIED ON.
      WRITE: / SY-VLINE, WA_SPFLI-CARRID, WA_SPFLI-CONNID,
               AT POS SY-VLINE,
             / SY-VLINE, WA_SPFLI-CITYFROM, WA_SPFLI-CITYTO,
               AT POS SY-VLINE.
    ENDON.
    LOOP AT ITAB_SFLIGHT INTO WA_SFLIGHT.
      LOOP AT ITAB_SBOOK INTO WA_SBOOK.
        FORMAT COLOR COL_HEADING INTENSIFIED OFF.
        ON CHANGE OF WA_SFLIGHT-FLDATE.
        WRITE: / SY-VLINE, WA_SFLIGHT-FLDATE, WA_SFLIGHT-SEATSMAX,
                 WA_SFLIGHT-SEATSOCC, AT POS SY-VLINE.
        ENDON.
        FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
         WRITE: / SY-VLINE, WA_SBOOK-BOOKID, WA_SBOOK-CUSTOMID,
                  WA_SBOOK-CUSTTYPE, WA_SBOOK-CLASS, AT POS SY-VLINE.
      ENDLOOP.
    ENDLOOP.
  ENDLOOP.

ENDFORM.
