FUNCTION insert_scustom.
*"----------------------------------------------------------------------
*"*"Verbuchungsfunktionsbaustein:
*"
*"*"Lokale Schnittstelle:
*"       IMPORTING
*"             VALUE(WA_SCUST) LIKE  SCUSTOM STRUCTURE  SCUSTOM
*"       EXCEPTIONS
*"              INSERT_FAILURE
*"----------------------------------------------------------------------

  INSERT INTO scustom VALUES wa_scust.
  IF sy-subrc <> 0.
    MESSAGE a048 RAISING insert_failure.
  ENDIF.

ENDFUNCTION.
