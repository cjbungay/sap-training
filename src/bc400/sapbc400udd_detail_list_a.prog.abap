*&---------------------------------------------------------------------*
*& Report  SAPBC400UDD_DETAIL_LIST_A                                   *
*&---------------------------------------------------------------------*

REPORT  sapbc400udd_detail_list_a    .

START-OF-SELECTION.
  WRITE : text-001 COLOR COL_HEADING,
         /'SY-LSIND', sy-lsind COLOR = 2.

AT LINE-SELECTION.
  WRITE: / text-002 COLOR COL_HEADING.
  ULINE.
  WRITE: / 'SY-LSIND', sy-lsind  COLOR = 4.
