*&---------------------------------------------------------------------*
*& Report  SAPBC402_RUNS_EDITOR                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Template program for exercise 2 of unit data objects, types and     *
*& commands of classroom training BC402.                               *
*&                                                                     *
*& This template outputs a dummy text on a list.                       *
*& It contains a list header that can be used for the exercise.        *
*&---------------------------------------------------------------------*

REPORT  sapbc402_runs_editor.

*----------------------------------------------------------------------*
*TYPES:
*  BEGIN OF ty_s_flight_c,
*    mandt(3)       TYPE c,
*    carrid(3)      TYPE c,
*    connid(4)      TYPE n,
*    fldate(8)      TYPE n,
*    price(20)      TYPE c,
*    currency(5)    TYPE c,
*    planetype(10)  TYPE c,
*    seatsmax(10)   TYPE n,
*    seatsocc(10)   TYPE n,
*    paymentsum(22) TYPE c,
*    seatsmax_b(10) TYPE n,
*    seatsocc_b(10) TYPE n,
*    seatsmax_f(10) TYPE n,
*    seatsocc_f(10) TYPE n,
*  END OF ty_s_flight_c
*  .
*----------------------------------------------------------------------*


WRITE: / text-001.    " <-- 'Template with list header.'
