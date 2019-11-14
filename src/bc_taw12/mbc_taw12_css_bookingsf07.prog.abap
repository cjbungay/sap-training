*----------------------------------------------------------------------*
***INCLUDE MTAW12_BOOKINGS_TMPF07 .
*----------------------------------------------------------------------*



*&---------------------------------------------------------------------*
*&      Form  badi_initialize
*&---------------------------------------------------------------------*
FORM badi_initialize .

  IF gr_badi_reference IS INITIAL.

    CALL METHOD cl_exithandler=>get_instance
      CHANGING
        instance = gr_badi_reference
      EXCEPTIONS
        OTHERS   = 9.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

  CALL METHOD cl_exithandler=>set_instance_for_subscreens
    EXPORTING
      instance = gr_badi_reference
    EXCEPTIONS
      OTHERS   = 6.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

* ask impl.-instance for screen/prog.name
  gv_program = sy-repid.
  gv_dynnr  = '0304'.
  CALL METHOD cl_exithandler=>get_prog_and_dynp_for_subscr
    EXPORTING
      exit_name       = gv_exitname
      calling_dynpro  = gv_dynnr
      calling_program = gv_program
      subscreen_area  = 'SUB_SPECIALS'
    IMPORTING
      called_dynpro   = gv_dynnr
      called_program  = gv_program.

* ask impl.-instance for tab-label
  CALL METHOD gr_badi_reference->get_tab_name
    IMPORTING
      tabname = pb_specials.

* send mode (CHANGE) to instance
  CALL METHOD gr_badi_reference->put_modus
    EXPORTING
      i_mode = 'C'.

ENDFORM.                    " badi_initialize


*&---------------------------------------------------------------------*
*&      Form  specials_user_command
*&---------------------------------------------------------------------*
FORM specials_user_command.

  CHECK NOT save_ok IS INITIAL.

  CALL METHOD gr_badi_reference->process_fcode
    EXPORTING
      fcode = save_ok.

ENDFORM.                    " specials_user_command

*&---------------------------------------------------------------------*
*&      Form  specials_save
*&---------------------------------------------------------------------*
FORM specials_save.

  CALL METHOD gr_badi_reference->save
    EXPORTING
      i_bookid = wa_sbook-bookid.

ENDFORM.                    " specials_user_command


*&---------------------------------------------------------------------*
*&      Form  put_flight_key_to_badi
*&---------------------------------------------------------------------*
FORM put_flight_key_to_badi  USING value(wa_sflight) TYPE sflight.

  CALL METHOD gr_badi_reference->put_key_data
    EXPORTING
      i_carrid = wa_sflight-carrid
      i_connid = wa_sflight-connid
      i_fldate = wa_sflight-fldate.


ENDFORM.                    " put_flight_key_to_badi
