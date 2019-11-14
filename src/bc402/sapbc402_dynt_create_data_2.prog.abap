*&---------------------------------------------------------------------*
*& Report  SAPBC402_DYNTCREATE_DATA_2
*&
*&---------------------------------------------------------------------*
*&  This program works similar to the Data Browser.
*&  Selection-Screen for a table name.
*&  Dynamic SQL Statement to read the data from the table
*&  Use ALV to display the data
*&
*&---------------------------------------------------------------------*

REPORT  sapbc402_dynt_create_data_2.

*----------------------------------------------------------------------*
* Global Variables
DATA:
    gr_alv   TYPE REF TO cl_salv_table.

*----------------------------------------------------------------------*
* Field symbols...

*----------------------------------------------------------------------*
* Selection-screen
PARAMETERS:
    pa_tab TYPE dd02l-tabname DEFAULT 'SPFLI'.

*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*



*----------------------------------------------------------------------*
* Output using the new simple ALV
*  TRY.
*    cl_salv_table=>factory(
**  EXPORTING
**    LIST_DISPLAY   = IF_SALV_C_BOOL_SAP=>FALSE
**    R_CONTAINER    = R_CONTAINER
**    CONTAINER_NAME = CONTAINER_NAME
*      IMPORTING
*        r_salv_table   = gr_alv
*      CHANGING
*        t_table        =
*           ).
** CATCH CX_SALV_MSG .
*  ENDTRY.
*
*  gr_alv->display( ).
*----------------------------------------------------------------------*
