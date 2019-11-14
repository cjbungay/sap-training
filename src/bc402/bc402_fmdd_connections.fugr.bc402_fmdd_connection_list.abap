FUNCTION bc402_fmdd_connection_list.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(IP_START) TYPE  S_FROM_CIT
*"     VALUE(IP_DEST) TYPE  S_TO_CITY
*"  EXPORTING
*"     REFERENCE(EP_CONNECTION_LIST) TYPE  BC402_T_CONNECTION
*"  RAISING
*"      CX_BC402_NO_CONNECTION
*"----------------------------------------------------------------------

  CONSTANTS:  co_zero_time TYPE s_arr_time VALUE IS INITIAL.

  DATA l_wa_step LIKE LINE OF step_list.

  FIELD-SYMBOLS <fs_connection> TYPE bc402_s_connection.

  SELECT * FROM spfli
           INTO CORRESPONDING FIELDS OF TABLE gt_spfli.

  CLEAR: step_list, gt_connection.

  l_wa_step-cityto = ip_start.
  APPEND l_wa_step TO step_list.

  PERFORM find_conn USING    ip_start
                             ip_dest
                             co_zero_time
                    CHANGING step_list.

  IF LINES( gt_connection ) NE 0.
    SORT gt_connection BY nstops ASCENDING fltime ASCENDING.

    LOOP AT gt_connection ASSIGNING <fs_connection>.
      <fs_connection>-number = sy-tabix.
    ENDLOOP.

    ep_connection_list = gt_connection.

  ELSE.
*    MESSAGE i171(bc402) RAISING no_conn.
    RAISE EXCEPTION TYPE cx_bc402_no_connection
                         EXPORTING
                             cityfrom = ip_start
                             cityto   = ip_dest.
  ENDIF.


ENDFUNCTION.
