*&---------------------------------------------------------------------*
*& Include BC414D_UPDATE_ERRORTOP                                      *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  SAPBC414D_UPDATE_ERROR        .

DATA: FIRST_TIME,
      it_sflight   type table of sflight,
      wa_sflight   like line of it_sflight,
      ok_code      type sy-ucomm,
      save_ok_code like ok_code.

tables: sflight, spfli.

controls: sflight_tc type tableview using screen '100'.
