*&---------------------------------------------------------------------*
*& Report  SAPBC402_SQLT_TEMPLATE_3JOIN                                *
*&---------------------------------------------------------------------*
*& Nested Selects / Joins                                              *
*& SFLIGHT / SBOOK / SCUSTOM                                           *
*&---------------------------------------------------------------------*
REPORT  sapbc402_sqlt_template_3join.

TYPES: BEGIN OF ty_rec_sflight,
        carrid TYPE sflight-carrid,
        connid TYPE sflight-connid,
        fldate TYPE sflight-fldate,
        seatsmax TYPE sflight-seatsmax,
        seatsocc TYPE sflight-seatsocc,
        bookid   TYPE sbook-bookid,
        customid TYPE scustom-id,
        name TYPE scustom-name,
      END OF ty_rec_sflight.

DATA: rec TYPE ty_rec_sflight.

DATA: t1 TYPE f, t2 TYPE f.

PARAMETERS: pacarrid TYPE s_carr_id DEFAULT 'LH'.
SELECT-OPTIONS: paconnid FOR rec-connid
                DEFAULT '0400' TO '0402'.
SELECT-OPTIONS: pafldate FOR rec-fldate.


START-OF-SELECTION.
************************************************************************
  PERFORM nested_select_bad.                     "bad
*  PERFORM nested_select_better.                  "better ?
*  PERFORM itab_ondemand.                         "even better ?
*  PERFORM join3.                                 "the best ?
*&---------------------------------------------------------------------*
*       FORM nested_select_bad                                         *
*&---------------------------------------------------------------------*
FORM nested_select_bad.
  GET RUN TIME FIELD t1.
  SELECT carrid connid fldate bookid customid FROM sbook
           INTO (rec-carrid, rec-connid, rec-fldate, rec-bookid,
                             rec-customid)
           WHERE carrid = pacarrid
           AND connid IN paconnid
           AND fldate IN pafldate
           ORDER BY carrid connid fldate bookid.
    SELECT SINGLE seatsmax seatsocc FROM sflight
               INTO (rec-seatsmax, rec-seatsocc)
               WHERE carrid = rec-carrid
               AND   connid = rec-connid
               AND   fldate = rec-fldate.
    SELECT SINGLE name FROM scustom
               INTO rec-name
               WHERE id = rec-customid.
    WRITE: / rec-carrid, rec-connid, rec-fldate, rec-bookid,
             rec-seatsmax, rec-seatsocc, rec-customid, rec-name.
  ENDSELECT.
*  WRITE: / ' counter = ', counter.
  GET RUN TIME FIELD t2.
  t2 = t2 - t1.  ULINE.   WRITE: / 'runtime = ', t2.
ENDFORM.                    "nested_select_bad
*&---------------------------------------------------------------------*
*&      Form  nested_select_better
*&---------------------------------------------------------------------*
*       Change order of the nested selects
*----------------------------------------------------------------------*
FORM nested_select_better .
  GET RUN TIME FIELD t1.

* add coding here

  GET RUN TIME FIELD t2.
  t2 = t2 - t1.  ULINE.   WRITE: / 'runtime = ', t2.
ENDFORM.                    " nested_select_better
*&---------------------------------------------------------------------*
*&      Form  join3
*&---------------------------------------------------------------------*
*       Join for all three tables
*----------------------------------------------------------------------*
FORM join3 .
  GET RUN TIME FIELD t1.

* add coding here


  GET RUN TIME FIELD t2.
  t2 = t2 - t1.  ULINE.   WRITE: / 'runtime = ', t2.
ENDFORM.                                                    " join3
*&---------------------------------------------------------------------*
*&      Form  itab_ondemand
*&---------------------------------------------------------------------*
*       select records from SCUSTOM when needed
*       and buffer them in internal table
*----------------------------------------------------------------------*
FORM itab_ondemand .
  GET RUN TIME FIELD t1.

* add coding here

  GET RUN TIME FIELD t2.
  t2 = t2 - t1.  ULINE.   WRITE: / 'runtime = ', t2.
ENDFORM.                    " itab_ondemand
