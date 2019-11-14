FUNCTION BC412_BDS_GET_PIC_FILENAME.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(PICTURE_NAME)
*"  EXPORTING
*"     VALUE(FILE_NAME) TYPE  BDS_FILENA
*"  EXCEPTIONS
*"      BDS_ERROR
*"----------------------------------------------------------------------
  DATA: o_bds_document TYPE REF TO cl_bds_document_set,
        it_signature   TYPE TABLE OF bapisignat,
        it_components  TYPE TABLE OF bapicompon,
        wa_components  LIKE LINE OF it_components.

  CREATE OBJECT o_bds_document.

  CALL METHOD o_bds_document->get_info
    EXPORTING
      classname   = 'BC412'
      classtype   = 'OT'
      object_key  = picture_name
    CHANGING
      components      = it_components
      signature       = it_signature
    EXCEPTIONS
      nothing_found   = 1
      error_kpro      = 2
      internal_error  = 3
      parameter_error = 4
      not_authorized  = 5
      not_allowed     = 6.

  FREE o_bds_document.

  IF sy-subrc NE 0.
    RAISE bds_error.
  ELSE.
    READ TABLE it_components INTO wa_components INDEX 1.
    file_name = wa_components-comp_id.
  ENDIF.

ENDFUNCTION.
