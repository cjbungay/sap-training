*&---------------------------------------------------------------------*
*& Include MBC410INPD_RADIOBUTTON_PAITOP                               *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  sapmbc410inpd_radiobutton_pai .

TABLES semployes.

DATA: ok_code LIKE sy-ucomm.

DATA: radio1 VALUE 'X',
      radio2,
      text1(50),
      text2(50),
      salary(10).

START-OF-SELECTION.

  CALL SCREEN 100 STARTING AT 10 10.
