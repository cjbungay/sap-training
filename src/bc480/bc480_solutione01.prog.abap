*&---------------------------------------------------------------------*
*&  Include           BC480_SOLUTIONE01
*&---------------------------------------------------------------------*
**********************************************************************
INITIALIZATION.
* SAP memory parameters
  GET PARAMETER ID 'FPWBFORM' FIELD pa_form.
  IF pa_form IS INITIAL.
    pa_form = 'BC480'.
  ENDIF.


  GET PARAMETER ID 'LANGUAGE' FIELD pa_lang.                "#EC EXISTS
  IF sy-subrc <> 0. "first call
    pa_lang = sy-langu.
  ENDIF.

  GET PARAMETER ID 'LND' FIELD pa_cntry.
  IF sy-subrc <> 0. "first call
    CASE sy-langu.
      WHEN 'D'.
        pa_cntry = 'DE'.
      WHEN 'E'.
        pa_cntry = 'US'.
      WHEN 'F'.
        pa_cntry = 'FR'.
      WHEN OTHERS.
        pa_lang = 'E'.
        pa_cntry = 'US'.
    ENDCASE.
  ENDIF.


  GET PARAMETER ID 'GRAPHIC_FROM_URL' FIELD pa_url.         "#EC EXISTS
  IF sy-subrc <> 0. "first call
    pa_url = c_intranet.
  ENDIF.


* Which parameter should have the dropdown list?
  field_for_dropdown  = 'PA_URL'.

* Fill two-column dropdown list
  gs_values-key  = c_intranet.
  gs_values-text = 'Image from intranet'(se7).
  APPEND gs_values TO gt_values.

  gs_values-key  = c_internet.
  gs_values-text = 'Image from Internet'(se8).
  APPEND gs_values TO gt_values.

* Pass information to function module
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = field_for_dropdown
      values = gt_values.


**********************************************************************
AT SELECTION-SCREEN ON pa_form.
  SELECT SINGLE name
    FROM fpcontext
    INTO pa_form
    WHERE name = pa_form AND
          state = 'A'.
  CHECK sy-subrc <> 0.
  MESSAGE e004 WITH pa_form.
*   No active form &1 available


AT SELECTION-SCREEN ON block country.
  SELECT SINGLE land1
    FROM t005
    INTO pa_cntry
    WHERE land1 = pa_cntry AND
          spras = pa_lang.
  IF sy-dbcnt <> 1.
    MESSAGE e022 WITH pa_lang.
  ENDIF.
