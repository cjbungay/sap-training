*&---------------------------------------------------------------------*
*& Report SAPBC400DDD_SELECT_INNER_JOIN                                *
*&---------------------------------------------------------------------*
*&                                                                     *
*&  read data from two database tables via APAB inner join :           *
*&                                                                     *
*&        SELECT ... FROM ... INNER JOIN ...                           *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT sapbc400ddd_select_inner_join .

TYPES: BEGIN OF wa_type,
         carrid    TYPE scarr-carrid,
         carrname  TYPE scarr-carrname,
         connid    TYPE spfli-connid,
         airpfrom  TYPE spfli-airpfrom,
         cityfrom  TYPE spfli-cityfrom,
         countryfr TYPE spfli-countryfr,
         airpto    TYPE spfli-airpto,
         cityto    TYPE spfli-cityto,
         countryto TYPE spfli-countryto,
         deptime   TYPE spfli-deptime,
       END OF wa_type.

DATA wa_join TYPE wa_type.


* Selecting from Inner Join (to avoid nested SELECT loops)

SELECT scarr~carrid scarr~carrname spfli~connid
       spfli~airpfrom spfli~cityfrom spfli~countryfr
       spfli~airpto spfli~cityto spfli~countryto
       spfli~deptime
       INTO CORRESPONDING FIELDS OF wa_join
       FROM scarr INNER JOIN spfli
       ON scarr~carrid = spfli~carrid.

  WRITE: /  wa_join-carrid,
            wa_join-carrname,
            wa_join-connid,
            wa_join-airpfrom,
            wa_join-cityfrom,
            wa_join-countryfr,
            wa_join-airpto,
            wa_join-cityto,
            wa_join-countryto,
            wa_join-deptime.

ENDSELECT.
