*&---------------------------------------------------------------------*
*& Report  SAPBC402_PGCD_CALLER
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT sapbc402_pgcd_caller.

TABLES:
    spfli.


*----------------------------------------------------------------------*
START-OF-SELECTION.

  SELECT SINGLE *
      FROM spfli
      WHERE carrid = 'LH'   AND
            connid = '0400'
            .
*----------------------------------------------------------------------*
* 1. call screen in Type 1 program: Data is displayed on screen of
*    calling program!!!
*----------------------------------------------------------------------*

  PERFORM subroutine_call_screen
      IN PROGRAM sapbc402_pgcd_called_type_1
      IF FOUND.

  MESSAGE i301(bc402).

*----------------------------------------------------------------------*
* 2. Call screen in Type F program: Data is not displayed!
*    But the correct screen is sent!
*
* ATTENTION: Independent of the program attributes it is even enough
*            if the first statement is FUNCTION-POOL.
*----------------------------------------------------------------------*

  PERFORM subroutine_call_screen
      IN PROGRAM sapbc402_pgcd_called_type_f
      IF FOUND.

*----------------------------------------------------------------------*
  WRITE: /
      'Programm erfolgreich beendet'(pgf).
