*&---------------------------------------------------------------------*
*& Report  SAPBC401_POJD_GET_PERSIST                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc401_pojd_get_persist     .

DATA:
  ref_carrier       TYPE REF TO cl_bc401_pojd_carrier,
  ref_carrier_agent TYPE REF TO ca_bc401_pojd_carrier.

PARAMETERS pa_carr TYPE scarr-carrid.

DATA carrid TYPE scarr-carrid.



AT SELECTION-SCREEN.
  SELECT SINGLE carrid FROM scarr
                       INTO carrid
                       WHERE carrid = pa_carr.
  IF sy-subrc <> 0.
    MESSAGE e211(bc401) WITH pa_carr.
  ENDIF.



START-OF-SELECTION.

* get agent instance:
  ref_carrier_agent = ca_bc401_pojd_carrier=>agent.

* retrieve carrier instance from database:
  TRY.

      CALL METHOD ref_carrier_agent->get_persistent
        EXPORTING
          i_carrid = pa_carr
        RECEIVING
          result   = ref_carrier.

    CATCH cx_os_object_not_found .
      MESSAGE a211(bc401) WITH pa_carr.
  ENDTRY.


* "work" with instance:
  CALL METHOD ref_carrier->display_attributes.
  ULINE.
