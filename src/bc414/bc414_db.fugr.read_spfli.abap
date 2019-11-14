FUNCTION READ_SPFLI.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"       IMPORTING
*"             REFERENCE(CARRID) TYPE  SPFLI-CARRID
*"             REFERENCE(CONNID) TYPE  SPFLI-CONNID
*"       EXCEPTIONS
*"              INVALID_KEY
*"----------------------------------------------------------------------

SELECT single * FROM  spfli into spfli
       WHERE  carrid  = carrid
       AND    connid  = connid.
  if sy-subrc ne 0.
    raise invalid_key.
  endif.

  call screen 100 starting at 5 5.



ENDFUNCTION.
