*&---------------------------------------------------------------------*
*& Report  SAPBC402_DBGD_ALLOC_STRING
*&
*&---------------------------------------------------------------------*
*&
*& This Program is meant to demonstrate
*& the memory allocation for strings
*&
*& When the debugger is launched (at the first break point)
*& Analyse the memory use (Goto->Status Display->Memory use)
*& No sooner as the string actually uses memory
*& it is found on the 'Ranked list'
*& keep executing the program and observe the 'Bound, Allocated Memory'
*&
*&---------------------------------------------------------------------*

REPORT  sapbc402_dbgd_alloc_string.

DATA:
  string TYPE string.

BREAK-POINT.              " <- string empty - no display

string = 'X'.

BREAK-POINT.              " <- show large overhead

DO 25 TIMES.

  CONCATENATE string
              string
         INTO string.     " this doubles the size of the string!

  BREAK-POINT.            " <- show used and allocated memory

ENDDO.
