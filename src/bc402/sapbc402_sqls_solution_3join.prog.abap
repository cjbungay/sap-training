*&---------------------------------------------------------------------*
*& Report  SAPBC402_SQLS_SOLUTION_3JOIN                                *
*&---------------------------------------------------------------------*
*& Nested Selects / Joins                                              *
*& SFLIGHT / SBOOK / SCUSTOM                                           *
*&---------------------------------------------------------------------*
REPORT  sapbc402_sqls_solution_3join.

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
  PERFORM nested_select_better.                  "better?
  PERFORM itab_complete.                         "and better?
  PERFORM itab_ondemand.                         "even better?
  PERFORM itab_ondemand2.                        "maybe even better?
  PERFORM join3.                                 "the best?
*&---------------------------------------------------------------------*
*       FORM nested_select_bad
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
*    WRITE: / rec-carrid, rec-connid, rec-fldate, rec-bookid,
*             rec-seatsmax, rec-seatsocc, rec-customid, rec-name.
  ENDSELECT.
*  WRITE: / ' counter = ', counter.
  GET RUN TIME FIELD t2.
  t2 = t2 - t1.
  ULINE. WRITE: / 'runtime (SBOOK/SFLIGHT)', 40 '=', t2.
ENDFORM.                    "nested_select_bad
*&---------------------------------------------------------------------*
*&      Form  nested_select_better
*&---------------------------------------------------------------------*
*       Change order of the nested selects
*----------------------------------------------------------------------*
FORM nested_select_better .
  GET RUN TIME FIELD t1.
  SELECT carrid connid fldate seatsmax seatsocc FROM sflight
           INTO (rec-carrid, rec-connid, rec-fldate,
                 rec-seatsmax, rec-seatsocc)
           WHERE carrid = pacarrid
           AND connid IN paconnid
           AND fldate IN pafldate
           ORDER BY carrid connid fldate.
    SELECT bookid customid FROM sbook
               INTO (rec-bookid, rec-customid)
               WHERE carrid = rec-carrid
               AND   connid = rec-connid
               AND   fldate = rec-fldate.
      SELECT SINGLE name FROM scustom
                 INTO rec-name
                 WHERE id = rec-customid.
*    WRITE: / rec-carrid, rec-connid, rec-fldate, rec-bookid,
*             rec-seatsmax, rec-seatsocc, rec-customid, rec-name.
    ENDSELECT.
  ENDSELECT.
  GET RUN TIME FIELD t2.
  t2 = t2 - t1.
  ULINE. WRITE: / 'runtime (SFLIGHT/SBOOK)', 40 '=', t2.
ENDFORM.                    " nested_select_better
*&---------------------------------------------------------------------*
*&      Form  join3
*&---------------------------------------------------------------------*
*       Join for all three tables
*----------------------------------------------------------------------*
FORM join3 .
  GET RUN TIME FIELD t1.
  SELECT sflight~carrid sflight~connid sflight~fldate
         sflight~seatsmax sflight~seatsocc sbook~bookid
         sbook~customid scustom~name
         INTO rec
      FROM sflight INNER JOIN sbook
        ON sflight~carrid = sbook~carrid
        AND sflight~connid = sbook~connid
        AND sflight~fldate = sbook~fldate
          INNER JOIN scustom
          ON scustom~id = sbook~customid
        WHERE sflight~carrid = pacarrid
          AND sflight~connid IN paconnid
          AND sflight~fldate IN pafldate.
*   WRITE: / rec-carrid, rec-connid, rec-fldate, rec-bookid,
*            rec-seatsmax, rec-seatsocc, rec-customid, rec-name.
  ENDSELECT.
  GET RUN TIME FIELD t2.
  t2 = t2 - t1.
  ULINE. WRITE: / 'runtime (Join)', 40 '=', t2.
ENDFORM.                                                    " join3
*&---------------------------------------------------------------------*
*&      Form  itab_ondemand
*&---------------------------------------------------------------------*
*       select records from SCUSTOM when needed
*       and buffer them in internal table
*----------------------------------------------------------------------*
FORM itab_ondemand.
  DATA: itab TYPE HASHED TABLE OF scustom WITH UNIQUE KEY id.
  DATA: wa TYPE scustom.
  GET RUN TIME FIELD t1.
  SELECT carrid connid fldate seatsmax seatsocc FROM sflight
           INTO (rec-carrid, rec-connid, rec-fldate,
                 rec-seatsmax, rec-seatsocc)
           WHERE carrid = pacarrid
           AND connid IN paconnid
           AND fldate IN pafldate
           ORDER BY carrid connid fldate.
    SELECT bookid customid FROM sbook
               INTO (rec-bookid, rec-customid)
               WHERE carrid = rec-carrid
               AND   connid = rec-connid
               AND   fldate = rec-fldate.
      READ TABLE itab INTO wa
                 WITH TABLE KEY id = rec-customid
                 TRANSPORTING name.
      IF sy-subrc <> 0.
        SELECT SINGLE id name FROM scustom INTO
                     CORRESPONDING FIELDS OF wa
                        WHERE id = rec-customid.
        INSERT wa INTO TABLE itab.
      ENDIF.
      rec-name = wa-name.
