*&---------------------------------------------------------------------*
*& Report  SAPBC401_SPCS_MAIN_A                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&    Work with singleton
*&---------------------------------------------------------------------*

REPORT  sapbc401_spcs_main_a.

DATA: r_single TYPE REF TO cl_singleton.


START-OF-SELECTION.
*########################

  r_single = cl_singleton=>get_singleton( ).
