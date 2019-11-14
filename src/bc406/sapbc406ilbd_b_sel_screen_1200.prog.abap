*&---------------------------------------------------------------------*
*& Report  SAPBC406ILBD_B_SEL_SCREEN_1200                              *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT sapbc406ilbd_simple_list_t20      .

DATA: wa_spfli TYPE spfli,
      it_spfli LIKE TABLE OF wa_spfli.

* Selektionsbild 1200
* Selection screen 1200
SELECTION-SCREEN BEGIN OF SCREEN 1200.

SELECTION-SCREEN BEGIN OF BLOCK connection WITH FRAME TITLE text-s01.

SELECT-OPTIONS so_carr FOR wa_spfli-carrid.
PARAMETER pa_citfr TYPE spfli-cityfrom OBLIGATORY.

SELECTION-SCREEN END OF BLOCK connection.

SELECTION-SCREEN END OF SCREEN 1200.

* Selektionsbild aufrufen
* Calling the selection screen
CALL SELECTION-SCREEN 1200.

* Returncode abfragen
* Testing the return code
IF sy-subrc = 0.

  PERFORM read_connections.
  SORT it_spfli BY carrid connid.
  PERFORM display_connections.

ELSE.

  LEAVE PROGRAM.

ENDIF.

*&---------------------------------------------------------------------*
*&      Form  READ_CONNECTIONS
*&---------------------------------------------------------------------*
FORM read_connections.

  SELECT * INTO TABLE it_spfli FROM spfli
    WHERE carrid IN so_carr
      AND cityfrom = pa_citfr.

ENDFORM.                               " READ_CONNECTIONS

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_CONNECTIONS
*&---------------------------------------------------------------------*

FORM display_connections.

  LOOP AT it_spfli INTO wa_spfli.

    WRITE: / wa_spfli-carrid,
             wa_spfli-connid,
             wa_spfli-cityfrom,
             wa_spfli-cityto,
             wa_spfli-deptime,
             wa_spfli-arrtime.

  ENDLOOP.

ENDFORM.                               " DISPLAY_CONNECTIONS
