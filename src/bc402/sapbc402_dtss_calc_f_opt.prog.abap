*&---------------------------------------------------------------------*
*& Report  SAPBC402_DTSS_CALC_F_OPT                                    *
*&                                                                     *
*& solution for exercise 3:                                            *
*& calculate with data objects with type f                             *
*& including list colors                                               *
*&---------------------------------------------------------------------*

REPORT  sapbc402_dtss_calc_f_opt.

PARAMETERS:
  pa_val1     TYPE i DEFAULT 5,           " input variable 1
  pa_val2     TYPE i DEFAULT 3.           " input variable 2

DATA:
  gv_result   TYPE f.                     " result variable

START-OF-SELECTION.
  WRITE: / text-001 COLOR COL_HEADING.
*   (001) EN: 'calculate with floating point data'
  SKIP 1.
  WRITE: / text-002, pa_val1 COLOR COL_KEY,
         / text-003, pa_val2 COLOR COL_KEY.
*   (002) EN: 'operand 1 = '
*   (003) EN: 'operand 2 = '
  SKIP 2.

* addition:       a + b
  gv_result = pa_val1 + pa_val2.

  WRITE: / pa_val1 COLOR COL_KEY,
           ' + '    COLOR COL_NORMAL,
           pa_val2 COLOR COL_KEY,
           ' = '    ,
           gv_result   COLOR COL_TOTAL.
  SKIP 1.

* subtraction:    a - b
  gv_result = pa_val1 - pa_val2.

  WRITE: / pa_val1 COLOR COL_KEY,
           ' - '    COLOR COL_NORMAL,
           pa_val2 COLOR COL_KEY,
           ' = '    ,
           gv_result   COLOR COL_TOTAL.
  SKIP 1.

* division:       a / b
  gv_result = pa_val1 / pa_val2.

  WRITE: / pa_val1 COLOR COL_KEY,
           ' / '    COLOR COL_NORMAL,
           pa_val2 COLOR COL_KEY,
           ' = ',
           gv_result   COLOR COL_TOTAL.
  SKIP 1.

* multiplication: a * b
  gv_result = pa_val1 * pa_val2.

  WRITE: / pa_val1 COLOR COL_KEY,
           ' * '    COLOR COL_NORMAL,
           pa_val2 COLOR COL_KEY,
           ' = ',
           gv_result   COLOR COL_TOTAL.
  SKIP 1.

  ULINE.
* div
  gv_result = pa_val1 DIV pa_val2.

  WRITE: / pa_val1 COLOR COL_KEY,
           ' div '  COLOR COL_NORMAL,
           pa_val2 COLOR COL_KEY,
           ' = ',
           gv_result   COLOR COL_TOTAL.
  SKIP 1.

* mod
  gv_result = pa_val1 MOD pa_val2.

  WRITE: / pa_val1 COLOR COL_KEY,
           ' mod '  COLOR COL_NORMAL,
           pa_val2 COLOR COL_KEY,
           ' = ',
           gv_result   COLOR COL_TOTAL.
  SKIP 1.

** exp(a) + log(b)
*  result = exp( p_value1 ) * log( p_value2 ).
*  WRITE: / 'exp(', p_value1, ') * log(', p_value2, ') = ', result.
*  SKIP 1.
