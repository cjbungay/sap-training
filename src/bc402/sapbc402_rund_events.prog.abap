*&---------------------------------------------------------------------*
*& Report  SAPBC402_RUND_EVENTS                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& sends two selection screens, one basic list and drill down lists    *
*&---------------------------------------------------------------------*

REPORT sapbc402_rund_events MESSAGE-ID bc402
                            LINE-COUNT 10(1) NO STANDARD PAGE HEADING.

CONSTANTS c_mark VALUE 'X'.

PARAMETERS:
  p_dynnr LIKE sy-dynnr,
  p_mark_l AS CHECKBOX,
  p_mark_i AS CHECKBOX,
  p_mark_o AS CHECKBOX.

SELECTION-SCREEN BEGIN OF SCREEN 2000.
PARAMETERS:
  p_dynnra LIKE sy-dynnr,
  p_markla AS CHECKBOX,
  p_markia AS CHECKBOX,
  p_markoa AS CHECKBOX.
SELECTION-SCREEN END OF SCREEN 2000.




LOAD-OF-PROGRAM.
*  MESSAGE i025 WITH 'LOAD-OF-PROGRAM'.  " not displayed
  p_mark_l = c_mark.
*  WRITE: / 'LOAD-OF-PROGRAM'.



INITIALIZATION.
*  MESSAGE i025 WITH 'INITIALIZATION'.   " not displayed
p_mark_i = c_mark.
*  WRITE: / 'INITIALIZATION'.            " not written into list buffer



AT SELECTION-SCREEN OUTPUT.
  MESSAGE i025
    WITH 'AT SELECTION-SCREEN OUTPUT'.  " event, look up docu!
  p_mark_o = c_mark.
  IF sy-dynnr = 1000.
    p_dynnr = sy-dynnr.
  ELSE.
    p_dynnra = sy-dynnr.
    p_markla = p_mark_l.
    p_markia = p_mark_i.
    p_markoa = p_mark_o.   " to show which events were raised again
  ENDIF.
*  WRITE: / 'AT SELECTION-SCREEN OUTPUT'. " not written into list buffer




AT SELECTION-SCREEN.
  MESSAGE i025 WITH 'AT SELECTION-SCREEN'.  " event
  IF sy-dynnr = 1000 AND
     ( p_mark_l = c_mark OR p_mark_i = c_mark OR p_mark_o = c_mark ).
    MESSAGE e888(bc402). " to see which events will be raised again
  ENDIF.
*  WRITE: / 'AT SELECTION-SCREEN'.        " not written into list buffer



START-OF-SELECTION.
  MESSAGE i025 WITH 'START-OF-SELECTION'.  " event
  DO 10 TIMES.
    WRITE: /  sy-index,  'START-OF-SELECTION'.
  ENDDO.

TOP-OF-PAGE.
  MESSAGE i025 WITH 'TOP-OF-PAGE'.         " event
  WRITE: / 'TOP-OF-PAGE', 'sy-lsind:', sy-lsind.

END-OF-PAGE.
  MESSAGE i025 WITH 'END-OF-PAGE'.         " event
  WRITE: / 'END-OF-PAGE'.



END-OF-SELECTION.
  MESSAGE i025 WITH 'END-OF-SELECTION'.    " event
  DO 10 TIMES.
    WRITE: / sy-index,  'END-OF-SELECTION'.
  ENDDO.



AT LINE-SELECTION.
  MESSAGE i025 WITH 'AT LINE-SELECTION'.  " event
  CALL SELECTION-SCREEN '2000'.
  CHECK sy-subrc = 0.
  DO 10 TIMES.
    WRITE: / sy-index,  'AT LINE-SELECTION'.
  ENDDO.

TOP-OF-PAGE DURING LINE-SELECTION.
  MESSAGE i025  WITH 'TOP-OF-PAGE DURING LINE-SELECTION'.  " event
  WRITE: / 'TOP-OF-PAGE DURING LINE-SELECTION', 'sy-lsind:', sy-lsind.
