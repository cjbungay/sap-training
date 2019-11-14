FUNCTION BC400_FREE_SEATS.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(SEATSOCC) LIKE  SFLIGHT-SEATSOCC
*"     VALUE(SEATSMAX) LIKE  SFLIGHT-SEATSMAX
*"  EXPORTING
*"     VALUE(SEATSFREE) LIKE  SFLIGHT-SEATSOCC
*"  EXCEPTIONS
*"      OCC_GT_MAX
*"      MAX_EQ_0
*"----------------------------------------------------------------------

IF SEATSMAX = 0.
    RAISE MAX_EQ_0.
ELSEIF SEATSOCC > SEATSMAX.
    RAISE OCC_GT_MAX.
ENDIF.
SEATSFREE = SEATSMAX - SEATSOCC.

ENDFUNCTION.
