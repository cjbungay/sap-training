*----------------------------------------------------------------------*
*   INCLUDE BC414T_BOOKINGS_01F04
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  SAVE_MODIFIED_BOOKING
*&---------------------------------------------------------------------*
FORM save_modified_booking.
************************************************************************
* a) Modify data on DB tables SBOOK and SFLIGHT by calling appropriate
*    function modules in correct sequence in order to map the SAP-LUW on
*    one DB-LUW
* b) Handle exceptions (use messages 034, 044, 045, 046, 048)
************************************************************************
ENDFORM.                               "SAVE_MODIFIED_BOOKING

*&---------------------------------------------------------------------*
*&      Form  SAVE_NEW_BOOKING
*&---------------------------------------------------------------------*
FORM save_new_booking.
************************ To be implemented later ***********************
endform.
