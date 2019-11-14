*&---------------------------------------------------------------------*
*& Report  SAPBC405_GDAD_FOR_ALL_ENTRIES                               *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*


INCLUDE bc405_gdad_for_all_entriestop.
INCLUDE bc405_gdad_for_all_entriesf01.


START-OF-SELECTION.
  SELECT carrid connid cityfrom airpfrom cityto airpto deptime arrtime
   INTO TABLE itab_spfli
    FROM spfli
     WHERE cityfrom IN so_cityf
     AND   cityto   IN so_cityt.

* Check, if at least one dataset is found
  DESCRIBE TABLE itab_spfli LINES itab_lines.
  IF itab_lines < 1. EXIT. ENDIF.


* Delete Duplicates
  SORT itab_spfli.
  DELETE ADJACENT DUPLICATES FROM itab_spfli.

  SELECT carrid connid fldate seatsmax seatsocc
   INTO TABLE itab_sflight
    FROM sflight
     FOR ALL ENTRIES IN itab_spfli
      WHERE carrid = itab_spfli-carrid
      AND   connid = itab_spfli-connid.

  PERFORM data_output.
