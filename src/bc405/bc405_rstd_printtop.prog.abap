*&---------------------------------------------------------------------*
*& Include BC405_ARCD_CREATETOP                              Report SAPBC405_ARCD_CREATE
*&
*&---------------------------------------------------------------------*

REPORT   sapbc405_arcd_create.

* color constants
TYPE-POOLS: col,
* icons constants
            icon.
* Type for row of internal table
TYPES: BEGIN OF tt_book.
        INCLUDE STRUCTURE sbook.
* additional fields
TYPES:   telephone TYPE s_phoneno, " scustom-telephone,
         country TYPE scustom-country,
         leaves_home,
         goes_home,
         invoice_icon TYPE icon-id,
         exception TYPE n,
         count_col TYPE i,
* visible column for hyperlink
         additional_infos(30),
* color informations
         it_colors TYPE lvc_t_scol,
* cell type informations
         it_cell_types TYPE salv_t_int4_column,
* hyperlink informations
         it_hyperlinks TYPE salv_t_int4_column,
       END OF tt_book.
* internal table
DATA: it_book TYPE TABLE OF tt_book,
* work area for internal table
      wa_book LIKE LINE OF it_book,
* work area for internal table for colors
      wa_colors LIKE LINE OF wa_book-it_colors,
* work area for internal table for cell types
      wa_cell_types LIKE LINE OF wa_book-it_cell_types,
* work area for internal table for hyperlink control
      wa_hyperlinks LIKE LINE OF wa_book-it_hyperlinks.

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
* wa for reading table SPFLI
DATA: wa_spfli TYPE spfli.

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
SELECTION-SCREEN SKIP.
PARAMETERS: p_layout TYPE disvariant-variant.
