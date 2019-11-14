*&---------------------------------------------------------------------*
*& Report  SAPBC405_SSCD_PBO                                           *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  The selection screen of a logical database is changed              *
*&    dynamically at the event AT SELECTON-SCREEN OUTPUT               *
*&     (process before output of the selection screen )                *
*&---------------------------------------------------------------------*

INCLUDE bc405_sscd_pbotop.

AT SELECTION-SCREEN OUTPUT.
* Texts of push buttons
  CONCATENATE icon_expand 'expandieren'(001)   INTO e_button.
  CONCATENATE icon_collapse 'komprimieren'(002) INTO c_button.


  CASE save_ok_code.
    WHEN 'COMPRESS'.
* Modify screen objects dynamically via LOOP AT SCREEN
* ---> select-options become invisible
      LOOP AT SCREEN.
        CASE screen-name.
* Select-option BOOKID
   WHEN '%_BOOKID_%_APP_%-TEXT'.       screen-active = 0. MODIFY SCREEN.
   WHEN 'BOOKID-LOW'.                  screen-active = 0. MODIFY SCREEN.
   WHEN 'BOOKID-HIGH'.                 screen-active = 0. MODIFY SCREEN.
   WHEN '%_BOOKID_%_APP_%-VALU_PUSH'.  screen-active = 0. MODIFY SCREEN.
   WHEN '%_BOOKID_%_APP_%-OPTI_PUSH'.  screen-active = 0. MODIFY SCREEN.

* Select-option SO_ODATE
   WHEN '%_SO_ODATE_%_APP_%-TEXT'.     screen-active = 0. MODIFY SCREEN.
   WHEN 'SO_ODATE-LOW'.                screen-active = 0. MODIFY SCREEN.
   WHEN 'SO_ODATE-HIGH'.               screen-active = 0. MODIFY SCREEN.
   WHEN '%_SO_ODATE_%_APP_%-VALU_PUSH'.
         screen-active = 0. MODIFY SCREEN.
   WHEN '%_SO_ODATE_%_APP_%-OPTI_PUSH'.
         screen-active = 0. MODIFY SCREEN.

*  Pushbutton
   WHEN 'C_BUTTON'.                    screen-active = 0. MODIFY SCREEN.
        ENDCASE.
      ENDLOOP.

    WHEN 'EXPAND'.
* Modify screen objects dynamically via LOOP AT SCREEN
* ---> select-options become visible
      LOOP AT SCREEN.
        CASE screen-name.
* Select-option BOOKID
    WHEN '%_BOOKID_%_APP_%-TEXT'.      screen-active = 1. MODIFY SCREEN.
    WHEN 'BOOKID-LOW'.                 screen-active = 1. MODIFY SCREEN.
    WHEN 'BOOKID-HIGH'.                screen-active = 1. MODIFY SCREEN.
    WHEN '%_BOOKID_%_APP_%-VALU_PUSH'. screen-active = 1. MODIFY SCREEN.
* Select-option SO_ODATE
    WHEN '%_SO_ODATE_%_APP_%-TEXT'.     screen-active = 1.MODIFY SCREEN.
    WHEN 'SO_ODATE-LOW'.                screen-active = 1.MODIFY SCREEN.
    WHEN 'SO_ODATE-HIGH'.               screen-active = 1.MODIFY SCREEN.
    WHEN '%_SO_ODATE_%_APP_%-VALU_PUSH'.screen-active = 1.MODIFY SCREEN.
*
    WHEN 'E_BUTTON'.                   screen-active = 0. MODIFY SCREEN.
    WHEN 'C_BUTTON'.                   screen-active = 1. MODIFY SCREEN.
        ENDCASE.
      ENDLOOP.

  ENDCASE.


AT SELECTION-SCREEN.
  IF  sscrfields-ucomm = 'EXP'.
    save_ok_code = 'EXPAND'.
  ELSE.
    save_ok_code = 'COMPRESS'.
  ENDIF.
