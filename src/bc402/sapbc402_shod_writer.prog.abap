*&---------------------------------------------------------------------*
*& Report  SAPBC402_SHOD_WRITER
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  sapbc402_shod_writer.

*----------------------------------------------------------------------*
DATA:
    gr_handle    TYPE REF TO   cl_bc402_shm_area,
    gr_root      TYPE REF TO   cl_bc402_shm_root,
    gr_catalog   TYPE REF TO   cl_bc402_shm_catalog,

    gt_spfli     TYPE          bc402_t_spfli.

*----------------------------------------------------------------------*
START-OF-SELECTION.

*TRY.
  gr_handle = cl_bc402_shm_area=>attach_for_write(
*    CLIENT      =
*    INST_NAME   = CL_SHM_AREA=>DEFAULT_INSTANCE
*    ATTACH_MODE = CL_SHM_AREA=>ATTACH_MODE_DEFAULT
*    WAIT_TIME   = 0
         ).
* CATCH CX_SHM_EXCLUSIVE_LOCK_ACTIVE .
* CATCH CX_SHM_VERSION_LIMIT_EXCEEDED .
* CATCH CX_SHM_CHANGE_LOCK_ACTIVE .
* CATCH CX_SHM_PARAMETER_ERROR .
*ENDTRY.

  CREATE OBJECT gr_root       AREA HANDLE gr_handle.
  CREATE OBJECT gr_catalog    AREA HANDLE gr_handle.

  gr_root->gr_catalog = gr_catalog.

*  TRY.
  gr_handle->set_root( root = gr_root ).
*   CATCH CX_SHM_INITIAL_REFERENCE .
*   CATCH CX_SHM_WRONG_HANDLE .
*  ENDTRY.

  SELECT *
      FROM spfli
      INTO TABLE gt_spfli.

  gr_handle->root->gr_catalog->fill_catalog(
                                  it_catalog = gt_spfli ).


*TRY.
  gr_handle->detach_commit(
         ).
* CATCH CX_SHM_WRONG_HANDLE .
* CATCH CX_SHM_ALREADY_DETACHED .
* CATCH CX_SHM_COMPLETION_ERROR .
* CATCH CX_SHM_SECONDARY_COMMIT .
*ENDTRY.
