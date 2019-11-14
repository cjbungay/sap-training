*&---------------------------------------------------------------------*
*&  Include           MBC410AINPS_INPUT_FIELDE02
*&---------------------------------------------------------------------*
LOAD-OF-PROGRAM.
* get stored values from SAP memory
  GET PARAMETER ID:
    'CAR' FIELD sdyn_conn-carrid,
    'CON' FIELD sdyn_conn-connid,
    'DAY' FIELD sdyn_conn-fldate.

* retrieve detail data of flight
  SELECT SINGLE *
    FROM sflight
    INTO wa_sflight
    WHERE carrid = sdyn_conn-carrid AND
          connid = sdyn_conn-connid AND
          fldate = sdyn_conn-fldate.
