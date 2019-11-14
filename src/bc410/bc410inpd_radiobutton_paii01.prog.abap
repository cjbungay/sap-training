*----------------------------------------------------------------------*
*   INCLUDE MBC410INPD_RADIOBUTTON_PAII01                              *
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  IF ok_code = 'EXIT'.
    WRITE semployes-salary TO salary CURRENCY semployes-currency.
    MESSAGE i555(bc410)
    WITH 'Vielen Dank! Ihr Gehalt von'(003)
         salary
         semployes-currency
         'wird an die Personalabteilung übertragen.'(004) .
    LEAVE PROGRAM.
  ENDIF.
ENDMODULE.                             " EXIT  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_100 INPUT.
  CASE ok_code.
    WHEN 'MODE'.
      semployes-salary = semployes-salary * 70 / 100.
    WHEN 'SAVE'.
      WRITE semployes-salary TO salary CURRENCY semployes-currency.
      MESSAGE i555(bc410)
      WITH 'Vielen Dank! Ihr Gehalt von'(003)
           salary
           semployes-currency
           'wird an die Personalabteilung übertragen.'(004) .
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_100  INPUT
