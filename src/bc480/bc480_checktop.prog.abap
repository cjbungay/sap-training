*&---------------------------------------------------------------------*
*&  Include           BC480_CHECKTOP
*&---------------------------------------------------------------------*
REPORT  sapbc480_check MESSAGE-ID bc480.

TYPE-POOLS: col.

* work area for ALV data and color information
TYPES:
  BEGIN OF ty_alv_layout,
    comment TYPE text20,
    light,  "graphical indicator for booking status
    color(4), "for line color
    t_field_colors  TYPE lvc_t_scol, "for cell highlighting
  END OF ty_alv_layout,

  ty_para TYPE TABLE OF stxspara.

DATA:
  number                TYPE n,
  len1                  TYPE i,
  len2                  TYPE i,
  xml                   TYPE xstring,
  master_lang           TYPE tadir-masterlang,
  ok_code               TYPE sy-ucomm,

* internal tables with fields as they come from the student's interface
  gt_import_parameters  TYPE tfpiopar,
  gt_export_parameters  TYPE tfpiopar,
  gt_table_parameters   TYPE tfpiopar,
  gt_global_data        TYPE tfpgdata,
  gt_reference_fields   TYPE tfpref,

  gs_import_parameters  TYPE sfpiopar,
  gs_export_parameters  TYPE sfpiopar,
  gs_table_parameters   TYPE sfpiopar,
  gs_global_data        TYPE sfpgdata,
  gs_reference_fields   TYPE sfpref,

* internal tables with fields as they come from the template interface
  gt_import_correct     TYPE tfpiopar,
  gt_export_correct     TYPE tfpiopar,
  gt_table_correct      TYPE tfpiopar,
  gt_global_correct     TYPE tfpgdata,
  gt_reference_correct  TYPE tfpref,

* internal tables with fields as they come from the student's style
  gt_paragraphs TYPE ty_para,

* internal tables with fields as they come from the template style
  gt_paragraphs_correct TYPE ty_para,

  cont_import    TYPE REF TO cl_gui_custom_container,
  cont_export    TYPE REF TO cl_gui_custom_container,
  cont_global    TYPE REF TO cl_gui_custom_container,
  cont_reference TYPE REF TO cl_gui_custom_container,
  container(5)   VALUE 'CONT0',

  alv_import     TYPE REF TO cl_gui_alv_grid,
  alv_export     TYPE REF TO cl_gui_alv_grid,
  alv_global     TYPE REF TO cl_gui_alv_grid,
  alv_reference  TYPE REF TO cl_gui_alv_grid,

  gs_layout TYPE lvc_s_layo,

* field catalog fo ALV
  gt_field_cat TYPE lvc_t_fcat,
  gs_field_cat LIKE LINE OF gt_field_cat.


DATA:
  BEGIN OF gs_alv_import.
INCLUDE TYPE sfpiopar.
INCLUDE TYPE ty_alv_layout.
DATA: END OF gs_alv_import,
gt_alv_import LIKE TABLE OF gs_alv_import,

gs_alv_export LIKE gs_alv_import,
gt_alv_export LIKE gt_alv_import,

BEGIN OF gs_alv_global.
INCLUDE TYPE sfpgdata.
INCLUDE TYPE ty_alv_layout.
DATA: END OF gs_alv_global,
gt_alv_global LIKE TABLE OF gs_alv_global,

BEGIN OF gs_alv_reference.
INCLUDE TYPE sfpref.
INCLUDE TYPE ty_alv_layout.
DATA: END OF gs_alv_reference,
gt_alv_reference LIKE TABLE OF gs_alv_reference.


************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK choice.
PARAMETERS:
  rad_if  RADIOBUTTON GROUP typ  USER-COMMAND rad DEFAULT 'X',
  rad_con RADIOBUTTON GROUP typ,
  rad_styl RADIOBUTTON GROUP typ.

SELECTION-SCREEN SKIP.

PARAMETERS:
  pa_if  TYPE fpinterface-name
    MATCHCODE OBJECT hfpwbinterface
    MODIF ID if
    MEMORY ID fpwbinterface,
  pa_ifori TYPE fpinterface-name
    MATCHCODE OBJECT hfpwbinterface
    MODIF ID if
    DEFAULT 'BC480',
  pa_con TYPE fpcontext-name
    MATCHCODE OBJECT hfpwbform
    MODIF ID con
    MEMORY ID fpwbform,
  pa_styl TYPE ssfscreens-sname
    MATCHCODE OBJECT sh_stxsadm
    MEMORY ID ssfstyle
    MODIF ID sty.


SELECTION-SCREEN END OF BLOCK choice.
