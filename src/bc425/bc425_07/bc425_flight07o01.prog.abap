*&---------------------------------------------------------------------*
*&      Module  INITIALIZE  OUTPUT
*&---------------------------------------------------------------------*
*       Initialize table SFLIGHT and field OKCODE                      *
*----------------------------------------------------------------------*
MODULE initialize OUTPUT.
  CLEAR: sflight07, ok_code.
ENDMODULE.                             " INITIALIZE  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  DATA_FOR_SUBSCREEN  OUTPUT
*&---------------------------------------------------------------------*
*       Enable customer to move SFLIGHT work area to X-function group  *
*----------------------------------------------------------------------*
MODULE data_for_subscreen OUTPUT.
  CALL CUSTOMER-FUNCTION '003'
    EXPORTING
        flight     = sflight07
    EXCEPTIONS
        reserved   = 01.
ENDMODULE.                             " DATA_FOR_SUBSCREEN  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       Set Titlebar and Status for Screen 0100
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  CLEAR: wa_excl_tab,
         g_excl_tab.
  MOVE '+EXT' TO wa_excl_tab.
  APPEND wa_excl_tab TO g_excl_tab.
  MOVE 'SAVE' TO wa_excl_tab.
  APPEND wa_excl_tab TO g_excl_tab.

  SET PF-STATUS 'BASE' EXCLUDING g_excl_tab.
  SET TITLEBAR '100'.

ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       Set Titlebar and Status for Screen 0200
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.

  CLEAR: wa_excl_tab,
         g_excl_tab.
  MOVE 'MORE' TO wa_excl_tab.
  APPEND wa_excl_tab TO g_excl_tab.

  SET PF-STATUS 'BASE' EXCLUDING g_excl_tab.
  SET TITLEBAR '100'.

ENDMODULE.                             " STATUS_0200  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  LOCK_DATA  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module lock_data output.

CALL FUNCTION 'ENQUEUE_ESFLIGHT07'
    EXPORTING
         MODE_sflight07 = 'E'
         MANDT          = SY-MANDT
         CARRID         = sflight07-carrid
         CONNID         = sflight07-connid
         FLDATE         = sflight07-fldate
    EXCEPTIONS
         FOREIGN_LOCK   = 1
         SYSTEM_FAILURE = 2
         OTHERS         = 3
          .
IF sy-subrc <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

endmodule.                 " LOCK_DATA  OUTPUT

*** INCLUDE BC425_FLIGHT00O01
*** INCLUDE BC425_FLIGHT00O01
