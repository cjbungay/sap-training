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
  SET TITLEBAR 'TITLE_100'.

ENDMODULE.                             " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.

  SET PF-STATUS 'STATUS_200'.
  SET TITLEBAR 'TITLE_200' WITH sdyn_conn-carrid sdyn_conn-connid.

ENDMODULE.                             " STATUS_0200  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  TRANS_TO_200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE trans_to_200 OUTPUT.
  MOVE-CORRESPONDING wa_spfli TO sdyn_conn.
ENDMODULE.                             " TRANS_TO_200  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0300  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0300 OUTPUT.
  SET PF-STATUS 'STATUS_300'.
  SET TITLEBAR 'TITLE_300'.

ENDMODULE.                             " STATUS_0300  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  SET_ICON  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_icon OUTPUT.

  IF wa_spfli-countryfr ne wa_spfli-countryto.
    icon_name = 'ICON_CHECKED'.
  ELSE.
    icon_name = 'ICON_INCOMPLETE'.
  ENDIF.

  CALL FUNCTION 'ICON_CREATE'
       EXPORTING
            name                  = icon_name
*           TEXT                  = ' '
*           INFO                  = ' '
*           ADD_STDINF            = 'X'
      IMPORTING
           result                =  icon1
*      EXCEPTIONS
*           ICON_NOT_FOUND        = 1
*           OUTPUTFIELD_TOO_SHORT = 2
*           OTHERS                = 3
            .
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  IF wa_spfli-distance ge 1000.
    icon_name = 'ICON_CHECKED'.
  ELSE.
    icon_name = 'ICON_INCOMPLETE'.
  ENDIF.

  CALL FUNCTION 'ICON_CREATE'
       EXPORTING
            name                  = icon_name
*           TEXT                  = ' '
*           INFO                  = ' '
*           ADD_STDINF            = 'X'
      IMPORTING
           result                =  icon2
*      EXCEPTIONS
*           ICON_NOT_FOUND        = 1
*           OUTPUTFIELD_TOO_SHORT = 2
*           OTHERS                = 3
            .
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDMODULE.                             " SET_ICON  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  clear_ok_code  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  clear ok_code.
ENDMODULE.                             " clear_ok_code  OUTPUT
