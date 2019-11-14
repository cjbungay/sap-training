FUNCTION TAW10_BASICS_CREATE_PLANELIST.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(IP_SEATSOCC) TYPE  SFLIGHT-SEATSOCC DEFAULT 0
*"     VALUE(IP_CARRID) TYPE  SPFLI-CARRID
*"     VALUE(IP_PAYMENTSUM) TYPE  SFLIGHT-PAYMENTSUM
*"     VALUE(IP_CURRENCY) TYPE  SFLIGHT-CURRENCY
*"  EXPORTING
*"     VALUE(EP_PLANELIST) TYPE  TAW10_TYPS_PLANETAB
*"  EXCEPTIONS
*"      NO_PLANES
*"----------------------------------------------------------------------

DATA:
    l_wa_carr_plane TYPE t_carr_plane,
    l_wa_plane      TYPE taw10_typs_plane.

  LOOP AT it_carr_planes INTO l_wa_carr_plane
                         WHERE carrid EQ ip_carrid
                         AND   seatsmax GE ip_seatsocc.

    l_wa_plane-planetype = l_wa_carr_plane-planetype.
    l_wa_plane-seatsmax  = l_wa_carr_plane-seatsmax.
    l_wa_plane-avg_price = ip_paymentsum / l_wa_carr_plane-seatsmax.
    l_wa_plane-currency  = ip_currency.
    APPEND l_wa_plane TO ep_planelist.

  ENDLOOP.
  IF sy-subrc NE 0.
    MESSAGE e040 RAISING no_planes WITH ip_carrid.
  ELSE.
    SORT ep_planelist BY avg_price DESCENDING.
  ENDIF.


ENDFUNCTION.
