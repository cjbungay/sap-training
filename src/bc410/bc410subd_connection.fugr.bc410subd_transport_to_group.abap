FUNCTION BC410SUBD_TRANSPORT_TO_GROUP.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(CARRID) TYPE  SPFLI-CARRID
*"     REFERENCE(CONNID) TYPE  SPFLI-CONNID
*"----------------------------------------------------------------------
  CHECK carrid NE sdyn_conn-carrid.
  CHECK connid NE sdyn_conn-connid.
  SELECT SINGLE * FROM spfli INTO CORRESPONDING FIELDS OF sdyn_conn
  WHERE carrid = carrid AND connid = connid.
ENDFUNCTION.
