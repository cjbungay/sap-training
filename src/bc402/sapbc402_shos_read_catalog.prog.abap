*&---------------------------------------------------------------------*
*& Report  SAPBC402_SHOS_READ_CATALOG
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  sapbc402_shos_read_catalog.

*----------------------------------------------------------------------*
DATA:
    gr_handle    TYPE REF TO   cl_bc402_shobs_area,
    gt_flights   TYPE          bc402_t_sdynconn,
    gs_flights   LIKE LINE OF  gt_flights,

    gv_startdate TYPE sydatum,
    gv_enddate   TYPE sydatum,

    gr_salv      TYPE REF TO cl_salv_table.

*----------------------------------------------------------------------*
PARAMETERS:
    pa_from      TYPE spfli-cityfrom,
    pa_to        TYPE spfli-cityto.

SELECT-OPTIONS:
    so_date      FOR sy-datum NO-EXTENSION.

*----------------------------------------------------------------------*
AT SELECTION-SCREEN.

  READ TABLE so_date INDEX 1.
  IF so_date IS INITIAL.
    so_date-low = sy-datum.
    so_date-high = sy-datum + 365.
  ENDIF.
  gv_startdate = sy-datum.
  gv_enddate   = sy-datum + 365.

  IF so_date-low > sy-datum.
    gv_startdate = sy-datum.
  ENDIF.
  IF so_date-high < gv_enddate.
    gv_enddate = so_date-high.
  ENDIF.

*----------------------------------------------------------------------*
START-OF-SELECTION.

  TRY.
      gr_handle = cl_bc402_shobs_area=>attach_for_read( ).

    CATCH cx_shm_inconsistent .
    CATCH cx_shm_no_active_version .
    CATCH cx_shm_read_lock_active .
    CATCH cx_shm_exclusive_lock_active .
    CATCH cx_shm_parameter_error .
    CATCH cx_shm_change_lock_active .
  ENDTRY.

  gr_handle->root->gr_catalog->get_flights(
    EXPORTING
      iv_from_city = pa_from
      iv_to_city   = pa_to
      iv_earliest  = gv_startdate
      iv_latest    = gv_enddate
    IMPORTING
      et_flights   = gt_flights
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
      t_table        = gt_flights
         ).
* CATCH CX_SALV_MSG .
*ENDTRY.
  gr_salv->display( ).
