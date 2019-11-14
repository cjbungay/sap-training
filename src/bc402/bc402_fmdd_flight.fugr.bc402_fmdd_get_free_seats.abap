FUNCTION bc402_fmdd_get_free_seats.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IP_PLANETYPE) TYPE  S_PLANETYE
*"     VALUE(IP_SEATSOCC) TYPE  S_SEATSMAX DEFAULT 0
*"  EXPORTING
*"     VALUE(EP_SEATSFREE) TYPE  S_SEATSMAX
*"  EXCEPTIONS
*"      NO_SEATS
*"      OVERLOAD
*"      DB_FAILURE
*"----------------------------------------------------------------------


  SELECT SINGLE seatsmax FROM saplane
                         INTO ep_seatsfree
                         WHERE planetype = ip_planetype.
  IF sy-subrc <> 0.
    MESSAGE e066(bc402) RAISING db_failure.
  ELSEIF ep_seatsfree = 0.
    MESSAGE e100(bc402) RAISING no_seats.
  ELSEIF ep_seatsfree < ip_seatsocc.
    MESSAGE e099(bc402) RAISING overload.
  ELSE.
    ep_seatsfree = ep_seatsfree - ip_seatsocc.
  ENDIF.


ENDFUNCTION.
