*&--------------------------------
*& Include BC405_ARCS_3TOP
*&
*&--------------------------------

REPORT xyz.
* constants for icons
TYPE-POOLS: icon,
* constants for colors
            col.
* type for internal table
TYPES: BEGIN OF t_sflight.
        INCLUDE STRUCTURE sflight.
TYPES:   seatsfree TYPE sflight-seatsocc,
* exception
         usage TYPE n,
* icon for future / past
         icon_future TYPE icon-id,
* line counter
         line_counter TYPE i,
* internal table for cell color information
         it_colors TYPE lvc_t_scol,
       END OF t_sflight.
* Internal table
DATA: it_sflight TYPE TABLE OF t_sflight.
* Workarea for data fetch
DATA: wa_sflight LIKE LINE OF it_sflight.
* Workarea for cell color information
DATA: wa_colors LIKE LINE OF wa_sflight-it_colors.
* Switch for list display yes / no
DATA: list_display TYPE sap_bool.
* Reference for container control
DATA: gr_cont TYPE REF TO cl_gui_custom_container.
* Reference for ALV instance
DATA: gr_alv TYPE REF TO cl_salv_table.
* Reference for error situations
DATA: gr_error TYPE REF TO cx_salv_error.
* user-command from dynpro
DATA: ok_code LIKE sy-ucomm.

SELECT-OPTIONS:
  so_car FOR wa_sflight-carrid MEMORY ID car,
  so_con FOR wa_sflight-connid,
  so_date FOR wa_sflight-fldate.

SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN
  BEGIN OF BLOCK alv WITH FRAME TITLE text-alv.
PARAMETERS: pa_full RADIOBUTTON GROUP alvd DEFAULT 'X',
            pa_cont RADIOBUTTON GROUP alvd,
            pa_list RADIOBUTTON GROUP alvd.
SELECTION-SCREEN END OF BLOCK alv.
PARAMETERS: p_layout TYPE slis_vari.
