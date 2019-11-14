*&---------------------------------------------------------------------*
*& Report  SAPBC400TSS_COMPUTE                                         *
*&---------------------------------------------------------------------*

REPORT  sapbc400tss_compute .

PARAMETERS:
  pa_int1  TYPE i,
  pa_op(1) TYPE c,
  pa_int2  TYPE i.

DATA result TYPE p DECIMALS 2.


IF NOT ( pa_op = '+' OR
         pa_op = '-' OR
         pa_op = '*' OR
         pa_op = '/' ).

  WRITE: 'Invalid operator!'(iop).

ELSEIF  pa_op = '/'  AND  pa_int2 = 0.

  WRITE: 'No division by zero!'(dbz).

ELSE.

  CASE pa_op.
    WHEN '+'.
      result = pa_int1 + pa_int2.
    WHEN '-'.
      result = pa_int1 - pa_int2.
    WHEN '*'.
      result = pa_int1 * pa_int2.
    WHEN '/'.
      result = pa_int1 / pa_int2.
  ENDCASE.

  WRITE: 'Result:'(res), result.

ENDIF.