*    WRITE: / rec-carrid, rec-connid, rec-fldate, rec-bookid,
*             rec-seatsmax, rec-seatsocc, rec-customid, rec-name.
    ENDSELECT.
  ENDSELECT.
  GET RUN TIME FIELD t2.
  t2 = t2 - t1.
  ULINE. WRITE: /'runtime (buffer on demand)', 40 '=', t2.
ENDFORM.                    " itab_ondemand
*&---------------------------------------------------------------------*
*&      Form  itab_complete
*&---------------------------------------------------------------------*
*       buffer SCUSTOM completely in internal table
*----------------------------------------------------------------------*
FORM itab_complete.
  DATA: itab TYPE HASHED TABLE OF scustom WITH UNIQUE KEY id.
  DATA: wa TYPE scustom.
  GET RUN TIME FIELD t1.
  SELECT id name FROM scustom INTO CORRESPONDING FIELDS OF TABLE itab.
  SELECT carrid connid fldate seatsmax seatsocc FROM sflight
           INTO (rec-carrid, rec-connid, rec-fldate,
                 rec-seatsmax, rec-seatsocc)
           WHERE carrid = pacarrid
           AND connid IN paconnid
           AND fldate IN pafldate
           ORDER BY carrid connid fldate.
    SELECT bookid customid FROM sbook
               INTO (rec-bookid, rec-customid)
               WHERE carrid = rec-carrid
               AND   connid = rec-connid
               AND   fldate = rec-fldate.
      READ TABLE itab INTO wa
                 WITH TABLE KEY id = rec-customid
                 TRANSPORTING name.
      rec-name = wa-name.
*    WRITE: / rec-carrid, rec-connid, rec-fldate, rec-bookid,
*             rec-seatsmax, rec-seatsocc, rec-customid, rec-name.
    ENDSELECT.
  ENDSELECT.
  GET RUN TIME FIELD t2.
  t2 = t2 - t1.
  ULINE. WRITE: /'runtime (buffer complete)', 40 '=', t2.
ENDFORM.                    " itab_complete
*&---------------------------------------------------------------------*
*&      Form  itab_ondemand2
*&---------------------------------------------------------------------*
*       select records from SCUSTOM when needed
*       and buffer them in internal table (sorted)
*----------------------------------------------------------------------*
FORM itab_ondemand2.
  DATA: itab TYPE SORTED TABLE OF scustom WITH UNIQUE KEY id.
  DATA: wa TYPE scustom.
  GET RUN TIME FIELD t1.
  SELECT carrid connid fldate seatsmax seatsocc FROM sflight
           INTO (rec-carrid, rec-connid, rec-fldate,
                 rec-seatsmax, rec-seatsocc)
           WHERE carrid = pacarrid
           AND connid IN paconnid
           AND fldate IN pafldate
           ORDER BY carrid connid fldate.
    SELECT bookid customid FROM sbook
               INTO (rec-bookid, rec-customid)
               WHERE carrid = rec-carrid
               AND   connid = rec-connid
               AND   fldate = rec-fldate.
      READ TABLE itab INTO wa
                 WITH TABLE KEY id = rec-customid
                 TRANSPORTING name.
      IF sy-subrc <> 0.
        SELECT SINGLE id name FROM scustom INTO
                     CORRESPONDING FIELDS OF wa
                        WHERE id = rec-customid.
        INSERT wa INTO itab INDEX sy-tabix. "<--index set by READ TABLE
      ENDIF.
      rec-name = wa-name.
*    WRITE: / rec-carrid, rec-connid, rec-fldate, rec-bookid,
*             rec-seatsmax, rec-seatsocc, rec-customid, rec-name.
    ENDSELECT.
  ENDSELECT.
  GET RUN TIME FIELD t2.
  t2 = t2 - t1.
  ULINE. WRITE: /'runtime (buffer on demand / sorted)', 40 '=', t2.
ENDFORM.                    " itab_ondemand
