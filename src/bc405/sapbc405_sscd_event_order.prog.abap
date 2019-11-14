*&---------------------------------------------------------------------*
*& Report  SAPBC405_SSCD_EVENT_ORDER                                   *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc405_sscd_event_order  MESSAGE-ID bc405    .

PARAMETERS field_1(5) TYPE c.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN BEGIN OF BLOCK bl_1 WITH FRAME TITLE text-001.
PARAMETERS field_b1(5) TYPE c.
SELECTION-SCREEN BEGIN OF BLOCK bl_2 WITH FRAME TITLE text-002.
PARAMETERS field_b2(5) TYPE c.
SELECTION-SCREEN BEGIN OF BLOCK bl_3 WITH FRAME TITLE text-003.
PARAMETERS field_b3(5) TYPE c.
SELECTION-SCREEN END OF BLOCK bl_3.
SELECTION-SCREEN END OF BLOCK bl_2.
SELECTION-SCREEN END OF BLOCK bl_1.
SELECTION-SCREEN SKIP.
PARAMETERS field_2(5) TYPE c OBLIGATORY.

************************************************************************
*  EVENTS
************************************************************************


AT SELECTION-SCREEN.
  MESSAGE i007.

AT SELECTION-SCREEN ON field_1.
  IF field_1 = 'ERROR'.
    MESSAGE e008.
  ENDIF.
  MESSAGE i008.

AT SELECTION-SCREEN ON BLOCK bl_3.
  IF field_b3 = 'ERROR'.
    MESSAGE e010.
  ENDIF.
  MESSAGE i010.

AT SELECTION-SCREEN ON BLOCK bl_2.
  IF field_b2 = 'ERROR'.
    MESSAGE e011.
  ENDIF.
  MESSAGE i011.

AT SELECTION-SCREEN ON BLOCK bl_1.
  IF field_b1 = 'ERROR'.
    MESSAGE e012.
  ENDIF.
  MESSAGE i012.

AT SELECTION-SCREEN ON field_2.
  IF field_2 = 'ERROR'.
    MESSAGE e012.
  ENDIF.
  MESSAGE i013.
