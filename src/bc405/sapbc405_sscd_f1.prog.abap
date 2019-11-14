*&---------------------------------------------------------------------*
*& Report  SAPBC405_SSCD_F1                                            *
*&                                                                     *
*&---------------------------------------------------------------------*
*&              Help request: F1 help                                  *
*&---------------------------------------------------------------------*

REPORT  SAPBC405_SSCD_F1.

NODES: SPFLI.

SELECT-OPTIONS: SO_DEPT FOR SPFLI-DEPTIME DEFAULT '080000' TO '220000'
                NO-EXTENSION.

* Default values for selecetion criteria of the logical database
  INITIALIZATION.
   MOVE 'LH' TO CARRID-LOW.
   MOVE 'I' TO CARRID-SIGN.
   MOVE 'EQ' TO CARRID-OPTION.
   APPEND CARRID.

   MOVE 'FRA' TO  airp_FR-low.
   MOVE 'I' TO airp_fr-SIGN.
   MOVE 'EQ' TO airp_fr-OPTION.
   APPEND airp_fr.


* Check of selection criterion SO_DEPT
  AT SELECTION-SCREEN ON SO_DEPT.
  IF ( SO_DEPT-LOW LT '060000' AND SO_DEPT-HIGH LT '060000' )
   OR ( SO_DEPT-LOW GE '220000' AND SO_DEPT-HIGH GE '220000' )
        AND airp_FR EQ 'FRA'.
     MESSAGE E002(bc405).
   ENDIF.

* Help request for SO_DEPT (F1 help)
AT SELECTION-SCREEN ON HELP-REQUEST FOR SO_DEPT.
 CALL SCREEN 100 STARTING AT 30 03
                 ENDING   AT 70 10.


 GET SPFLI.
   WRITE:       SPFLI-CARRID COLOR COL_HEADING NO-GAP,
                SPFLI-CONNID COLOR COL_HEADING,
            /20 SPFLI-CITYFROM COLOR COL_NORMAL INTENSIFIED ON,
                SPFLI-CITYTO   COLOR COL_NORMAL INTENSIFIED OFF,
          /(20) SPFLI-DEPTIME UNDER SPFLI-CITYFROM
                COLOR COL_NORMAL INTENSIFIED ON
                USING EDIT MASK '__:__',
           (20) SPFLI-ARRTIME UNDER SPFLI-CITYTO
                COLOR COL_NORMAL INTENSIFIED OFF
                USING EDIT MASK '__:__'.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'HELP'.
  SET TITLEBAR 'HELP'.

ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  BACK  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE BACK INPUT.
SET SCREEN 0.
ENDMODULE.                 " BACK  INPUT
