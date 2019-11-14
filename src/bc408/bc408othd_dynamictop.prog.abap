*&---------------------------------------------------------------------*
*& Include BC408ALV_DYNAMICTOP                               Report SAP*
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT   SAPBC408ALV_DYNAMIC                                         .

TABLES dd02l.

* OK code handling
DATA: ok_code LIKE sy-ucomm.


* CONTROLS
DATA: g_custom_container TYPE REF TO cl_gui_custom_container,
      alv_grid TYPE REF TO cl_gui_alv_grid.

* ALV specific
DATA:
  wa_layout TYPE lvc_s_layo,
  it_fieldcat TYPE lvc_t_fcat.

* dynamic data representation
DATA: d_ref_itab TYPE REF TO data.
FIELD-SYMBOLS:
  <fs_src_itab> TYPE STANDARD TABLE.

* Selection Screen
PARAMETERS: pa_tab TYPE dd02l-tabname OBLIGATORY MEMORY ID dtb.
PARAMETERS: pa_max TYPE rseumod-tbmaxsel OBLIGATORY DEFAULT 200.
