*&---------------------------------------------------------------------*
*&  Include           MBC_TAW12_CSS_BOOKINGS_TAW                       *
*&---------------------------------------------------------------------*

DATA:
 pb_specials(20)    TYPE c,
 gr_badi_reference  TYPE REF TO if_ex_bc_taw12_cs,
 gv_exitname(20)    TYPE c VALUE 'BC_TAW12_CS',
 gv_dynnr           TYPE sydynnr,
 gv_program         TYPE syrepid.
