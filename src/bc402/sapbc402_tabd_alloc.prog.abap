*&---------------------------------------------------------------------*
*& Report  SAPBC402_TABD_ALLOC
*&
*&---------------------------------------------------------------------*
*&
*& This Program is meant to demonstrate
*&    - the memory allocation for internal tables
*&    - the impact of INITIAL SIZE on the step size
*&
*& When the debugger is launched (at the first break point)
*& Analyse the memory use (Goto->Status Display->Memory use)
*& No sooner as the internal tables actually use memory
*& they are found on the 'Ranked list'
*& keep executing the program and observe the 'Bound, Allocated Memory'
*&
*&---------------------------------------------------------------------*

REPORT  sapbc402_tabd_alloc.

TYPES:
  ty_line TYPE x LENGTH 100.
DATA:
  itab_0    TYPE STANDARD TABLE OF ty_line INITIAL SIZE 0,
  itab_1    TYPE STANDARD TABLE OF ty_line INITIAL SIZE 1,
  itab_5    TYPE STANDARD TABLE OF ty_line INITIAL SIZE 5,
  itab_10   TYPE STANDARD TABLE OF ty_line INITIAL SIZE 10.


BREAK-POINT.                   " <- tables empty - no display

DO 18 TIMES.

  APPEND INITIAL LINE TO itab_0.
  APPEND INITIAL LINE TO itab_1.
  APPEND INITIAL LINE TO itab_5.
  APPEND INITIAL LINE TO itab_10.


  BREAK-POINT.                 " <- used memory increased by ~100 Byte
                               "    allocation depends on initial size
ENDDO.
