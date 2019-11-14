*&---------------------------------------------------------------------*
*& Report  SAPBC402_TABD_SINGLE_COLUMN                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Demo for internal tables with unstructured line types               *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc402_tabd_single_column        .

TYPES:
  column_table TYPE STANDARD TABLE OF dd03l-fieldname
     WITH NON-UNIQUE KEY table_line.

DATA:
  it_fields TYPE column_table,
  wa_fields LIKE LINE OF it_fields.


START-OF-SELECTION.
  SELECT fieldname FROM dd03l INTO TABLE it_fields
    WHERE tabname = 'SFLIGHT'.

* "unintelligent" existance check ;-)
  READ TABLE it_fields INTO wa_fields
       WITH KEY table_line = 'CARRID'.
* ...
  IF sy-subrc = 0.
    WRITE: / 'SFLIGHT'.
    LOOP AT it_fields INTO wa_fields.
      WRITE: / '->', wa_fields.
    ENDLOOP.
  ELSE.
    WRITE: text-010.                   " no fields found
  ENDIF.
