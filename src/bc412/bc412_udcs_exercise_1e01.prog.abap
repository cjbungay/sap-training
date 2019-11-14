*----------------------------------------------------------------------*
*   INCLUDE BC412_UDCS_EXERCISE_1E01                                   *
*----------------------------------------------------------------------*

LOAD-OF-PROGRAM.
* default values for select-option:
  so_cust-low    = 1.
  so_cust-high   = 20.
  so_cust-sign   = 'I'.
  so_cust-option = 'BT'.
  APPEND so_cust.

  so_cust-low    = 40.
  so_cust-high   = 60.
  so_cust-sign   = 'I'.
  so_cust-option = 'BT'.
  APPEND so_cust.

* get initial application data:
  SELECT * FROM scarr
           INTO TABLE it_scarr.
  IF sy-subrc <> 0.
    MESSAGE a060.
  ENDIF.

  SELECT * FROM spfli
           INTO TABLE it_spfli.
  IF sy-subrc <> 0.
    MESSAGE a060.
  ENDIF.
