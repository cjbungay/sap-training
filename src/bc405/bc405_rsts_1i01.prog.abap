*---------------------------------------
***INCLUDE BC405_ARCS_3I01 .
*---------------------------------------
*&--------------------------------------
*&      Module  USER_COMMAND_0100  INPUT
*&--------------------------------------
*       text
*---------------------------------------
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE. " USER_COMMAND_0100  INPUT
