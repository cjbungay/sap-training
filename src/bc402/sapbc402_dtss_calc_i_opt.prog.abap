*&---------------------------------------------------------------------*
*& Report  SAPBC402_DTSS_CALC_I_OPT                                    *
*&                                                                     *
*& solution for exercise 1: data objects, types and commands           *
*& calculate with data objects with type i                             *
*& list output with colors                                             *
*&---------------------------------------------------------------------*

REPORT  sapbc402_dtss_calc_i_opt.

PARAMETERS:
  pa_val1     TYPE i DEFAULT 5,           " input variable 1
  pa_val2     TYPE i DEFAULT 3.           " input variable 2

DATA:
  gv_result   TYPE i.                     " result variable

START-OF-SELECTION.
  WRITE: / text-001 COLOR COL_HEADING.
*   (001) EN: 'calculate with integer data'

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

* exponent a**b
  gv_result = pa_val1 ** pa_val2.

  WRITE: / pa_val1 COLOR COL_KEY,
           ' hoch'  COLOR COL_NORMAL,
           pa_val2 COLOR COL_KEY,
           ' = ',
           gv_result   COLOR COL_TOTAL.
  SKIP 1.
