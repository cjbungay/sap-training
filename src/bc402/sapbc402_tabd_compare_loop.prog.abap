*&---------------------------------------------------------------------*
*& Report  SAPBC402_TABD_COMPARE_LOOP                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Comparison of runtimes of nested loop statements for nested internal*
*& tables. Comparison is between                                       *
*& - LOOP ... INTO                                                     *
*& - LOOP ... ASSIGNING                                                *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc402_tabd_compare_loop.

TYPES:
* types for the inner table
  BEGIN OF inner_line_type,
    fldate   TYPE sflight-fldate,
    seatsmax TYPE sflight-seatsmax,
    seatsocc TYPE sflight-seatsocc,
  END OF inner_line_type,

  inner_table_type TYPE STANDARD TABLE OF inner_line_type
    WITH NON-UNIQUE DEFAULT KEY,

* types for the outer table
  BEGIN OF outer_line_type,
    carrid   TYPE spfli-carrid,
    connid   TYPE spfli-connid,
    airpto   TYPE spfli-airpto,
    airpfrom TYPE spfli-airpfrom,
    capacity TYPE inner_table_type,
  END OF outer_line_type,

  outer_table_type TYPE STANDARD TABLE OF outer_line_type
    WITH NON-UNIQUE DEFAULT KEY.

DATA:
* data objects
  flight_info TYPE outer_table_type,
  runtime     TYPE i,
  tot_runtime TYPE i.


PARAMETERS: pa TYPE i DEFAULT 1000.

START-OF-SELECTION.
* fill internal table
  PERFORM fill_table CHANGING flight_info.

  DO pa TIMES.
    PERFORM loop_copy
      CHANGING
        flight_info
        runtime.
    tot_runtime = tot_runtime + runtime.
  ENDDO.
  tot_runtime = tot_runtime / pa.
  WRITE: / text-020, tot_runtime.
* (020) EN: 'runtime with copy'
  CLEAR: tot_runtime.

  DO pa TIMES.
    PERFORM loop_assigning
      CHANGING
        flight_info
        runtime.
    tot_runtime = tot_runtime + runtime.
  ENDDO.
  tot_runtime = tot_runtime / pa.
  WRITE: / text-021, tot_runtime.
* (021) EN: 'runtime without copy'






*&---------------------------------------------------------------------*
*&      Form  fill_table
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_FLIGHT_INFO  text
*----------------------------------------------------------------------*
FORM fill_table CHANGING p_itab TYPE outer_table_type.
* local data
  DATA:
    wa_outer LIKE LINE OF p_itab,
    wa_inner TYPE inner_line_type.

  SELECT carrid connid airpfrom airpto
    FROM spfli
    INTO (wa_outer-carrid, wa_outer-connid,
          wa_outer-airpfrom, wa_outer-airpto)
*   where ...
    .
    SELECT fldate seatsmax seatsocc
      FROM sflight
      INTO CORRESPONDING FIELDS OF wa_inner
      WHERE carrid = wa_outer-carrid
      AND   connid = wa_outer-connid.

      INSERT wa_inner INTO TABLE wa_outer-capacity.

    ENDSELECT.

    INSERT wa_outer INTO TABLE p_itab.
    CLEAR wa_outer.

  ENDSELECT.
ENDFORM.                               " fill_table
*&---------------------------------------------------------------------*
*&      Form  loop_assigning
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_ITAB  text
*      <--P_RUNTIME  text
*----------------------------------------------------------------------*
FORM loop_assigning CHANGING p_itab    TYPE outer_table_type
                             p_runtime TYPE i.
* local data
  DATA:
    rt_start TYPE i,
    rt_stop  TYPE i.

  FIELD-SYMBOLS:
    <wa_outer> TYPE outer_line_type,
    <wa_inner> TYPE inner_line_type.

  GET RUN TIME FIELD rt_start.
* nested loop
  LOOP AT p_itab ASSIGNING <wa_outer>.
    <wa_outer>-carrid   = <wa_outer>-carrid.
    <wa_outer>-connid   = <wa_outer>-connid.
    <wa_outer>-airpfrom = <wa_outer>-airpfrom.
    <wa_outer>-airpto   = <wa_outer>-airpto.
    LOOP AT <wa_outer>-capacity ASSIGNING <wa_inner>.
      <wa_inner>-fldate   = <wa_inner>-fldate.
      <wa_inner>-seatsmax = <wa_inner>-seatsmax.
      <wa_inner>-seatsocc = <wa_inner>-seatsocc.
    ENDLOOP.
  ENDLOOP.

  GET RUN TIME FIELD rt_stop.

  p_runtime = rt_stop - rt_start.

ENDFORM.                               " loop_assigning

*&---------------------------------------------------------------------*
*&      Form  loop_copy
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_ITAB     text
*      <--P_RUNTIME  text
*----------------------------------------------------------------------*
FORM loop_copy CHANGING p_itab    TYPE outer_table_type
                        p_runtime TYPE i.

* local data
  DATA:
    rt_start TYPE i,
    rt_stop  TYPE i.

  DATA:
    wa_outer TYPE outer_line_type,
    wa_inner TYPE inner_line_type.

  GET RUN TIME FIELD rt_start.
* nested loop
  LOOP AT p_itab INTO wa_outer.
    wa_outer-carrid   = wa_outer-carrid.
    wa_outer-connid   = wa_outer-connid.
    wa_outer-airpfrom = wa_outer-airpfrom.
    wa_outer-airpto   = wa_outer-airpto.
    LOOP AT wa_outer-capacity INTO wa_inner.
      wa_inner-fldate   = wa_inner-fldate.
      wa_inner-seatsmax = wa_inner-seatsmax.
      wa_inner-seatsocc = wa_inner-seatsocc.
      MODIFY wa_outer-capacity FROM wa_inner.
    ENDLOOP.
    CLEAR wa_inner.
    MODIFY p_itab FROM wa_outer.
  ENDLOOP.

  GET RUN TIME FIELD rt_stop.

  p_runtime = rt_stop - rt_start.

ENDFORM.                               " loop_copy
