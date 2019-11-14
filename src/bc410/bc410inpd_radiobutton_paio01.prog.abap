*----------------------------------------------------------------------*
*   INCLUDE MBC410INPD_RADIOBUTTON_PAIO01                              *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  INIT  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init OUTPUT.
  IF NOT radio1 IS INITIAL.
    text1 = 'Ich verzichte zugunsten der Firma auf 30% Gehalt.'(001).
    text2 = 'Ich möchte 10% Gehaltserhöhung.'(002).
  ENDIF.
  IF NOT radio2 IS INITIAL.
    text2 = 'Ich verzichte zugunsten der Firma auf 30% Gehalt.'(001).
    text1 = 'Ich möchte 10% Gehaltserhöhung.'(002).
  ENDIF.
ENDMODULE.                             " INIT  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  SET_STATUS_100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_status_100 OUTPUT.
  SET PF-STATUS 'DYNPRO'.
  SET TITLEBAR 'RETURN'.
ENDMODULE.                             " SET_STATUS_100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  clear_ok_code  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                             " clear_ok_code  OUTPUT
