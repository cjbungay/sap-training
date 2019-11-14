*----------------------------------------------------------------------*
*   INCLUDE BC410GUID_A_GUI_PREF01                                     *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  READ_CONNECTIONS
*&---------------------------------------------------------------------*
FORM read_connections.

  SELECT * INTO TABLE it_spfli FROM spfli
    WHERE carrid IN so_carr.


ENDFORM.                               " READ_CONNECTIONS

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_CONNECTIONS
*&---------------------------------------------------------------------*
FORM display_connections.

  LOOP AT it_spfli INTO wa_spfli.

    WRITE: / wa_spfli-carrid,
             wa_spfli-connid,
             wa_spfli-cityfrom,
             wa_spfli-cityto,
             wa_spfli-deptime,
             wa_spfli-arrtime.

    HIDE: wa_spfli-carrid, wa_spfli-connid.

  ENDLOOP.

ENDFORM.                               " DISPLAY_CONNECTIONS

*&---------------------------------------------------------------------*
*&      Form  READ_FLIGHTS
*&---------------------------------------------------------------------*
FORM read_flights.

  SELECT * FROM sflight INTO TABLE it_sflight
             WHERE carrid = wa_spfli-carrid
               AND connid = wa_spfli-connid.

ENDFORM.                               " READ_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_FLIGHTS
*&---------------------------------------------------------------------*
FORM display_flights.

  LOOP AT it_sflight INTO wa_sflight.

    WRITE: / wa_sflight-carrid,
             wa_sflight-connid,
             wa_sflight-fldate,
             wa_sflight-price CURRENCY wa_sflight-currency,
             wa_sflight-currency,
             wa_sflight-seatsmax,
             wa_sflight-seatsocc.

  ENDLOOP.

ENDFORM.                               " DISPLAY_FLIGHTS


