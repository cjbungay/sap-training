*&---------------------------------------------------------------------*
*&   Data selection using an Inner Join from the hierarchical tables   *
*&                 scarr (alias a)                                     *
*&                 spfli (alias b)                                     *
*&                 sflight (alias c)                                   *
*&---------------------------------------------------------------------*

REPORT sapbc405_gdad_inner_join_3tab.

* work area for internal table
DATA: BEGIN OF gs_join,
  carrid   TYPE scarr-carrid,
  carrname TYPE scarr-carrname,
  connid   TYPE spfli-connid,
  cityfrom TYPE spfli-cityfrom,
  cityto   TYPE spfli-cityto,
  fldate   TYPE sflight-fldate,
  seatsmax TYPE sflight-seatsmax,
  seatsocc TYPE sflight-seatsocc,
END OF gs_join,
* internal table
gt_join LIKE TABLE OF gs_join.

DATA: go_alv TYPE REF TO cl_salv_table.

START-OF-SELECTION.
  SELECT c~carrid c~carrname
   p~connid p~cityfrom p~cityto
   f~fldate f~seatsmax f~seatsocc
   INTO  TABLE gt_join
   FROM ( scarr AS c INNER JOIN spfli AS p
   ON  c~carrid = p~carrid )
   INNER JOIN sflight AS f
   ON  f~carrid = p~carrid
   AND f~connid = p~connid
   WHERE seatsocc < f~seatsmax
   ORDER BY c~carrid p~connid f~fldate.

* create ALV
  cl_salv_table=>factory(
  IMPORTING
    r_salv_table   = go_alv
  CHANGING
    t_table        = gt_join
    ).

  go_alv->display( ).
