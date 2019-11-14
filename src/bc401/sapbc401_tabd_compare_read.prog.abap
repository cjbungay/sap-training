*&---------------------------------------------------------------------*
*& Report  SAPBC401_TABD_COMPARE_READ                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Comparison of runtimes of read statements for nested internal       *
*& tables. Comparison is between                                       *
*& - READ ... INTO                                                     *
*& - READ ... ASSIGNING                                                *
*&                                                                     *
*& Create a definite table entry with the help of constant data.       *
*& Via a radio button group on the selection screen you can determine  *
*& at which position to insert the line to be read later on.           *
*&---------------------------------------------------------------------*

REPORT  sapbc401_tabd_compare_read.

TYPES:
* types for the inner table
  BEGIN OF inner_line_type,
    fldate   TYPE sflight-fldate,
    seatsmax TYPE sflight-seatsmax,
    seatsocc TYPE sflight-seatsocc,
  END OF inner_line_type,

  inner_table_type TYPE STANDARD TABLE OF inner_line_type
    WITH NON-UNIQUE KEY fldate,

* types for the outer table
  BEGIN OF outer_line_type,
    carrid   TYPE spfli-carrid,
    connid   TYPE spfli-connid,
    airpto   TYPE spfli-airpto,
    airpfrom TYPE spfli-airpfrom,
    capacity TYPE inner_table_type,
  END OF outer_line_type,

  outer_table_type TYPE STANDARD TABLE OF outer_line_type
    WITH NON-UNIQUE KEY carrid connid.

DATA:
* data objects
  flight_info TYPE outer_table_type,
  runtime     TYPE i,
  tot_runtime TYPE i,
* auxiliary
  insert_mode         TYPE i. " 1=first line, 2=middle, 3=last line

CONSTANTS:
* "key" fields for data set to read
  c_carrid     TYPE s_carr_id  VALUE 'QQ ',
  c_connid     TYPE s_conn_id  VALUE '0500',
  c_airpfrom   TYPE s_fromairp VALUE 'XXX',
  c_airpto     TYPE s_toairp   VALUE 'YYY',
  c_fldate     TYPE s_date     VALUE '22220630',
  c_seatsmax   TYPE s_seatsmax VALUE 999,
  c_seatsocc   TYPE s_seatsocc VALUE 111,
* auxiliary
  c_selected TYPE c VALUE 'X'.

*********************************************************************
*                                                                   *
*    S E L E C T I O N    S C R E E N                               *
*                                                                   *
*********************************************************************
SELECTION-SCREEN BEGIN OF BLOCK test_frame WITH FRAME TITLE text-021.
PARAMETERS:
  pa TYPE i DEFAULT 500.               " number of repetitions
SELECTION-SCREEN END OF BLOCK test_frame.

SELECTION-SCREEN BEGIN OF BLOCK insert_row WITH FRAME TITLE text-020.
PARAMETERS:
  pa_a1 TYPE c RADIOBUTTON GROUP rad1, " insert as first line
  pa_a2 TYPE c RADIOBUTTON GROUP rad1, " insert in middle
  pa_a3 TYPE c RADIOBUTTON GROUP rad1. " insert as last  line
SELECTION-SCREEN END OF BLOCK insert_row.

AT SELECTION-SCREEN.
* set insert_mode: where to insert the read line
  CASE c_selected.
    WHEN pa_a1.
      insert_mode = 1.  " insert as first line in standard table
    WHEN pa_a2.
      insert_mode = 2.  " insert in the middle of standard table
    WHEN pa_a3.
      insert_mode = 3.  " insert as last line in standard table
  ENDCASE.

***********************************************************************
*                                                                     *
*  S T A R T    O F   M A I N   P R O G R A M                         *
*                                                                     *
***********************************************************************

START-OF-SELECTION.
* fill internal table
  PERFORM fill_table
    USING    insert_mode
    CHANGING flight_info.

  DO pa TIMES.
    PERFORM read_copy
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
    PERFORM read_assigning
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
*       --> p_mode  1: insert as first line
*                   2: insert in middle of p_itab
*                   3: insert as last line
*      <--> P_itab  text
*----------------------------------------------------------------------*
FORM fill_table
     USING    p_mode TYPE i
     CHANGING p_itab TYPE outer_table_type.

