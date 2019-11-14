FUNCTION BC402_GET_STEP_LIST_C.
*"--------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(I_NUMBER) TYPE  INT4
*"  EXPORTING
*"     REFERENCE(E_STEPLIST) TYPE  BC402_T_CONNSTEP
*"  EXCEPTIONS
*"      NOT_FOUND
*"      NO_DATA
*"--------------------------------------------------------------------

  FIELD-SYMBOLS <fs_connection> LIKE LINE OF gt_connection_list.
* any data in function group?

  IF LINES( gt_connection_list ) = 0.
    MESSAGE e173(bc402) RAISING no_data.
  ENDIF.

  READ TABLE gt_connection_list
             ASSIGNING <fs_connection>
             INDEX i_number.

  IF sy-subrc <> 0.
    MESSAGE e172(bc402) RAISING not_found.
  ELSE.
    e_steplist = <fs_connection>-steplist.
  ENDIF.

ENDFUNCTION.
