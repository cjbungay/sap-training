*&-----------------------------------------------
*&   Solution: Data retrieval with inner join
*&   and three tables
*&-----------------------------------------------
REPORT sapbc405_gdas_1opt.
* work area for join
DATA:
  BEGIN OF wa_join,
    carrid     TYPE spfli-carrid,
    connid     TYPE spfli-connid,
    fldate     TYPE sflight-fldate,
    cityfrom   TYPE spfli-cityfrom,
    cityto     TYPE spfli-cityto,
    fltime     TYPE spfli-fltime,
    seatsmax   TYPE sflight-seatsmax,
    seatsocc   TYPE sflight-seatsocc,
    planetype  TYPE saplane-planetype,
    op_speed   TYPE saplane-op_speed,
    speed_unit TYPE saplane-speed_unit,
  END OF wa_join,
  it_join LIKE TABLE OF wa_join.

DATA: alv TYPE REF TO cl_salv_table.

SELECT-OPTIONS: so_car FOR wa_join-carrid MEMORY ID car.

START-OF-SELECTION.
* retrieve data
  SELECT
      spfli~carrid spfli~connid
      fldate
      cityfrom cityto fltime
      sflight~seatsmax seatsocc

**************** optional******************************
    sflight~planetype op_speed speed_unit
*******************************************************

    INTO CORRESPONDING FIELDS OF TABLE it_join
    FROM  spfli INNER JOIN sflight
      ON  spfli~carrid = sflight~carrid
      AND spfli~connid = sflight~connid

**************** optional******************************
    INNER JOIN saplane
      ON sflight~planetype = saplane~planetype
*******************************************************

    WHERE  spfli~carrid IN so_car.

* create ALV
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = alv
    CHANGING
      t_table        = it_join
         ).

* display data
  alv->display( ).
