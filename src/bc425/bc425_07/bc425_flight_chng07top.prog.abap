*&---------------------------------------------------------------------*
*& Include          BC425_FLIGHT_CHNG07TOP                             *
*& Modulpool        SAPBC425D_FLIGHT_CHNG07##                          *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  sapbc425_flight_chng## MESSAGE-ID bc425.

CONSTANTS:
    c_true  VALUE 'X',
    c_false VALUE space.

TABLES:
    sflight07.

DATA:
    ok_code TYPE syucomm,
    save_ok TYPE syucomm,

    gr_badi_reference  TYPE REF TO if_ex_bc425_07flight2,

    gv_dynnr        TYPE sydynnr,
    gv_program      TYPE syrepid,

* Table of Function codes to be excluded (and work area)
    gs_excl_tab     TYPE          syucomm,
    gt_excl_tab      TYPE TABLE OF syucomm,

    gv_change_mode  TYPE c,          "Display mode

    gs_flight       TYPE sflight07,
    gs_flight_hlp   TYPE sflight07
    .
