*&---------------------------------------------------------------------*
*& Report  SAPBC400ITS_ITAB_BUFFER                                     *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  Data buffering in internal tables to reduce database access        *
*&---------------------------------------------------------------------*

REPORT  sapbc400its_itab_buffer.

PARAMETERS pa_anum TYPE s_agncynum.

TYPES: BEGIN OF struc_type,
         id   TYPE scustom-id,
         name TYPE scustom-name,
       END OF struc_type.

TYPES  itab_type TYPE STANDARD TABLE OF struc_type  WITH KEY id.

DATA:  wa_scustom TYPE struc_type,
       it_scustom TYPE itab_type.

* workarea for select
DATA wa_sbook TYPE sbook.


* buffering scustom data
SELECT id name INTO TABLE it_scustom FROM scustom.

* selecting data
SELECT carrid connid fldate bookid customid order_date
       FROM sbook
       INTO CORRESPONDING FIELDS OF wa_sbook
         WHERE agencynum = pa_anum.

* reading customer name from internal table to avoid nested SELECTs
  READ TABLE it_scustom INTO wa_scustom
                        WITH TABLE KEY id = wa_sbook-customid.
* CLEAR wa_scustom.
* MOVE wa_sbook-customid TO wa_scustom-id.
* READ TABLE it_scustom INTO wa_scustom FROM wa_scustom.

  WRITE: / wa_sbook-carrid,
           wa_sbook-connid,
           wa_sbook-fldate,
           wa_sbook-bookid,
           wa_scustom-name,
           wa_sbook-order_date.

ENDSELECT.
