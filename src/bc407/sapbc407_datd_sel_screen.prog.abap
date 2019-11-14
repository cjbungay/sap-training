*&---------------------------------------------------------------------*
*& Report  SAPBC407_SEL_SCREEN                                         *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc407_sel_screen         .

* Data objects
DATA: wa_sflight TYPE sflight.


* Selection screen
SELECT-OPTIONS: so_car FOR wa_sflight-carrid,
               so_fld FOR wa_sflight-fldate.


* Writing the input
FORMAT COLOR COL_HEADING.
WRITE: / 'Fluggesellschaften'(t01).
LOOP AT so_car.
  FORMAT COLOR COL_NORMAL.
  WRITE: / 'SIGN'(001) COLOR COL_KEY, so_car-sign,
         / 'OPTION'(002) COLOR COL_KEY,so_car-option,
         / 'LOW'(003) COLOR COL_KEY, so_car-low,
         /'HIGH'(004) COLOR COL_KEY, so_car-high.
  SKIP.
ENDLOOP.
ULINE.
FORMAT COLOR COL_HEADING.
WRITE: / 'Flugdatum'(t02).
LOOP AT so_fld.
  FORMAT COLOR COL_NORMAL.
  WRITE: / 'SIGN'(001) COLOR COL_KEY, so_fld-sign,
         / 'OPTION'(002) COLOR COL_KEY, so_fld-option,
         / 'LOW'(003) COLOR COL_KEY, so_fld-low,
         /'HIGH'(004) COLOR COL_KEY, so_fld-high.
  SKIP.
ENDLOOP.
