*&---------------------------------------------------------------------*
*& Report  SAPBC401_CLSS_ALV                                           *
*&---------------------------------------------------------------------*
*& Template for ALV-Grid event-processing with double_click            *
*&---------------------------------------------------------------------*

REPORT  sapbc401_clss_alv.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    "-------------


ENDCLASS.                    "lcl_event_handler DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

ENDCLASS.                    "lcl_event_handler IMPLEMENTATION

************** Types and Data Definitions ************************
DATA: r_handler TYPE REF TO lcl_event_handler.

*...



START-OF-SELECTION.
*########################

*** create event-handler object to react on double-click

*...

*** select data from db into internal table

*...

*** calling the dynpro on which ALV-Grid will be shown *****
  CALL SCREEN '0100'.


*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYNPROSTATUS'.
  SET TITLEBAR 'TITLE1'.
ENDMODULE.                 " STATUS_0100  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  ALV_GRID  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE alv_grid OUTPUT.

*** Create object of class CL_GUI_CUSTOM_CAONTAINER to manage data !

*....

*** create object of class cl_gui_alv_grid to visualize data !

*....

*** set handler to react on double-click *******************

*...


*** Call method to visualize data of internal table ************

*....

ENDMODULE.                 " ALV_GRID  OUTPUT
