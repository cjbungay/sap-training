*&---------------------------------------------------------------------*
*& Report  SAPBC402_DTSS_CALC_P                                        *
*&                                                                     *
*& solution for exercise 2:                                            *
*& calculate with data objects with type p                             *
*&---------------------------------------------------------------------*

REPORT  sapbc402_dtss_calc_p.

PARAMETERS:
  pa_val1     TYPE p LENGTH 8 DECIMALS 2 DEFAULT 5,           " input variable 1
  pa_val2     TYPE p LENGTH 8 DECIMALS 3 DEFAULT 3.           " input variable 2

DATA:
  gv_result   TYPE p LENGTH 8 DECIMALS 4.              " result variable

START-OF-SELECTION.
  WRITE: / text-001.
*   (001) EN: 'calculate with packed data'
  SKIP 1.
  WRITE: / text-002, pa_val1,
         / text-003, pa_val2.
*   (002) EN: 'operand 1 = '
*   (003) EN: 'operand 2 = '
  SKIP 2.

* addition:       a + b
  gv_result = pa_val1 + pa_val2.
  WRITE: / pa_val1, ' + ', pa_val2, ' = ', gv_result.
  SKIP 1.

* subtraction:    a - b
  gv_result = pa_val1 - pa_val2.
  WRITE: / pa_val1, ' - ', pa_val2, ' = ', gv_result.
  SKIP 1.

* division:       a / b
  gv_result = pa_val1 / pa_val2.
  WRITE: / pa_val1, ' / ', pa_val2, ' = ', gv_result.
  SKIP 1.

* multiplication: a * b
  gv_result = pa_val1 * pa_val2.
  WRITE: / pa_val1, ' * ', pa_val2, ' = ', gv_result.
  SKIP 1.

* div
  gv_result = pa_val1 DIV pa_val2.
  WRITE: / pa_val1, 'div', pa_val2, ' = ', gv_result.
  SKIP 1.

* mod
  gv_result = pa_val1 MOD pa_val2.
  WRITE: / pa_val1, 'mod', pa_val2, ' = ', gv_result.
  SKIP 1.

* power
  gv_result = pa_val1 ** pa_val2.
  WRITE: / pa_val1, '** ', pa_val2, ' = ', gv_result.
  SKIP 1.
