*&---------------------------------------------------------------------*
*& Report  SAPBC402_DYND_RTTI_TABLE
*&
*&---------------------------------------------------------------------*
*&
*& This program uses RTTI to
*& provide information about an object's type.
*&
*&---------------------------------------------------------------------*
REPORT  sapbc402_dynd_rtti_table.

TYPE-POOLS:
    abap.

PARAMETERS:
  pa_type TYPE seoclass-clsname  DEFAULT 'CL_GUI_ALV_GRID'.

DATA:
  gr_container    TYPE REF TO cl_gui_custom_container,
  gr_alv          TYPE REF TO cl_gui_alv_grid,

  gr_type         TYPE REF TO cl_abap_typedescr,
  gr_objdescr     TYPE REF TO cl_abap_objectdescr,

  gt_methods      TYPE abap_methdescr_tab,
  gr_salv_disp    TYPE REF TO cl_salv_table,

  gr_error        TYPE REF TO cx_root,
  gstr_text       TYPE string
  .

*======================================================================*
START-OF-SELECTION.

*----------------------------------------------------------------------*
*first, create some objects

  CREATE OBJECT gr_container
    EXPORTING
      container_name              = 'HUGO'
      .
  CREATE OBJECT gr_alv
    EXPORTING
      i_parent          = gr_container
      .

*======================================================================*
  CALL METHOD cl_abap_typedescr=>describe_by_name
    EXPORTING
      p_name         = pa_type
    RECEIVING
      p_descr_ref    = gr_type
    EXCEPTIONS
      type_not_found = 1
      OTHERS         = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  TRY.
      gr_objdescr ?= gr_type.
    CATCH cx_sy_move_cast_error.
      MESSAGE e806(bc402).
  ENDTRY.
  gt_methods = gr_objdescr->methods.

  TRY.
      CALL METHOD cl_salv_table=>factory
*   EXPORTING
*     LIST_DISPLAY   = IF_SALV_C_BOOL_SAP=>TRUE
*     R_CONTAINER    =
*     CONTAINER_NAME =
        IMPORTING
          r_salv_table   = gr_salv_disp
        CHANGING
          t_table        = gt_methods
          .
    CATCH cx_salv_msg INTO gr_error.
      gstr_text = gr_error->if_message~get_text( ).
      MESSAGE gstr_text TYPE 'E'.
  ENDTRY.
  gr_salv_disp->display( ).

*
*----------------------------------------------------------------------*
*now, which information can you retrieve from an object?
*
*  CALL METHOD cl_abap_typedescr=>describe_by_object_ref
*    EXPORTING
*      p_object_ref         = gr_alv
*    RECEIVING
*      p_descr_ref          = gr_type
*    EXCEPTIONS
*      reference_is_initial = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.
*
*  gr_objdescr ?= gr_type.
*  gt_methods = gr_objdescr->methods.
*
*  TRY.
*      CALL METHOD cl_salv_table=>factory
**   EXPORTING
**     LIST_DISPLAY   = IF_SALV_C_BOOL_SAP=>FALSE
**     R_CONTAINER    =
**     CONTAINER_NAME =
*        IMPORTING
*          r_salv_table   = gr_salv_disp
*        CHANGING
*          t_table        = gt_methods
*          .
*    CATCH cx_salv_msg .
*  ENDTRY.
*  gr_salv_disp->display( ).
