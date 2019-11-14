*&---------------------------------------------------------------------*
*& Report  SAPBC401_TABD_HASHED                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*& creates an internal table to buffer all the coordinates of cities   *
*& selects all city-airport combinations regarding to a given country  *
*& and displays them together with the coordinates of a the city       *
*& retrieved from the buffer table                                     *
*&                                                                     *
*& Attention:                                                          *
*& Don't work like this, use DIC-Views instead!!!                      *
*& only for syntax demonstration here                                  *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT sapbc401_tabd_hashed.

TYPES:
  BEGIN OF t_city,
    city      TYPE sgeocity-city,
    country   TYPE sgeocity-country,
    latitude  TYPE sgeocity-latitude,
    longitude TYPE sgeocity-longitude,
    airport   TYPE scitairp-airport,
  END OF t_city,

  t_city_list TYPE HASHED TABLE OF t_city
              WITH UNIQUE KEY city country.

DATA:
  wa_city   TYPE t_city,
  city_list TYPE t_city_list,

  wa_airport TYPE t_city.

PARAMETERS
  pa_ctry TYPE sgeocity-country.


LOAD-OF-PROGRAM.
  SELECT city country latitude longitude
         FROM sgeocity
         INTO CORRESPONDING FIELDS OF TABLE city_list.


START-OF-SELECTION.

  sy-tvar0 = pa_ctry.

* Attention:
* Don't work like this, use DIC-Views instead!!!
*************************************************
  SELECT city country airport
         FROM scitairp
         INTO CORRESPONDING FIELDS OF wa_airport
         WHERE country = pa_ctry.

    READ TABLE city_list FROM wa_airport INTO wa_city.

    IF sy-subrc = 0.
      WRITE: / wa_city-city,
               wa_city-latitude,
               wa_city-longitude,
               wa_airport-airport.
    ENDIF.
  ENDSELECT.

  IF sy-subrc <> 0.
    WRITE: / 'No cities for this country!'(noc).
  ENDIF.
