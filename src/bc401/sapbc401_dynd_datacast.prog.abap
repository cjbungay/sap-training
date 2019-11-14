*&---------------------------------------------------------------------*
*& Report  SAPBC401_DYND_DATACAST                                      *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc401_dynd_datacast         .

DATA:
  int  TYPE i VALUE 15,
  date TYPE d VALUE '20040101'.

DATA:
  ref_int  TYPE REF TO i,
  ref_date TYPE REF TO d,
  ref_gen  TYPE REF TO data.

PARAMETERS:
  p_c     RADIOBUTTON GROUP comp DEFAULT 'X',
  p_not_c RADIOBUTTON GROUP comp.



START-OF-SELECTION.

  IF p_c = 'X'.  "won't cause type conflict
    GET REFERENCE OF int INTO ref_int.
*   narrowing cast:
    ref_gen = ref_int.
  ELSE. "will cause type conflict
    GET REFERENCE OF date INTO ref_date.
*   narrowing cast:
    ref_gen = ref_date.
  ENDIF.

  TRY.
*     widening cast:
      ref_int ?= ref_gen.
      WRITE: /
             'Content of the dereferenced data reference:'(cdr),
              ref_int->* COLOR COL_POSITIVE.

    CATCH cx_sy_move_cast_error.
      WRITE 'The exception MOVE_CAST_ERROR was raised!'(mce)
            COLOR COL_NEGATIVE.
  ENDTRY.
