*&---------------------------------------------------------------------*
*& Report  SAPBC402_SHOD_READER
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  sapbc402_shod_reader.

*----------------------------------------------------------------------*
DATA:
    gr_handle    TYPE REF TO   cl_bc402_shm_area,
    gt_spfli     TYPE          bc402_t_spfli,

    gr_salv      TYPE REF TO cl_salv_table.
*----------------------------------------------------------------------*
PARAMETERS:
    pa_car       TYPE spfli-carrid.

*----------------------------------------------------------------------*
START-OF-SELECTION.

  TRY.
      gr_handle = cl_bc402_shm_area=>attach_for_read( ).

    CATCH cx_shm_inconsistent .
    CATCH cx_shm_no_active_version .
    CATCH cx_shm_read_lock_active .
    CATCH cx_shm_exclusive_lock_active .
    CATCH cx_shm_parameter_error .
    CATCH cx_shm_change_lock_active .
  ENDTRY.

  gr_handle->root->gr_catalog->get_connections(
    EXPORTING
      iv_carrid      = pa_car
    IMPORTING
      et_connections = gt_spfli
         ).

  TRY.
      gr_handle->detach( ).
    CATCH cx_shm_wrong_handle .
    CATCH cx_shm_already_detached .
  ENDTRY.

*----------------------------------------------------------------------*
*TRY.
  cl_salv_table=>factory(
    EXPORTING
      list_display   = if_salv_c_bool_sap=>false
*    R_CONTAINER    =
*    CONTAINER_NAME =
    IMPORTING
      r_salv_table   = gr_salv
    CHANGING
      t_table        = gt_spfli
         ).
* CATCH CX_SALV_MSG .
*ENDTRY.
  gr_salv->display( ).
