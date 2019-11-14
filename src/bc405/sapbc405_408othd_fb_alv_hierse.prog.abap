*&---------------------------------------------------------------------*
*& Report  SAPBC408OTHD_FB_ALV_HIERSEQ                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408othd_fb_alv_hierseq.
TYPE-POOLS: slis.
DATA: it_sflight TYPE TABLE OF sflight,
      wa_sflight TYPE sflight,
      it_spfli TYPE TABLE OF spfli.

DATA: my_keyinfo TYPE slis_keyinfo_alv.

SELECT-OPTIONS: so_car FOR wa_sflight-carrid,
                so_con FOR wa_sflight-connid.


START-OF-SELECTION.
  SELECT * FROM spfli INTO TABLE it_spfli
  WHERE carrid IN so_car
  AND   connid IN so_con.

  SELECT * FROM sflight INTO TABLE it_sflight
  WHERE carrid IN so_car
  AND   connid IN so_con.

  my_keyinfo-header01 = 'MANDT'.
  my_keyinfo-item01 = 'MANDT'.
  my_keyinfo-header02 = 'CARRID'.
  my_keyinfo-item02 = 'CARRID'.
  my_keyinfo-header03 = 'CONNID'.
  my_keyinfo-item03 = 'CONNID'.

  CALL FUNCTION 'REUSE_ALV_HIERSEQ_LIST_DISPLAY'
    EXPORTING
*   I_INTERFACE_CHECK              = ' '
*   I_CALLBACK_PROGRAM             =
*   I_CALLBACK_PF_STATUS_SET       = ' '
*   I_CALLBACK_USER_COMMAND        = ' '
*   IS_LAYOUT                      =
*   IT_FIELDCAT                    =
*   IT_EXCLUDING                   =
*   IT_SPECIAL_GROUPS              =
*   IT_SORT                        =
*   IT_FILTER                      =
*   IS_SEL_HIDE                    =
*   I_SCREEN_START_COLUMN          =
*   I_SCREEN_START_LINE            =
*   I_SCREEN_END_COLUMN            =
*   I_SCREEN_END_LINE              =
*   I_DEFAULT                      = 'X'
*   I_SAVE                         = ' '
*   IS_VARIANT                     =
*   IT_EVENTS                      =
*   IT_EVENT_EXIT                  =
     i_tabname_header               = 'IT_SPFLI'
     i_tabname_item                 = 'IT_SFLIGHT'
     i_structure_name_header        = 'SPFLI'
     i_structure_name_item          = 'SFLIGHT'
     is_keyinfo                     = my_keyinfo
*   IS_PRINT                       =
*   IS_REPREP_ID                   =
*   I_BYPASSING_BUFFER             =
*   I_BUFFER_ACTIVE                =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER        =
*   ES_EXIT_CAUSED_BY_USER         =
    TABLES
      t_outtab_header                = it_spfli
      t_outtab_item                  = it_sflight
* EXCEPTIONS
*   PROGRAM_ERROR                  = 1
*   OTHERS                         = 2
            .
