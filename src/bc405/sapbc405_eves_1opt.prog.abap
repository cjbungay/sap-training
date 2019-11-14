*&------------------------------------------
*& Report  SAPBC405_EVES_1OPT
*&
*&------------------------------------------

REPORT  sapbc405_eves_1opt.
DATA: it_spfli TYPE TABLE OF spfli,
      wa_spfli LIKE LINE OF it_spfli.

DATA: gr_alv TYPE REF TO cl_salv_table,
      gr_functions
        TYPE REF TO cl_salv_functions_list.

SELECT-OPTIONS: so_car FOR wa_spfli-carrid.

START-OF-SELECTION.
* select data in internal table

  SELECT        * FROM  spfli
    INTO TABLE it_spfli
         WHERE  carrid IN so_car.

* create the ALV object
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = gr_alv
    CHANGING
      t_table        = it_spfli
         ).

* set default set of generic functions
  gr_functions = gr_alv->get_functions( ).
  gr_functions->set_default( ).

* display it!
  gr_alv->display( ).