* local data
  DATA:
    wa_outer LIKE LINE OF p_itab,
    wa_inner TYPE inner_line_type,
    index1   TYPE sy-tabix,            " outter
    index2   TYPE sy-tabix,            " inner
    lines1   TYPE i,                   " outer
    lines2   TYPE i.                   " inner

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

  DESCRIBE TABLE p_itab LINES lines1.

  CASE p_mode.
    WHEN 1.
      index1 = 1.
    WHEN 2.
      index1 = lines1 DIV 2.
    WHEN 3.
      index1 = lines1 + 1.
  ENDCASE.

  READ TABLE p_itab INTO wa_outer INDEX index1.

  DESCRIBE TABLE wa_outer-capacity LINES lines2.
  CASE p_mode.
    WHEN 1.
      index2 = 1.
    WHEN 2.
      index2 = lines2 DIV 2.
    WHEN 3.
      index2 = lines2 + 1.
  ENDCASE.

  wa_inner-fldate   = c_fldate.
  wa_inner-seatsmax = c_seatsmax.
  wa_inner-seatsocc = c_seatsocc.

  INSERT wa_inner INTO wa_outer-capacity INDEX index2.

  wa_outer-carrid   = c_carrid.
  wa_outer-connid   = c_connid.
  wa_outer-airpfrom = c_airpfrom.
  wa_outer-airpto   = c_airpto.
  INSERT wa_outer INTO p_itab INDEX index1.

ENDFORM.                               " fill_table
*&---------------------------------------------------------------------*
*&      Form  read_assigning
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_ITAB  text
*      <--P_RUNTIME  text
*----------------------------------------------------------------------*
FORM read_assigning CHANGING p_itab    TYPE outer_table_type
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
  READ TABLE p_itab ASSIGNING <wa_outer>
    WITH TABLE KEY carrid = c_carrid connid = c_connid.
  <wa_outer>-carrid   = <wa_outer>-carrid.
  <wa_outer>-connid   = <wa_outer>-connid.
  <wa_outer>-airpfrom = <wa_outer>-airpfrom.
  <wa_outer>-airpto   = <wa_outer>-airpto.
  READ TABLE <wa_outer>-capacity ASSIGNING <wa_inner>
    WITH TABLE KEY fldate = c_fldate.
  <wa_inner>-fldate   = <wa_inner>-fldate.
  <wa_inner>-seatsmax = <wa_inner>-seatsmax.
  <wa_inner>-seatsocc = <wa_inner>-seatsocc.

  GET RUN TIME FIELD rt_stop.

  p_runtime = rt_stop - rt_start.

ENDFORM.                               " read_assigning

*&---------------------------------------------------------------------*
*&      Form  read_copy
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_ITAB     text
*      <--P_RUNTIME  text
*----------------------------------------------------------------------*
FORM read_copy CHANGING p_itab    TYPE outer_table_type
                        p_runtime TYPE i.

* local data
  DATA:
    rt_start TYPE i,
    rt_stop  TYPE i.

  DATA:
    wa_outer TYPE outer_line_type,
    wa_inner TYPE inner_line_type.

  GET RUN TIME FIELD rt_start.
* nested read
  READ TABLE p_itab INTO wa_outer
    WITH TABLE KEY carrid = c_carrid connid = c_connid.
  wa_outer-carrid   = wa_outer-carrid.
  wa_outer-connid   = wa_outer-connid.
  wa_outer-airpfrom = wa_outer-airpfrom.
  wa_outer-airpto   = wa_outer-airpto.
  READ TABLE wa_outer-capacity INTO wa_inner
    WITH TABLE KEY fldate = c_fldate.
  wa_inner-fldate   = wa_inner-fldate.
  wa_inner-seatsmax = wa_inner-seatsmax.
  wa_inner-seatsocc = wa_inner-seatsocc.
  MODIFY TABLE wa_outer-capacity FROM wa_inner.
  MODIFY TABLE p_itab FROM wa_outer.

  GET RUN TIME FIELD rt_stop.

  p_runtime = rt_stop - rt_start.

ENDFORM.                               " read_copy
