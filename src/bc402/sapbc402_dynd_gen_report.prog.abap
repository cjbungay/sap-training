*&---------------------------------------------------------------------*
*& Report  SAPBC402_DYND_GEN_REPORT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  sapbc402_dynd_gen_report.


DATA:
    itab TYPE TABLE OF string,
    prog TYPE programm  VALUE 'ZBC402_TEST_GEN'.

*Fill internal Table
APPEND 'REPORT ztest.'                       TO itab.          "#EC NOTEXT
APPEND 'PARAMETERS: pa_car type s_carr_id.'  TO itab.          "#EC NOTEXT
APPEND 'START-OF-SELECTION.'                 TO itab.          "#EC NOTEXT
APPEND 'WRITE: ''Hello'', pa_car.'           TO itab.          "#EC NOTEXT


INSERT REPORT prog FROM itab.


SUBMIT (prog) VIA SELECTION-SCREEN
              AND RETURN.
