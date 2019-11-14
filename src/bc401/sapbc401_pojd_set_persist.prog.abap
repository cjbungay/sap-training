*&---------------------------------------------------------------------*
*& Report  SAPBC401_POJD_SET_PERSIST                                   *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc401_pojd_set_persist        .

DATA:
  ref_carrier       TYPE REF TO cl_bc401_pojd_carrier,
  ref_carrier_agent TYPE REF TO ca_bc401_pojd_carrier.

PARAMETERS:
  pa_carr TYPE scarr-carrid,
  pa_name TYPE scarr-carrname,
  pa_curr TYPE scarr-currcode,
  pa_url  TYPE scarr-url.

DATA carrid TYPE scarr-carrid.



AT SELECTION-SCREEN.
  SELECT SINGLE carrid FROM scarr
                       INTO carrid
                       WHERE carrid = pa_carr.
  IF sy-subrc = 0.
    MESSAGE e210(bc401) WITH carrid.
  ENDIF.



START-OF-SELECTION.

* get agent instance:
  ref_carrier_agent = ca_bc401_pojd_carrier=>agent.

* create carrier instance:
  TRY.

      CALL METHOD ref_carrier_agent->create_persistent
        EXPORTING
          i_carrid   = pa_carr
          i_carrname = pa_name
          i_currcode = pa_curr
          i_url      = pa_url
        RECEIVING
          result     = ref_carrier.

    CATCH cx_os_object_existing .
      MESSAGE a210(bc401) WITH pa_carr.
  ENDTRY.


* "work" with instance:
  CALL METHOD ref_carrier->display_attributes.
  ULINE.

* write instance to database:
  COMMIT WORK.
