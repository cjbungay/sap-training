*&---------------------------------------------------------------------*
*& Report  SAPBC406SSCD_G_TABSTRIP_ON_SS                               *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  SAPBC406SSCD_G_TABSTRIP_ON_SS .

DATA: wa_spfli TYPE spfli,
      wa_sflight TYPE sflight,
      wa_sbook LIKE sbook.


SELECTION-SCREEN BEGIN OF SCREEN 101 AS SUBSCREEN.
  SELECT-OPTIONS so_carr FOR wa_spfli-carrid DEFAULT 'LH'.
  SELECT-OPTIONS so_apfr FOR wa_spfli-airpfrom NO INTERVALS.
  SELECT-OPTIONS so_apto FOR wa_spfli-airpto NO INTERVALS.
SELECTION-SCREEN END OF SCREEN 101.

SELECTION-SCREEN BEGIN OF SCREEN 102 AS SUBSCREEN.
  SELECT-OPTIONS so_date FOR wa_sflight-fldate.
SELECTION-SCREEN END OF SCREEN 102.

SELECTION-SCREEN BEGIN OF SCREEN 103 AS SUBSCREEN.
  SELECT-OPTIONS so_book FOR wa_sbook-bookid.
  SELECT-OPTIONS so_bdat FOR wa_sbook-order_date.
  PARAMETERS pa_canc TYPE sbook-cancelled AS CHECKBOX.
SELECTION-SCREEN END OF SCREEN 103.

SELECTION-SCREEN BEGIN OF TABBED BLOCK blockname FOR 5 LINES.
  SELECTION-SCREEN TAB (10) tabname1 USER-COMMAND ucomm1
    DEFAULT SCREEN 101.
  SELECTION-SCREEN TAB (10) tabname2 USER-COMMAND ucomm2
    DEFAULT SCREEN 102.
  SELECTION-SCREEN TAB (10) tabname3 USER-COMMAND ucomm3
    DEFAULT SCREEN 103.
SELECTION-SCREEN END OF BLOCK blockname.

INITIALIZATION.
  tabname1 = text-001.                 "TEXT-001 DE: Verbindung
  tabname2 = text-002.                 "TEXT-002 DE: Flug
  tabname3 = text-003.                 "TEXT-003 DE: Buchung
  pa_canc = 'X'.

at selection-screen.
  case sy-ucomm.
  when 'UCOMM1'.
  endcase.
START-OF-SELECTION.
  SELECT * FROM spfli INTO wa_spfli
    WHERE carrid IN so_carr
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
      WHERE carrid = wa_spfli-carrid
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
