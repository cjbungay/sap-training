*&---------------------------------------------------------------------*
*&      Module  INITIALIZE  OUTPUT
*&---------------------------------------------------------------------*
*     Initialize table sflight08 and field OKCODE                      *
*----------------------------------------------------------------------*
MODULE initialize OUTPUT.
  CLEAR: sflight08,
         gs_flight,
         gs_flight_hlp,
         ok_code.
ENDMODULE.                             " INITIALIZE  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  read_sflight  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module read_sflight output.

  SELECT SINGLE *
      FROM  sflight08
      INTO CORRESPONDING FIELDS OF gs_flight
      WHERE carrid      = sflight08-carrid AND
            connid      = sflight08-connid AND
            fldate      = sflight08-fldate .

endmodule.                 " read_sflight  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  DATA_FOR_SUBSCREEN  OUTPUT
*&---------------------------------------------------------------------*
*     Enable customer to move sflight08 work area to X-function group  *
*----------------------------------------------------------------------*
MODULE data_for_subscreen OUTPUT.

**BAdI call to transfer data to badi class:
  CALL METHOD gr_badi_reference->put_data
    EXPORTING
      i_flight = gs_flight.

ENDMODULE.                             " DATA_FOR_SUBSCREEN  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       Set Titlebar and Status for Screen 0100
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  CLEAR: gs_excl_tab,
         gt_excl_tab.
  MOVE '+EXT' TO gs_excl_tab.
  APPEND gs_excl_tab TO gt_excl_tab.
  MOVE 'SAVE' TO gs_excl_tab.
  APPEND gs_excl_tab TO gt_excl_tab.

  SET PF-STATUS 'BASE' EXCLUDING gt_excl_tab.
  SET TITLEBAR '100'.

ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       Set Titlebar and Status for Screen 0200
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.

  PERFORM set_screen_status.

  SET PF-STATUS 'BASE' EXCLUDING gt_excl_tab.
  SET TITLEBAR '100'.


ENDMODULE.                             " STATUS_0200  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  LOCK_DATA  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE lock_data OUTPUT.


  CHECK save_ok = 'CHNG' OR save_ok = 'CREA'.

  CALL FUNCTION 'ENQUEUE_ESFLIGHT08'
   EXPORTING
     mode_sflight08       = 'E'
     mandt                = sy-mandt
     carrid               = sflight08-carrid
     connid               = sflight08-connid
     fldate               = sflight08-fldate
*   _SCOPE               = '2'
*   _WAIT                = ' '
*   _COLLECT             = ' '
   EXCEPTIONS
     foreign_lock         = 1
     system_failure       = 2
     OTHERS               = 3
            .
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDMODULE.                 " LOCK_DATA  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  initialize_badi  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE initialize_badi OUTPUT.

  IF gr_badi_reference IS INITIAL.
    CALL METHOD cl_exithandler=>get_instance
*  EXPORTING
*    EXIT_NAME                     =
*    NULL_INSTANCE_ACCEPTED        = SEEX_FALSE
*  IMPORTING
*    ACT_IMP_EXISTING              =
      CHANGING
        instance                      = gr_badi_reference
      EXCEPTIONS
        OTHERS                        = 9
            .
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.

  CALL METHOD cl_exithandler=>set_instance_for_subscreens
    EXPORTING
      instance                      = gr_badi_reference
    EXCEPTIONS
      no_reference                  = 1
      no_interface_reference        = 2
      no_exit_interface             = 3
      data_incons_in_exit_managem   = 4
      class_not_implement_interface = 5
      OTHERS                        = 6.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDMODULE.                 " initialize_badi  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  get_prog_and_dynnr  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_prog_and_dynnr OUTPUT.

  gv_program = sy-repid.
  gv_dynnr  = sy-dynnr.

  CALL METHOD cl_exithandler=>get_prog_and_dynp_for_subscr
    EXPORTING
      exit_name       = 'BC425_08FLIGHT2'
      calling_dynpro  = gv_dynnr
      calling_program = gv_program
*    FLT_VAL         =
      subscreen_area  = 'SUB'
    IMPORTING
      called_dynpro   = gv_dynnr
      called_program  = gv_program
      .

ENDMODULE.                 " get_prog_and_dynnr  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  move_data  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE move_data_to_screen OUTPUT.

  MOVE-CORRESPONDING gs_flight TO sflight08.

ENDMODULE.                 " move_data_to_screen  OUTPUT
