*&---------------------------------------------------------------------*
*& Report  SAPBC408OTHD_FB_ALV_GRID                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  SAPBC408OTHD_FB_ALV_GRID                                    .
DATA: it_sbook TYPE TABLE OF sbook,
      wa_sbook TYPE sbook.
SELECT-OPTIONS: so_car FOR wa_sbook-carrid,
                so_con FOR wa_sbook-connid,
                so_dat FOR wa_sbook-fldate.

SELECT * FROM sbook INTO TABLE it_sbook
WHERE carrid IN so_car
  AND connid IN so_con
  AND fldate IN so_dat.


CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
*   I_CALLBACK_PROGRAM                = ' '
*   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = ' '
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
   i_structure_name                  = 'SBOOK'
*   I_BACKGROUND_ID                   = ' '
   i_grid_title                      = 'Bookings'(001)
*   I_GRID_SETTINGS                   =
*   IS_LAYOUT                         =
*   IT_FIELDCAT                       =
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
*   I_SAVE                            = ' '
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   I_HTML_HEIGHT_TOP                 =
*   I_HTML_HEIGHT_END                 =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
  TABLES
    t_outtab                          = it_sbook
* EXCEPTIONS
*   PROGRAM_ERROR                     = 1
*   OTHERS                            = 2
.
IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.
