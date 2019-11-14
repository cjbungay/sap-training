*&---------------------------------------------------------------------*
*& Report  SAPBC402_PGCD_CALLED_TYPE_1
*&
*&---------------------------------------------------------------------*
*& called program of type 1 (Online report)
*& TABLES is shared!
*& Screen is called in calling program!
*&---------------------------------------------------------------------*

REPORT sapbc402_pgcd_called_type_1.

TABLES:
    spfli.


*&--------------------------------------------------------------------*
*&      Form  subroutine_call_screen
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM subroutine_call_screen.

  CALL SCREEN 100.

ENDFORM.                    "subroutine_call_screen
