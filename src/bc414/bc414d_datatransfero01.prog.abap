*----------------------------------------------------------------------*
***INCLUDE BC414D_CALLTECHNIQUESO01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
   SET PF-STATUS '100_NORMAL'.
   SET TITLEBAR '100'.

ENDMODULE.                 " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  INIT_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE INIT_0100 OUTPUT.
 get parameter id 'CAR' field sflight-carrid.
 get parameter id 'CON' FIELD SFLIGHT-connid.
 if sflight-carrid is initial or sflight-connid is initial.
   sflight-carrid = 'LH'.
   sflight-connid = '0400'.
 endif.
ENDMODULE.                 " INIT_0100  OUTPUT
