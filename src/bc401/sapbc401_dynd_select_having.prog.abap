*&---------------------------------------------------------------------*
*& Report  SAPBC401_DYND_SELECT_HAVING                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Using aggregational functions SELECT and HAVING clause must be      *
*& programmed in accordance to each other, here done dynamically.      *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc401_dynd_select_having           .

DATA wa_sflight TYPE sflight.

PARAMETERS:
  p_max TYPE c RADIOBUTTON GROUP aggr,
  p_sum TYPE c RADIOBUTTON GROUP aggr.

DATA:
  select_clause TYPE string,
  having_clause LIKE select_clause.


START-OF-SELECTION.
  IF p_max = 'X'.
    MOVE 'carrid MAX( seatsocc )' TO select_clause.
    MOVE 'MAX( seatsocc ) > 200' TO having_clause.
    WRITE: / 'Maximum of all occupied seats of all carriers'(max)
              COLOR COL_HEADING.
  ELSE.
    MOVE 'carrid SUM( seatsocc )' TO select_clause.
    MOVE 'SUM( seatsocc ) > 1000' TO having_clause.
   WRITE: / 'Summe aller belegten Plätze aller Fluggesellschaften'(sum)
             COLOR COL_HEADING.
  ENDIF.

  SELECT (select_clause)
         FROM sflight
         INTO (wa_sflight-carrid, wa_sflight-seatsocc)
         GROUP BY carrid
         HAVING (having_clause).
    WRITE: /
      wa_sflight-carrid,
      wa_sflight-seatsocc.
  ENDSELECT.
