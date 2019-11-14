*&---------------------------------------------------------------------*
*& Report  SAPBC402_DTSD_MIXED_TYPES                                   *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  BC402: Demo program for 'the data type of all used variables in a  *
*&         arithmetic expression determines the arithmetic used.       *
*&         (kind of 'truncation')                                      *
*&---------------------------------------------------------------------*

REPORT  sapbc402_dtsd_mixed_types  LINE-SIZE 100.

DATA:
  a        TYPE i VALUE 201,
  b        TYPE i VALUE 200,
  c        TYPE i VALUE 0,
  p_result TYPE p DECIMALS 2,
  f_result TYPE f.

START-OF-SELECTION.

  WRITE: / text-001 color col_group.
* (001) EN: 'before calculation'
  SKIP 1.
  FORMAT COLOR COL_HEADING.
  WRITE: /5  text-002,    " <-- 'variable'
          18 text-003,    " <-- 'type'
          25 text-004.    " <-- 'value'
  FORMAT COLOR COL_KEY.
  WRITE: /5 '   a    ', 18 ' I ', 25(5) a,
         /5 '   b    ', 18 ' I ', 25(5) b,
         /5 '   c    ', 18 ' I ', 25(5) c,
         /5 'p_result', 18 ' P ', 25(5) p_result,
         /5 'f_result', 18 ' F ', 25    f_result.
  FORMAT COLOR COL_KEY OFF.
  SKIP 2.

  WRITE: / text-005 color col_group.
* (005) EN: 'after calculation'
  SKIP 1.

  p_result = ( a / b ) + c .

  WRITE: / '(',
           a      COLOR COL_KEY,
           ' / '  COLOR COL_NORMAL,
           b      COLOR COL_KEY,
           ') +      ',
           c      COLOR COL_KEY,
           '=  ',
           p_result COLOR COL_TOTAL,
           85 '(<-- p_result)'.


  ULINE.

  p_result = ( a / b ) + SQRT( c ).

  WRITE: / '(',
           a      COLOR COL_KEY,
           ' / '  COLOR COL_NORMAL,
           b      COLOR COL_KEY,
           ') + SQRT(',
           c      COLOR COL_KEY,
           ') =',
           p_result COLOR COL_TOTAL,
           85 '(<-- p_result)'.

  f_result = ( a / b ) + SQRT( c ).


  WRITE: / '(',
           a      COLOR COL_KEY,
           ' / '  COLOR COL_NORMAL,
           b      COLOR COL_KEY,
           ') + SQRT(',
           c      COLOR COL_KEY,
           ') =',
           f_result COLOR COL_TOTAL,
           85 '(<-- f_result)'.
