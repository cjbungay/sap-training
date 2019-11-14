*&---------------------------------------------------------------------*
*& Report  SAPBC406SAPBC406CALS_AIRLINE_LIST                           *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc406SAPBC406CALS_AIRLINE_LIST         .

DATA: wa_spfli TYPE spfli.
PARAMETERS: pa_car LIKE wa_spfli-carrid.
SELECT-OPTIONS: so_conn FOR wa_spfli-connid.


START-OF-SELECTION.
  SELECT * FROM spfli INTO wa_spfli
    WHERE carrid = pa_car AND connid IN so_conn.

    WRITE: / wa_spfli-carrid,
             wa_spfli-connid,
             wa_spfli-cityfrom,
             wa_spfli-cityto,
             wa_spfli-fltime,
             wa_spfli-deptime,
             wa_spfli-arrtime,
             wa_spfli-distance,
             wa_spfli-distid.
  ENDSELECT.
  SET TITLEBAR 'LIST'.
