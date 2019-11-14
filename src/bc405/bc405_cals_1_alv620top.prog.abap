*&---------------------------------------------------------------------*
*& Include BC405_CALT_1TOP
*&
*&---------------------------------------------------------------------*

REPORT  sapbc405_calt_1.
DATA: wa_spfli TYPE spfli,
      it_spfli TYPE TABLE OF spfli,
      ok_code LIKE sy-ucomm.

DATA: alv  TYPE REF TO cl_gui_alv_grid,
      cont TYPE REF TO cl_gui_custom_container.

DATA: wa_layout TYPE lvc_s_layo.

SELECT-OPTIONS: so_car FOR wa_spfli-carrid,
                so_con FOR wa_spfli-connid.
