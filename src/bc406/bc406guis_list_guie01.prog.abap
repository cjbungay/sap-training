*----------------------------------------------------------------------*
*   INCLUDE     SAPBC406GUIS_LIST_GUIE01                             *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&   Event INITIALIZATION
*&---------------------------------------------------------------------*
INITIALIZATION.
  tab1 =  text-tl1.
* Flight Connection
  tab2 =  text-tl2.
* Flight Date
  tab3 =  text-tl3.
* Flight Type

*&---------------------------------------------------------------------*
*&   Event AT SELECTION-SCREEN
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON pa_car.
  CASE sy-dynnr.
    WHEN '1000' OR '1100' OR '1200' OR '1300'.
      AUTHORITY-CHECK OBJECT 'S_CARRID'
               ID 'CARRID' FIELD pa_car
               ID 'ACTVT' FIELD '03'.
      IF sy-subrc NE 0.
        MESSAGE e001 WITH pa_car.
*   No authorization for airline carrier &
      ENDIF.
  ENDCASE.

AT SELECTION-SCREEN ON RADIOBUTTON GROUP rbg1.
  IF pa_nat = 'X'.
    CALL SELECTION-SCREEN 1400 STARTING AT 20 5 ENDING AT 70 10.
    IF sy-subrc NE 0.
      MESSAGE e060(bc406).
    ENDIF.
  ENDIF.

*&---------------------------------------------------------------------*
*&   Event AT START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM read_flights.

*&---------------------------------------------------------------------*
*&   Event AT END-OF-SELECTION
*&---------------------------------------------------------------------*
END-OF-SELECTION.
  PERFORM display_flights.

* set titlebar and gui-status as late as possible
  SET TITLEBAR 'T_BASE'.
  SET PF-STATUS 'S_BASE'.
  CLEAR: wa_flight-fldate.

*&---------------------------------------------------------------------*
*&   Event AT USER-COMMAND
*&---------------------------------------------------------------------*

AT USER-COMMAND.
  CASE sy-ucomm.
    WHEN 'BOOK'.
      CHECK NOT wa_flight-fldate IS INITIAL.
      REFRESH it_sbook.
      PERFORM read_bookings
             USING    wa_flight-carrid
                      wa_flight-connid
                      wa_flight-fldate
                      not_cancelled
             CHANGING it_sbook.


      SORT it_sbook BY carrid connid fldate bookid.

      PERFORM display_bookings.

      SET PF-STATUS 'S_BOOK'.
      SET TITLEBAR 'T_BOOK'.
      CLEAR: wa_flight-fldate.
  ENDCASE.

*&---------------------------------------------------------------------*
*&   Event TOP-OF-PAGE DURING LINE-SELECTION
*&---------------------------------------------------------------------*

TOP-OF-PAGE DURING LINE-SELECTION.
  CASE sy-ucomm.
    WHEN 'BOOK'.
      FORMAT COLOR COL_HEADING.
      ULINE.
      WRITE: / 'Flight:'(t01), wa_sbook-carrid, wa_sbook-connid,
                AT sy-linsz space,
             / 'Date:'(t02), wa_sbook-fldate, AT sy-linsz space.
      ULINE.
  ENDCASE.
