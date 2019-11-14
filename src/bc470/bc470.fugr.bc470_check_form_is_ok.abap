FUNCTION bc470_check_form_is_ok.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(SMART_FORM_NAME) TYPE  STXFADM-FORMNAME
*"  EXCEPTIONS
*"      NO_FORM
*"      NOT_SUITABLE
*"----------------------------------------------------------------------
* This function module checks whether a given SAP Smart Forms is
* suitable for demoing it with a standard demo program like
* SAPBC470_DEMO.
* It will be checked whether any non-optional parameters are used
* in the SAP Smart Forms other than the ones filled by the application
* programs used in the BC470 class.
* It will also be checked whether the appropriate type is used.

  DATA:
    func_mod TYPE rs38l_fnam,
    it_func_mod_params TYPE TABLE OF fupararef,
    func_mod_param TYPE fupararef.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
       EXPORTING
            formname = smart_form_name
       IMPORTING
            fm_name  = func_mod
       EXCEPTIONS
            no_form  = 1
            OTHERS   = 2.
  CASE sy-subrc.
    WHEN 1.
      RAISE no_form.
  ENDCASE.

  SELECT *
    FROM fupararef
    INTO TABLE it_func_mod_params
    WHERE funcname = func_mod AND
          r3state  = 'A'.

  LOOP AT it_func_mod_params
    INTO func_mod_param.
    CASE func_mod_param-paramtype.
      WHEN 'E'.
        " export parameters are always optional, so they don't hurt
      WHEN 'X'.
        " exceptions are always optional, so they don't hurt
      WHEN 'I'.
        IF func_mod_param-optional <> 'X' AND NOT
          ( func_mod_param-parameter = 'IS_CUSTOMER' AND
            func_mod_param-structure = 'SCUSTOM'  OR
          func_mod_param-parameter = 'IE_COLOR'  AND
            func_mod_param-structure = 'TDBTYPE' ).
          RAISE not_suitable.
        ENDIF.
      WHEN 'T'.
        IF NOT
           ( func_mod_param-parameter = 'IT_BOOKINGS' AND
             func_mod_param-structure = 'TY_BOOKINGS' ).
          RAISE not_suitable.
        ENDIF.
    ENDCASE.
  ENDLOOP.
ENDFUNCTION.
