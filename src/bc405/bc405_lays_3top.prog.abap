*&--------------------------------
*& Include BC405_ARCS_3TOP
*&
*&--------------------------------

REPORT xyz.
* type for internal table
TYPES: BEGIN OF t_sflight.
        INCLUDE STRUCTURE sflight.
TYPES:   seatsfree TYPE sflight-seatsocc,
       END OF t_sflight.
* Internal table
DATA: it_sflight TYPE TABLE OF t_sflight.
* Workarea for data fetch
DATA: wa_sflight LIKE LINE OF it_sflight.
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
  so_con FOR wa_sflight-connid.

SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK alv WITH FRAME TITLE text-alv.
PARAMETERS: pa_full RADIOBUTTON GROUP alvd,
            pa_cont RADIOBUTTON GROUP alvd DEFAULT 'X',
            pa_list RADIOBUTTON GROUP alvd.
SELECTION-SCREEN END OF BLOCK alv.
PARAMETERS: p_layout TYPE slis_vari.
