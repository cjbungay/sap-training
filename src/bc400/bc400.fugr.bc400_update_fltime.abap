FUNCTION BC400_UPDATE_FLTIME.
*"----------------------------------------------------------------------
*"*"Globale Schnittstelle:
*"       IMPORTING
*"             VALUE(IV_CARRID) LIKE  SPFLI-CARRID
*"             VALUE(IV_CONNID) LIKE  SPFLI-CONNID
*"             VALUE(IV_FLTIME) LIKE  SPFLI-FLTIME
*"             VALUE(IV_DEPTIME) LIKE  SPFLI-DEPTIME
*"       EXCEPTIONS
*"              FLIGHT_NOT_FOUND
*"              UPDATE_SPFLI_REJECTED
*"              FLIGHT_LOCKED
*"----------------------------------------------------------------------

  DATA: WA_SPFLI LIKE SPFLI.
  DATA: H_ARRTIME LIKE SPFLI-ARRTIME,
        H_DELTA_TIME TYPE I.

* Check whether connection is valid
  SELECT SINGLE * FROM  SPFLI INTO WA_SPFLI
         WHERE  CARRID      = IV_CARRID
         AND    CONNID      = IV_CONNID .
  IF SY-SUBRC NE 0.
    MESSAGE E115 RAISING FLIGHT_NOT_FOUND.
  ENDIF.

* locking the flight in table SPFLI is left out for didactical reasoms
* See locking concept in chapter transaction concept

* compute arrival time assuming that data is still consistent now.
  IF WA_SPFLI-DEPTIME NE IV_DEPTIME.
    H_ARRTIME = WA_SPFLI-ARRTIME + IV_DEPTIME - WA_SPFLI-DEPTIME.
  ELSEIF WA_SPFLI-FLTIME = IV_FLTIME.
    EXIT.                              " message???
  ELSE.
    H_ARRTIME = WA_SPFLI-ARRTIME.
  ENDIF.
* fltime: flighttime in minutes
* h_delta_time: time interval in seconds
  H_DELTA_TIME = ( IV_FLTIME - WA_SPFLI-FLTIME ) * 60.
  H_ARRTIME = H_ARRTIME + H_DELTA_TIME.



  UPDATE SPFLI SET FLTIME  = IV_FLTIME
                   DEPTIME = IV_DEPTIME
                   ARRTIME = H_ARRTIME
                   WHERE CARRID = IV_CARRID
                   AND   CONNID = IV_CONNID.
  IF SY-SUBRC NE 0.
    MESSAGE A147.
  ENDIF.


ENDFUNCTION.
