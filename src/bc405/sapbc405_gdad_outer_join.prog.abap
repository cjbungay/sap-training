*&---------------------------------------------------------------------*
*& Report  SAPBC405_GDAD_OUTER_JOIN                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  Data selection using an Outer Join from the hierarchical tables    *
*&                 scarr and spfli                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc405_gdad_outer_join.

* work area for internal table
DATA: BEGIN OF gs_join,
  carrid   TYPE scarr-carrid,
  carrname TYPE scarr-carrname,
  connid   TYPE spfli-connid,
  cityfrom TYPE spfli-cityfrom,
  cityto   TYPE spfli-cityto,
END OF gs_join,
* internal table
gt_join LIKE TABLE OF gs_join.

DATA: go_alv TYPE REF TO cl_salv_table.

START-OF-SELECTION.
  SELECT scarr~carrid carrname connid cityfrom cityto
  FROM  scarr LEFT OUTER JOIN spfli
  ON scarr~carrid = spfli~carrid
  INTO TABLE gt_join.

* create ALV
  cl_salv_table=>factory(
  IMPORTING
    r_salv_table   = go_alv
  CHANGING
    t_table        = gt_join
    ).

  go_alv->display( ).
