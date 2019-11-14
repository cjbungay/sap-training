*----------------------------------------------------------------------*
*   INCLUDE BC405_SSCD_CHECKBOX_RADIOBTOP                              *
*----------------------------------------------------------------------*

TYPES: BEGIN OF LINE_TYPE_SFLIGHT,
        CARRID LIKE SCARR-CARRID,
        CONNID LIKE SPFLI-CONNID,
        FLDATE LIKE SFLIGHT-FLDATE,
        PRICE  LIKE SFLIGHT-PRICE,
        CURRENCY LIKE SFLIGHT-CURRENCY,
       END OF LINE_TYPE_SFLIGHT.
DATA: WA_SFLIGHT TYPE LINE_TYPE_SFLIGHT.
DATA: ITAB_SFLIGHT TYPE TABLE OF LINE_TYPE_SFLIGHT.
TABLES: SCARR.
