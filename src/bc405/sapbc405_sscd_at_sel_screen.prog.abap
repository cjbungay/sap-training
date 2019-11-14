*&---------------------------------------------------------------------*
*& Report  SAPBC405_SSCD_AT_SEL_SCREEN                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*&            Check of selection criteria                              *
*&                AT SELECTION-SCREEN ON                               *
*&---------------------------------------------------------------------*

REPORT sapbc405_sscd_at_sel_screen LINE-SIZE 83.          .

NODES: spfli.

SELECT-OPTIONS: so_dept FOR spfli-deptime DEFAULT '010000' TO '020000'
                NO-EXTENSION.

* Default values for selecetion criteria of the logical database
INITIALIZATION.
  MOVE 'LH' TO carrid-low.
  MOVE 'I' TO carrid-sign.
  MOVE 'EQ' TO carrid-option.
  APPEND carrid.

  MOVE 'FRA' TO  airp_fr-low.
  MOVE 'I' TO airp_fr-sign.
  MOVE 'EQ' TO airp_fr-option.
  APPEND airp_fr.


* Check of selection criterion SO_DEPT
AT SELECTION-SCREEN ON so_dept.
  IF    ( so_dept-low LT '060000' OR so_dept-high LT '060000' )
    OR  ( so_dept-low GE '220000' OR so_dept-high GE '220000' )
    AND airp_fr EQ 'FRA'.
    MESSAGE e002(bc405).
  ENDIF.

GET spfli.
  FORMAT COLOR COL_HEADING.
  WRITE: sy-vline, spfli-carrid,
         spfli-connid, 83 sy-vline..
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.
  WRITE: sy-vline, 20 spfli-cityfrom, spfli-cityto, 83 sy-vline.
  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  WRITE: sy-vline, spfli-deptime UNDER spfli-cityfrom
         USING EDIT MASK '__:__',
         spfli-arrtime UNDER spfli-cityto
         USING EDIT MASK '__:__', 83 sy-vline.

END-OF-SELECTION.
  ULINE.
