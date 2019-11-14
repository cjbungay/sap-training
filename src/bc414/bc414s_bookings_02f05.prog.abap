*----------------------------------------------------------------------*
*   INCLUDE BC414S_BOOKINGS_02F05
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  CONVERT_TO_LOC_CURRENCY
*&---------------------------------------------------------------------*
*      -->P_WA_SBOOK  text
*----------------------------------------------------------------------*
FORM convert_to_loc_currency USING p_wa_sbook TYPE sbook.
  SELECT SINGLE currcode FROM scarr INTO p_wa_sbook-loccurkey
         WHERE carrid = p_wa_sbook-carrid.
  CALL FUNCTION 'CONVERT_TO_LOCAL_CURRENCY'
       EXPORTING
            client           = sy-mandt
            date             = sy-datum
            foreign_amount   = p_wa_sbook-forcuram
            foreign_currency = p_wa_sbook-forcurkey
            local_currency   = p_wa_sbook-loccurkey
       IMPORTING
            local_amount     = p_wa_sbook-loccuram
       EXCEPTIONS
            no_rate_found    = 1
            overflow         = 2
            no_factors_found = 3
            no_spread_found  = 4
            derived_2_times  = 5
            OTHERS           = 6.
  IF sy-subrc <> 0.
    MESSAGE e080 WITH sy-subrc.
  ENDIF.
ENDFORM.                               " CONVERT_TO_LOC_CURRENCY
