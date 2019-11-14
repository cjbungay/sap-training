FUNCTION UPDATE_SFLIGHT.
*"----------------------------------------------------------------------
*"*"Verbuchungsfunktionsbaustein:
*"
*"*"Lokale Schnittstelle:
*"       IMPORTING
*"             VALUE(CARRIER) LIKE  SFLIGHT-CARRID
*"             VALUE(CONNECTION) LIKE  SFLIGHT-CONNID
*"             VALUE(DATE) LIKE  SFLIGHT-FLDATE
*"       EXCEPTIONS
*"              UPDATE_FAILURE
*"              FLIGHT_FULL
*"              FLIGHT_NOT_FOUND
*"----------------------------------------------------------------------

  DATA: WA_SFLIGHT LIKE SFLIGHT.
  DATA: NUMBER TYPE SFLIGHT-SEATSOCC,
        PAYMENTSUM TYPE SFLIGHT-PAYMENTSUM.

  SELECT COUNT(*) SUM( LOCCURAM ) FROM SBOOK INTO (NUMBER, PAYMENTSUM)
         WHERE CARRID  = CARRIER
         AND   CONNID  = CONNECTION
         AND   FLDATE  = DATE
         AND CANCELLED = SPACE.

  SELECT SINGLE * FROM SFLIGHT INTO WA_SFLIGHT
         WHERE CARRID = CARRIER
         AND   CONNID = CONNECTION
         AND   FLDATE = DATE.

  CASE SY-SUBRC.
    WHEN 0.                            "Flight exists
      IF NUMBER <= WA_SFLIGHT-SEATSMAX.
* Numer of bookings smaller than or equal seats in plane
        UPDATE SFLIGHT SET SEATSOCC   = NUMBER
                           PAYMENTSUM = PAYMENTSUM
               WHERE CARRID = CARRIER
               AND   CONNID = CONNECTION
               AND   FLDATE = DATE.
        IF SY-SUBRC <> 0.
          MESSAGE A040 RAISING UPDATE_FAILURE.
        ENDIF.
* Numer of bookings larger than seats in plane
      ELSE.
        MESSAGE A045 RAISING FLIGHT_FULL.
      ENDIF.
    WHEN OTHERS.                       "Flight does not exist
      MESSAGE A046 RAISING FLIGHT_NOT_FOUND.
  ENDCASE.

ENDFUNCTION.
