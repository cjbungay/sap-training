*----------------------------------------------------------------------*
*   INCLUDE    BC405_GDAD_FOR_ALL_ENTRIESF01                           *
*----------------------------------------------------------------------*
FORM data_output.
  DATA pos TYPE i VALUE 45.

  LOOP AT itab_sflight INTO wa_sflight.
    FORMAT COLOR COL_KEY.
    WRITE: / sy-vline, wa_sflight-carrid, wa_sflight-connid.
    FORMAT COLOR COL_NORMAL.
    WRITE:  wa_sflight-fldate, wa_sflight-seatsmax,
            wa_sflight-seatsocc, AT pos sy-vline.
  ENDLOOP.
  WRITE AT /(pos) sy-uline.

ENDFORM.
