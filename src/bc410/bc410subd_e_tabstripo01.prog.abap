*----------------------------------------------------------------------*
***INCLUDE BC410D_TEMPLATE1O01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_100'.
*  SET TITLEBAR 'xxx'.

ENDMODULE.                             " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'STATUS_200'.
*  SET TITLEBAR 'xxx'.

ENDMODULE.                             " STATUS_0200  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  SET_DYNNR  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_dynnr OUTPUT.
  CASE my_tabstrip-activetab.
    WHEN 'FC1'.
      dynnr = '0101'.
    WHEN 'FC2'.
      dynnr = '0102'.
    WHEN 'FC3'.
      dynnr = '0103'.
    WHEN OTHERS.
      my_tabstrip-activetab = 'FC1'.
      dynnr = '0101'.
  ENDCASE.
ENDMODULE.                             " SET_DYNNR  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  EXPORT_DATA  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE export_data OUTPUT.
  CALL FUNCTION 'BC410SUBD_TRANSPORT_TO_GROUP'
       EXPORTING
            carrid = sdyn_conn-carrid
            connid = sdyn_conn-connid.

ENDMODULE.                             " EXPORT_DATA  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  TRANS_TO_200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE trans_to_200 OUTPUT.
  MOVE-CORRESPONDING wa_spfli TO sdyn_conn.
ENDMODULE.                             " TRANS_TO_200  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  clear_ok_code  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  clear ok_code.
ENDMODULE.                             " clear_ok_code  OUTPUT
