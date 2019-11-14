*&---------------------------------------------------------------------*
*& Report  SAPBC406ILBD_A_SIMPLEST_LIST                                *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Einfachstes listenerzeugendes Programm                              *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT sapBC406ilbd_simple_list_t20      .

* Datendeklaration
* Data declaration
DATA: wa_spfli TYPE spfli,
      it_spfli LIKE TABLE OF wa_spfli.

* Standardselektionsbild 1000
* Standard selection-screen 1000
SELECT-OPTIONS so_carr FOR wa_spfli-carrid.

* Daten von der Datenbank lesen
* Read data from database
PERFORM read_connections.

* Sortieren der internen Tabelle
* Sorting the internal table
SORT it_spfli BY carrid connid.

* Listpuffer füllen
* Filling the list buffer
PERFORM display_connections.


*&---------------------------------------------------------------------*
*&      Form  READ_CONNECTIONS
*&---------------------------------------------------------------------*
*       Lesen von der Datenbank                                        *
*       Reading from database                                          *
*----------------------------------------------------------------------*
FORM read_connections.

  SELECT * INTO TABLE it_spfli FROM spfli
    WHERE carrid IN so_carr.

ENDFORM.                               " READ_CONNECTIONS

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_CONNECTIONS
*&---------------------------------------------------------------------*
*       Füllen des Listenpuffers                                       *
*       Filling the Listbuffer                                         *
*----------------------------------------------------------------------*

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
