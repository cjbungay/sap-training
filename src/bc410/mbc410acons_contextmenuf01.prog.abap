*&---------------------------------------------------------------------*
*&  Include           MBC410ACONS_CONTEXTMENUF01
*&---------------------------------------------------------------------*
**********************************************************************
* FORM    :  on_ctmenu_dyn0100
**********************************************************************
FORM on_ctmenu_dyn0100 USING p_menu TYPE REF TO cl_ctmenu.

  DATA: l_fcodes TYPE ui_functions.
  CALL METHOD cl_ctmenu=>load_gui_status
    EXPORTING
      program = sy-cprog
      status  = 'DYN0100'
      menu    = p_menu.

  IF maintain_flights = 'X'.
    APPEND 'SAVE' TO l_fcodes.
    CALL METHOD p_menu->enable_functions
      EXPORTING
        fcodes = l_fcodes.

  ENDIF.

ENDFORM. "on_ctmenu_dyn0100
**********************************************************************
* FORM    :  on_ctmenu_sub0130
**********************************************************************
FORM on_ctmenu_sub0130
  USING p_menu TYPE REF TO cl_ctmenu.
  CALL METHOD cl_ctmenu=>load_gui_status
    EXPORTING
      program = sy-cprog
      status  = 'SUB0130'
      menu    = p_menu.
ENDFORM. "on_ctmenu_sub0130
