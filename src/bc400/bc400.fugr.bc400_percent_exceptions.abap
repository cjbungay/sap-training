FUNCTION BC400_PERCENT_EXCEPTIONS.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"       IMPORTING
*"             VALUE(SEATSMAX) LIKE  SFLIGHT-SEATSMAX
*"             VALUE(SEATSOCC) LIKE  SFLIGHT-SEATSOCC
*"       EXPORTING
*"             VALUE(PERCENTAGE) LIKE  SBC400FOCC-PERCENTAGE
*"       EXCEPTIONS
*"              DIVISION_BY_ZERO
*"              OCC_GT_MAX
*"----------------------------------------------------------------------

  IF SEATSMAX = 0.
    MESSAGE E050(BC400) RAISING DIVISION_BY_ZERO.
  ELSEIF SEATSOCC > SEATSMAX.
    MESSAGE E109(BC400) RAISING  OCC_GT_MAX.
  ENDIF.

  PERCENTAGE = SEATSOCC * 100 / SEATSMAX.
ENDFUNCTION.
