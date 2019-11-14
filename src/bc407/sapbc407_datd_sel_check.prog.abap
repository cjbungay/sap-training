*&---------------------------------------------------------------------*
*& Report  SAPBC407_DATD_SEL_CHECK                                     *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc407_datd_sel_check.

* Data objects
DATA: wa_sflight TYPE sflight.

* Selection screen
SELECT-OPTIONS: so_car FOR wa_sflight-carrid,
                so_fld FOR wa_sflight-fldate.

* Check what the user has entered
AT SELECTION-SCREEN.
  IF 'LH' IN so_car AND
     '20021224' IN so_fld.
    MESSAGE w013(bc407) WITH 'LH'.
  ENDIF.


START-OF-SELECTION.
* Data retrieval
  SELECT * FROM sflight INTO wa_sflight
     WHERE carrid IN so_car
       AND fldate IN so_fld.

    WRITE: / wa_sflight-carrid,
             wa_sflight-connid,
             wa_sflight-fldate,
             wa_sflight-seatsmax,
             wa_sflight-seatsocc.
  ENDSELECT.
