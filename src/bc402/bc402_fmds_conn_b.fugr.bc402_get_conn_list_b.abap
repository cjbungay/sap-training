FUNCTION bc402_get_conn_list_b.
*"--------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(IP_START) TYPE  S_FROM_CIT
*"     VALUE(IP_DEST) TYPE  S_TO_CITY
*"  EXPORTING
*"     REFERENCE(EP_CONN_LIST) TYPE  BC402_T_CONN
*"  EXCEPTIONS
*"      NO_CONN
*"--------------------------------------------------------------------
  DATA          wa_conn             LIKE LINE OF ep_conn_list.
  DATA          lt_connection_list  TYPE bc402_t_connection.
  FIELD-SYMBOLS <fs_connection>     TYPE bc402_s_connection.

* call function module and store result in global data
  TRY.
      CALL FUNCTION 'BC402_FMDD_CONNECTION_LIST'
        EXPORTING
          ip_start           = ip_start
          ip_dest            = ip_dest
        IMPORTING
          ep_connection_list = lt_connection_list.

* anything found by function module?
    CATCH cx_bc402_no_connection.
* raise exception
      MESSAGE e171(bc402) RAISING no_conn.
  ENDTRY.

* copy result to output
  LOOP AT lt_connection_list ASSIGNING <fs_connection>.
    MOVE-CORRESPONDING <fs_connection> TO wa_conn.
    APPEND wa_conn TO ep_conn_list.
  ENDLOOP.

ENDFUNCTION.
