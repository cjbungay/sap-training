*&---------------------------------------------------------------------*
*& Report  SAPBC408OTHD_REP_REP
*&
*&---------------------------------------------------------------------*
*&
*& Demonstration of the REPORT REPORT INTERFACE
*&
*& Demo der Berichts-Berichts-Schnittstelle
*&
*&---------------------------------------------------------------------*

REPORT  sapbc408othd_rep_rep.

* work area and internal table for ALV data
DATA: wa_sflight TYPE sflight,
      it_sflight LIKE TABLE OF wa_sflight.
DATA  ok_code    LIKE sy-ucomm.

DATA: cont       TYPE REF TO cl_gui_custom_container,
      alv        TYPE REF TO cl_gui_alv_grid.


SELECT-OPTIONS: so_car FOR wa_sflight-carrid,
                so_con FOR wa_sflight-connid.


************************************************************************
*ABAP events
************************************************************************
START-OF-SELECTION.
  SELECT * FROM sflight
    INTO TABLE it_sflight
    WHERE carrid IN so_car
    AND   connid IN so_con.
  CALL SCREEN 100.

************************************************************************
*PBO modules
************************************************************************
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT

*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYN'.
  SET TITLEBAR 'T1'.
ENDMODULE.                 " STATUS_0100  OUTPUT

*----------------------------------------------------------------------*
MODULE create_and_transfer OUTPUT.
  CHECK cont IS INITIAL.
  CREATE OBJECT cont
    EXPORTING
      container_name              = 'MY_CONTROL_AREA'
    EXCEPTIONS
      OTHERS                      = 1.

  IF sy-subrc <> 0.
    MESSAGE a010(bc405_408).
  ENDIF.

  CREATE OBJECT alv
    EXPORTING
      i_parent          = cont
    EXCEPTIONS
      OTHERS            = 1.

  IF sy-subrc <> 0.
    MESSAGE a010(bc405_408).
  ENDIF.


* REPORT REPORT INTERFACE
  DATA:
    rep_rep TYPE lvc_s_rprp,
    it_fieldcatalog TYPE lvc_t_fcat,
    wa_fieldcatalog LIKE LINE OF it_fieldcatalog.

* build field catalog to determine which columns should be passed on the
* report that is called
  wa_fieldcatalog-fieldname = 'CARRID'.
  wa_fieldcatalog-reprep = 'X'.
  APPEND wa_fieldcatalog TO it_fieldcatalog.

  wa_fieldcatalog-fieldname = 'CONNID'.
  wa_fieldcatalog-reprep = 'X'.
  APPEND wa_fieldcatalog TO it_fieldcatalog.


* make the sender known -> this will activate the report report
* interface and display an additional pushbutton

* It is important to bear in mind that calling a report via the report
* report interface does not trigger PAI for the ALV. As a consequence,
* if a transaction is called that changes data, the ALV will by default
* still show the old (unchanged) data.
  rep_rep-s_rprp_id-tool = 'RT'.
*rep_rep-S_RPRP_ID-APPL
*rep_rep-S_RPRP_ID-SUBC
  rep_rep-s_rprp_id-onam = sy-cprog.

  CALL METHOD alv->activate_reprep_interface
    EXPORTING
      is_reprep = rep_rep
    EXCEPTIONS
      OTHERS    = 1.

* The following entries are required in table TRSTI in order to
* determine which report(s)/transaction(s) should be called:
*MANDT  STOOL FCCLS SOTYP SONAM
*800  RT  9 1 SAPBC408OTHD_REP_REP
*
*SERNER  RTOOL  ROTYP RONAM
*0001     TR    1 SAPBC408_TC1


  CALL METHOD alv->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SFLIGHT'
    CHANGING
      it_outtab        = it_sflight
      it_fieldcatalog  = it_fieldcatalog
    EXCEPTIONS
      OTHERS           = 1.

  IF sy-subrc <> 0.
    MESSAGE a012(bc405_408).
  ENDIF.
ENDMODULE.                 " create_and_transfer  OUTPUT

************************************************************************
*PAI modules
************************************************************************
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      PERFORM free.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT


************************************************************************
*Form routines
************************************************************************
FORM free.
  CALL METHOD: alv->free,
               cont->free.
  FREE: alv,
        cont.
ENDFORM.                    " free
