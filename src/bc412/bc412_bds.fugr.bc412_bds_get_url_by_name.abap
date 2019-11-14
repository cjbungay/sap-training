FUNCTION BC412_BDS_GET_URL_BY_NAME.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(PICTURE_NAME) TYPE  BDS_TYPEID
*"  EXPORTING
*"     REFERENCE(URL) TYPE  BAPIURI-URI
*"  EXCEPTIONS
*"      NOT_FOUND
*"----------------------------------------------------------------------
  data: o_bds_document type ref to cl_bds_document_set,
        it_uris       type table of BAPIURI,
        it_signature  type table of BAPISIGNAT,
        it_components type table of BAPICOMPON,
        wa_uris       like line of it_uris.

  create object o_bds_document.

  call method o_bds_document->get_with_URL
    exporting
      CLASSNAME    = 'BC412'
      CLASSTYPE    = 'OT'
      object_key   = picture_name
      URL_LIFETIME = 'T'  " T = transaction, X = client , 1 =temp=stand.
    changing
      URIS       = it_uris
      SIGNATURE  = it_signature
      COMPONENTS = it_components
    exceptions
      NOTHING_FOUND   = 1
      ERROR_KPRO      = 2
      INTERNAL_ERROR  = 3
      PARAMETER_ERROR = 4
      NOT_AUTHORIZED  = 5
      NOT_ALLOWED     = 6.
  if sy-subrc ne 0.
    free o_bds_document.
    raise not_found.
  else.
    read table it_uris into wa_uris index 1.
    url = wa_uris-uri.
    free o_bds_document.
  endif.

ENDFUNCTION.
