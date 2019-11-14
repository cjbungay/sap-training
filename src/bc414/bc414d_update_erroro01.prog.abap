*----------------------------------------------------------------------*
***INCLUDE BC414D_UPDATE_ERRORO01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS '100'.
  SET TITLEBAR '100'.

ENDMODULE.                 " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  INIT_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE INIT_0100 OUTPUT.
  if first_time is initial.
    first_time = 'X'.
* create 'spfli' dummy entry
    spfli-carrid = 'XX'.
    spfli-connid = '9999'.
* create 'sflight' dummy entries
    wa_sflight-carrid = spfli-carrid.
    wa_sflight-connid = spfli-connid.
*   - 1 -
    wa_sflight-fldate = sy-datum.
    wa_sflight-seatsmax = '200'.
    wa_sflight-seatsocc = '78'.
    insert wa_sflight into table it_sflight.
*   - 2 -
    wa_sflight-fldate = sy-datum + 1.
    wa_sflight-seatsmax = '100'.
    wa_sflight-seatsocc = '50'.
    insert wa_sflight into table it_sflight.
*   - 3 -
    wa_sflight-fldate = sy-datum + 2.
    wa_sflight-seatsmax = '250'.
    wa_sflight-seatsocc = '166'.
    insert wa_sflight into table it_sflight.
  endif.

ENDMODULE.                 " INIT_0100  OUTPUT
