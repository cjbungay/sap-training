*&---------------------------------------------------------------------*
*& Include BC405_ARCD_CREATETOP                              Report SAPBC405_ARCD_CREATE
*&
*&---------------------------------------------------------------------*

REPORT   sapbc405_arcd_create.

* Type for row of internal table
TYPES: BEGIN OF tt_book.
        INCLUDE STRUCTURE sbook.
TYPES: END OF tt_book.
* internal table
DATA: it_book TYPE TABLE OF tt_book,
* work area
      wa_book LIKE LINE OF it_book.
* reference for ALV object
DATA: gr_alv TYPE REF TO cl_salv_table.
* reference for custom container
DATA: gr_cont TYPE REF TO cl_gui_custom_container.
* values for selection-screen
DATA: date_from TYPE d,
      date_to TYPE d.
* switch for list display
DATA: list_display TYPE sap_bool.
* OK-Code of dynpro
DATA: ok_code LIKE sy-ucomm.
* reference for exception
DATA: gd_salv_msg TYPE REF TO cx_salv_msg.


* Selection screen
SELECTION-SCREEN BEGIN OF BLOCK bks WITH FRAME TITLE text-bks.
SELECT-OPTIONS: so_car FOR wa_book-carrid MEMORY ID car,
                so_con FOR wa_book-connid MEMORY ID con,
                so_date FOR wa_book-fldate DEFAULT date_from TO date_to.
SELECTION-SCREEN END OF BLOCK bks.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK dis WITH FRAME TITLE text-dis.
PARAMETERS: pa_full RADIOBUTTON GROUP disp DEFAULT 'X',
            pa_cont RADIOBUTTON GROUP disp,
            pa_list RADIOBUTTON GROUP disp.
SELECTION-SCREEN END OF BLOCK dis.
