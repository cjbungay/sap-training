*----------------------------------------------------------------------*
***INCLUDE BC410INPD_TEMPLATEF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SHL_IF_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM shl_if_form                                    "#EC CALLED
      TABLES   record_tab STRUCTURE seahlpres
      CHANGING shlp TYPE shlp_descr_t
               callcontrol LIKE ddshf4ctrl.
   DATA: interface LIKE LINE OF shlp-interface.
   interface-valtabname = 'SDYN_CONN00'.
   interface-valfield = 'CONNID'.
   MODIFY shlp-interface FROM interface
          TRANSPORTING valtabname valfield
           WHERE shlpfield = 'CONNID'.
   interface-valfield = 'CARRID'.
   MODIFY shlp-interface FROM interface
          TRANSPORTING valtabname valfield
          WHERE shlpfield = 'CARRID'.
   interface-valfield = 'FLDATE'.
   MODIFY shlp-interface FROM interface
          TRANSPORTING valtabname valfield
          WHERE shlpfield = 'FLDATE'.
ENDFORM.
