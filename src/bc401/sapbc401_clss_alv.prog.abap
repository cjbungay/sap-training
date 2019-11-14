*&---------------------------------------------------------------------*
*& Report  SAPBC401_CLSS_ALV                                           *
*&---------------------------------------------------------------------*
*& Programming an easy ALV Grid Control       EXERCISE 1               *
*&---------------------------------------------------------------------*

REPORT  sapbc401_clss_alv.

DATA: r_container TYPE REF TO cl_gui_custom_container,
      r_alv_grid  TYPE REF TO cl_gui_alv_grid.

TYPES: ty_spfli TYPE STANDARD TABLE OF spfli
                     WITH KEY carrid connid.

DATA: it_spfli TYPE ty_spfli.

START-OF-SELECTION.
*########################

  SELECT * FROM spfli INTO TABLE it_spfli.

*** calling the dynpro on which ALV-Grid will be shown *****
  CALL SCREEN '0100'.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYNPROSTATUS'.
*  SET TITLEBAR 'xxx'.
ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  ALV_GRID  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module ALV_GRID output.
*** Create object of class CL_GUI_CUSTOM_CAONTAINER to manage data !
  if not r_container is bound.
  CREATE OBJECT r_container
    EXPORTING
      container_name              = 'CONTAINER_1'
    EXCEPTIONS
      OTHERS                      = 6.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
             WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  endif.
*** create object of class cl_gui_alv_grid to visualize data !
  if not r_alv_grid is bound.
  CREATE OBJECT r_alv_grid
    EXPORTING
      i_parent          = r_container
    EXCEPTIONS
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  endif.

*** Call method to visualize data of internal table ************
  CALL METHOD r_alv_grid->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SPFLI'
    CHANGING
      it_outtab        = it_spfli
    EXCEPTIONS
      OTHERS           = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

endmodule.                 " ALV_GRID  OUTPUT
