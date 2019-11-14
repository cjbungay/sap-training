*----------------------------------------------------------------------*
***INCLUDE MBC_TAW12_CSS_FLIGHT_DISPLAF01 .
*----------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      Form  display_specials
*&---------------------------------------------------------------------*
FORM display_specials .
  DATA:
    ls_sbook   TYPE sbook,
    lf_number  TYPE i,
    lf_mode(1) TYPE c.

  CASE 'X'.
    WHEN mode-maintain_bookings.
*     update of changes to 'specials' not finished !
      lf_mode = 'V'.
    WHEN OTHERS.
      lf_mode = 'V'.
  ENDCASE.


  READ TABLE it_sdyn_book INTO sdyn_book WITH KEY mark = 'X'.
  CHECK sy-subrc = 0.
  MOVE-CORRESPONDING sdyn_book TO ls_sbook.

  CALL FUNCTION 'BC_TAW12_CSS_LOAD_DATA'
    EXPORTING
      i_sbook           = ls_sbook
      i_modus           = lf_mode
    IMPORTING
      number_of_entries = lf_number.

  IF lf_number IS INITIAL.
    MESSAGE s184 WITH 'keine Sonderwünsche vorhanden'.
    EXIT.
  ENDIF.

  CALL SCREEN 135 STARTING AT 3 3.

ENDFORM.                    " display_specials
