FUNCTION BC412_BDS_GET_PIC_URL.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(NUMBER) TYPE  I DEFAULT 1
*"  EXPORTING
*"     REFERENCE(URL) TYPE  BAPIURI-URI
*"  EXCEPTIONS
*"      INVALID_INPUT
*"      NO_DATA_FOUND
*"----------------------------------------------------------------------
  DATA: picture_name TYPE bds_typeid.

  IF NOT number BETWEEN 1 AND 9.
    RAISE invalid_input.
  ELSE.
    CASE number.
      WHEN 1.
        picture_name = c_object_key1.
      WHEN 2.
        picture_name = c_object_key2.
      WHEN 3.
        picture_name = c_object_key3.
      WHEN 4.
        picture_name = c_object_key4.
      WHEN 5.
        picture_name = c_object_key5.
      WHEN 6.
        picture_name = c_object_key6.
      WHEN 7.
        picture_name = c_object_key7.
      WHEN 8.
        picture_name = c_object_key8.
      WHEN 9.
        picture_name = c_object_key9.
    ENDCASE.
    CALL FUNCTION 'BC412_BDS_GET_URL_BY_NAME'
         EXPORTING
              picture_name = picture_name
         IMPORTING
              url          = url
         EXCEPTIONS
              not_found    = 1
              OTHERS       = 2.

    IF sy-subrc <> 0.
      RAISE no_data_found.
    ENDIF.

  ENDIF.




ENDFUNCTION.
