*&---------------------------------------------------------------------*
*& Report  SAPBC405_LDBD_DIFF_NODES                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc405_ldbd_diff_nodes LINE-SIZE 83.
NODES: scarr,
       sflight_struct,
       sflight_table,
       sflight_dyn TYPE sbc405_t_sflight.
*      sflight_dyn type sbc405_s_sflight.    Second possible Type

DATA: wa_tab TYPE sbc405_s_sflight.

* Node of type  TABLE
GET scarr.
  NEW-PAGE.
  ULINE.
  FORMAT COLOR COL_HEADING.
  WRITE: sy-vline, 'NODE SCARR'(001),
         scarr-carrid, 83 sy-vline.

* NODE of type  DDIC-TYPE sbc405_s_sflight (structure)
GET sflight_struct.
  ULINE.
  FORMAT COLOR COL_TOTAL.
  WRITE:   sy-vline, 'NODE SFLIGHT_STRUCT'(002),
           sflight_struct-carrid, sflight_struct-connid,
           sflight_struct-fldate, 83 sy-vline.

* NODE of type  DDIC-TYPE sbc405_t_sflight (standard table)
GET sflight_table.
  ULINE.
  FORMAT COLOR COL_POSITIVE.
  LOOP AT  sflight_table INTO wa_tab .
    WRITE:    sy-vline, 'NODE SFLIGHT_TABLE'(003),
              wa_tab-carrid, wa_tab-connid,
              wa_tab-fldate, 83 sy-vline.
  ENDLOOP.

* Dynamic NODE of type sbc405_t_sflight
GET sflight_dyn.
  ULINE.
  FORMAT COLOR COL_NEGATIVE.
  LOOP AT sflight_dyn INTO wa_tab .
    WRITE:    sy-vline, 'NODE SFLIGHT_TABLE'(004),
              wa_tab-carrid, wa_tab-connid,
              wa_tab-fldate, 83 sy-vline.
  ENDLOOP.


