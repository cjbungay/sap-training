*&---------------------------------------------------------------------*
*& Report  RSTXCDM1                                                    *
*&---------------------------------------------------------------------*
*& Demoprogramm zum Formulardruck für Kurs CA930                       *
*&---------------------------------------------------------------------*
REPORT  rstxexp1.

TABLES: rstxd, rsscf.
DATA   fcode LIKE sy-ucomm.

SET SCREEN '0100'.

*----------------------------------------------------------------------*
FORM display_form.

* Open print job
  CALL FUNCTION 'OPEN_FORM'
    EXPORTING
      device   = 'PRINTER'
      form     = rsscf-tdform
      dialog   = 'X'
    EXCEPTIONS
      canceled = 1
      device   = 2
      form     = 3
      OPTIONS  = 4
      unclosed = 5
      OTHERS   = 6.
  IF sy-subrc <> 0.
    WRITE 'Error in open_form'(001).
    EXIT.
  ENDIF.

  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'INTRODUCTION'
    EXCEPTIONS
      OTHERS  = 1.
  IF sy-subrc NE 0.
*
  ENDIF.

  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'ITEMS'
    EXCEPTIONS
      OTHERS  = 1.
  IF sy-subrc NE 0.
*
  ENDIF.

  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'CLOSING_REMARK'
    EXCEPTIONS
      OTHERS  = 1.
  IF sy-subrc NE 0.
*
  ENDIF.

* close print job
  CALL FUNCTION 'CLOSE_FORM'
    EXCEPTIONS
      OTHERS = 1.
  IF sy-subrc NE 0.
*
  ENDIF.
ENDFORM.                    "DISPLAY_FORM

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  DATA tabpos(6) TYPE c.
  SET PF-STATUS 'MAIN'.
  SET TITLEBAR '100'.
  GET PARAMETER ID 'TTX' FIELD rstxd-tdform.
  GET PARAMETER ID 'TTXTDSTYLE' FIELD rstxd-tdstyle.
  GET PARAMETER ID 'TTXTDPARGRAPH' FIELD rstxd-tdpargraph.
  GET PARAMETER ID 'TTXTDTABPOS' FIELD tabpos.
  MOVE tabpos TO rstxd-tdtabpos.
  GET PARAMETER ID 'TTXTDTABPOSU' FIELD rstxd-tdtabposu.
  GET PARAMETER ID 'TTXTDSTRING' FIELD rstxd-tdstring.
  GET PARAMETER ID 'TTXTDFORM' FIELD rstxd-tdform.
  GET PARAMETER ID 'TTXTDPAGE' FIELD rstxd-tdpage.
  GET PARAMETER ID 'TTXTDWINDOW' FIELD rstxd-tdwindow.
  GET PARAMETER ID 'TTXTDPOSITION' FIELD rstxd-tdposition.
  GET PARAMETER ID 'TTXTDSPRAS' FIELD rstxd-tdspras.
  GET PARAMETER ID 'TTXTDSPRAS2' FIELD rstxd-tdspras2.

  IF rstxd-tdform IS INITIAL.
    rsscf-tdform = 'SAPBC460D_FM_03'.
  ELSE.
    rsscf-tdform = rstxd-tdform.
  ENDIF.

ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA fcode_old LIKE fcode.
  fcode_old = fcode.
  CLEAR fcode.
  CASE fcode_old.
    WHEN 'PREV'.
      PERFORM display_form.
      rstxd-tdform = rsscf-tdform.
      SET PARAMETER ID 'TTX' FIELD rstxd-tdform.
      SET PARAMETER ID 'TTXTDSTYLE' FIELD rstxd-tdstyle.
      SET PARAMETER ID 'TTXTDPARGRAPH' FIELD rstxd-tdpargraph.
      SET PARAMETER ID 'TTXTDTABPOS' FIELD tabpos.
      MOVE tabpos TO rstxd-tdtabpos.
      SET PARAMETER ID 'TTXTDTABPOSU' FIELD rstxd-tdtabposu.
      SET PARAMETER ID 'TTXTDSTRING' FIELD rstxd-tdstring.
      SET PARAMETER ID 'TTXTDFORM' FIELD rstxd-tdform.
      SET PARAMETER ID 'TTXTDPAGE' FIELD rstxd-tdpage.
      SET PARAMETER ID 'TTXTDWINDOW' FIELD rstxd-tdwindow.
      SET PARAMETER ID 'TTXTDPOSITION' FIELD rstxd-tdposition.
      SET PARAMETER ID 'TTXTDSPRAS' FIELD rstxd-tdspras.
      SET PARAMETER ID 'TTXTDSPRAS2' FIELD rstxd-tdspras2.

    WHEN 'BACK'.
      SET SCREEN 0. LEAVE SCREEN.
    WHEN 'END'.
      SET SCREEN 0. LEAVE SCREEN.
    WHEN 'CANC'.
      SET SCREEN 0. LEAVE SCREEN.
    WHEN OTHERS.
      rstxd-tdform = rsscf-tdform.
      SET PARAMETER ID 'TTX' FIELD rstxd-tdform.
      SET PARAMETER ID 'TTXTDSTYLE' FIELD rstxd-tdstyle.
      SET PARAMETER ID 'TTXTDPARGRAPH' FIELD rstxd-tdpargraph.
      SET PARAMETER ID 'TTXTDTABPOS' FIELD tabpos.
      MOVE tabpos TO rstxd-tdtabpos.
      SET PARAMETER ID 'TTXTDTABPOSU' FIELD rstxd-tdtabposu.
      SET PARAMETER ID 'TTXTDSTRING' FIELD rstxd-tdstring.
      SET PARAMETER ID 'TTXTDFORM' FIELD rstxd-tdform.
      SET PARAMETER ID 'TTXTDPAGE' FIELD rstxd-tdpage.
      SET PARAMETER ID 'TTXTDWINDOW' FIELD rstxd-tdwindow.
      SET PARAMETER ID 'TTXTDPOSITION' FIELD rstxd-tdposition.
      SET PARAMETER ID 'TTXTDSPRAS' FIELD rstxd-tdspras.
      SET PARAMETER ID 'TTXTDSPRAS2' FIELD rstxd-tdspras2.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT
