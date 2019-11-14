*&---------------------------------------------------------------------*
*& Report  SAPBC401_CLSS_ALV                                           *
*&---------------------------------------------------------------------*
*& Template for first excercise on ALV-Grid                            *
*&---------------------------------------------------------------------*

REPORT  sapbc401_clss_alv.

DATA: r_container TYPE REF TO cl_gui_custom_container,
      r_alv_grid  TYPE REF TO cl_gui_alv_grid.

START-OF-SELECTION.
*########################

*** Select data from db into internal table


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

*...

*** create object of class cl_gui_alv_grid to visualize data !

*....

*** Call method to visualize data of internal table ************

*...

endmodule.                 " ALV_GRID  OUTPUT
