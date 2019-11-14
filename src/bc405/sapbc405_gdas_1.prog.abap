*&-----------------------------------------------
*& Report  SAPBC405_GDAS_1
*&-----------------------------------------------
*&   Solution: Data Retrieval with Inner Join
*&   Join of Connections and Flights
*&-----------------------------------------------
REPORT sapbc405_gdas_1.
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
      seatsmax seatsocc
    INTO CORRESPONDING FIELDS OF TABLE it_join
    FROM  spfli INNER JOIN sflight
      ON  spfli~carrid = sflight~carrid
      AND spfli~connid = sflight~connid
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
