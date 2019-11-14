*&---------------------------------------------------------------------*
*& Report  SAPBC406SSCD_G_MULTIPLE_SS                               *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc406sscd_g_multiple_ss .

DATA: wa_spfli TYPE spfli,
      wa_sflight TYPE sflight,
      wa_sbook LIKE sbook.


PARAMETERS pa_carr LIKE wa_spfli-carrid DEFAULT 'LH'.
SELECT-OPTIONS so_apfr FOR wa_spfli-airpfrom NO INTERVALS.
SELECT-OPTIONS so_apto FOR wa_spfli-airpto NO INTERVALS.

SELECTION-SCREEN BEGIN OF SCREEN 102.
SELECT-OPTIONS so_date FOR wa_sflight-fldate.
SELECTION-SCREEN END OF SCREEN 102.

SELECTION-SCREEN BEGIN OF SCREEN 103.
SELECT-OPTIONS so_book FOR wa_sbook-bookid.
SELECT-OPTIONS so_bdat FOR wa_sbook-order_date.
PARAMETERS pa_canc TYPE sbook-cancelled AS CHECKBOX.
SELECTION-SCREEN END OF SCREEN 103.

pa_canc = 'X'.

AT SELECTION-SCREEN.
  CHECK sy-dynnr = 100.
  AUTHORITY-CHECK OBJECT 'S_CARRID'
           ID 'CARRID' FIELD pa_carr
           ID 'ACTVT' FIELD '03'.
  IF sy-subrc NE 0.
    MESSAGE e001(bc406) WITH pa_carr.
*   No authorization for airline carrier &
  ENDIF.

START-OF-SELECTION.

  CALL SELECTION-SCREEN 102 STARTING AT 20 5 ENDING AT 100 10.
  IF sy-subrc NE 0.
    EXIT.
  ENDIF.
  CALL SELECTION-SCREEN 103 STARTING AT 20 5 ENDING AT 100 10.
  IF sy-subrc NE 0.
    EXIT.
  ENDIF.
  SELECT * FROM spfli INTO wa_spfli
    WHERE carrid = pa_carr
      AND airpfrom IN so_apfr
      AND airpto IN  so_apto.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE: / wa_spfli-carrid,
             wa_spfli-connid,
             wa_spfli-cityfrom,
             wa_spfli-cityto,
             wa_spfli-deptime,
             wa_spfli-arrtime,
             AT sy-linsz space.
    ULINE.
    SELECT * FROM sflight INTO wa_sflight
      WHERE carrid = pa_carr
        AND connid = wa_spfli-connid
        AND fldate IN so_date.
      FORMAT COLOR COL_HEADING INTENSIFIED OFF.
      WRITE: /10 wa_sflight-fldate,
                 wa_sflight-planetype,
                 wa_sflight-seatsmax,
                 wa_sflight-seatsocc,
                 AT sy-linsz space.
      ULINE.
      SELECT * FROM sbook INTO wa_sbook
        WHERE carrid = wa_sflight-carrid
          AND connid = wa_sflight-connid
          AND fldate = wa_sflight-fldate
          AND bookid IN so_book
          AND order_date IN so_bdat
          AND ( cancelled = space OR  cancelled = pa_canc ) .
        FORMAT COLOR COL_NORMAL.
        WRITE: /20 wa_sbook-bookid ,
                   wa_sbook-customid,
                   wa_sbook-class,
                   wa_sbook-order_date,
                   wa_sbook-cancelled,
                   AT sy-linsz space.
      ENDSELECT.
    ENDSELECT.
  ENDSELECT.
