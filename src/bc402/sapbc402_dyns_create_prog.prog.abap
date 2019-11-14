*&---------------------------------------------------------------------*
*& Report  SAPBC402_DYNS_CREATE_PROG
*&
*&---------------------------------------------------------------------*
REPORT  sapbc402_dyns_create_prog.

*----------------------------------------------------------------------*
DATA:
    gt_source     TYPE TABLE OF string,
    gv_prog       TYPE program.

*----------------------------------------------------------------------*
START-OF-SELECTION.

  APPEND 'REPORT.'                                           "#EC NOTEXT
      TO gt_source.
  APPEND INITIAL LINE
      TO gt_source.
  APPEND 'TABLES spfli.'                                     "#EC NOTEXT
      TO gt_source.
  APPEND 'SELECT-OPTIONS so_car FOR SPFLI-CARRID.'
      TO gt_source.
  APPEND 'LOOP AT so_car.'                                   "#EC NOTEXT
      TO gt_source.
  APPEND 'WRITE / so_car-sign.'                              "#EC NOTEXT
      TO gt_source.
  APPEND 'WRITE   so_car-option.'                            "#EC NOTEXT
      TO gt_source.
  APPEND 'WRITE   so_car-low.'                               "#EC NOTEXT
      TO gt_source.
  APPEND 'WRITE   so_car-high.'                              "#EC NOTEXT
      TO gt_source.
  APPEND 'ENDLOOP.'                                          "#EC NOTEXT
      TO gt_source.

  gv_prog = 'Z99BC402XXX'.                                   "#EC NOTEXT

  INSERT REPORT gv_prog FROM gt_source.
  SUBMIT (gv_prog) VIA SELECTION-SCREEN
                   AND RETURN.

*----------------------------------------------------------------------*
  WRITE: / 'Programm erfolgreich ausgeführt'(pro).
