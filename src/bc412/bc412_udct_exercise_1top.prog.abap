*&---------------------------------------------------------------------*
*& Include BC412_UDCT_EXERCISE_1TOP                                    *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  sapbc412_udct_exercise_1 MESSAGE-ID bc412   .

DATA:
* screen specific:
  ok_code      TYPE sy-ucomm,
  copy_ok_code LIKE ok_code,
  l_answer     TYPE c.
