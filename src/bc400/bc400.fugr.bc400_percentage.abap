FUNCTION BC400_PERCENTAGE.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"       IMPORTING
*"             VALUE(SEATSMAX) LIKE  SFLIGHT-SEATSMAX
*"             VALUE(SEATSOCC) LIKE  SFLIGHT-SEATSOCC
*"       EXPORTING
*"             VALUE(PERCENTAGE) TYPE  BC400_PERCENTAGE
*"       EXCEPTIONS
*"              DIVISION_BY_ZERO
*"              OCC_GT_MAX
*"----------------------------------------------------------------------

  IF SEATSMAX = 0.
    RAISE DIVISION_BY_ZERO.
  ELSEIF SEATSOCC > SEATSMAX.
    RAISE  OCC_GT_MAX.
  ENDIF.

  PERCENTAGE = SEATSOCC * 100 / SEATSMAX.
ENDFUNCTION.
