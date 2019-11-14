*----------------------------------------------------------------------*
*   INCLUDE  BC405_SSCD_VARIANTSTOP                                    *
*----------------------------------------------------------------------*
REPORT  SAPBC405_SSCD_VARIANTS .

TYPES: BEGIN OF line_type_itab,
        carrid LIKE spfli-carrid,
        connid LIKE spfli-connid,
        fldate LIKE sflight-fldate,
        bookid LIKE sbook-bookid,
        customid LIKE sbook-customid,
        agencynum LIKE sbook-agencynum,
       END OF line_type_itab,

       BEGIN OF line_type_custom,
        id LIKE scustom-id,
        name LIKE scustom-name,
        form LIKE scustom-form,
        custtype LIKE scustom-custtype,
       END OF line_type_custom,

       BEGIN OF line_type_travelag,
        agencynum LIKE stravelag-agencynum,
        name LIKE stravelag-name,
        url LIKE stravelag-url,
       END OF line_type_travelag.


DATA: wa_itab     TYPE line_type_itab.
DATA: wa_custom   TYPE line_type_custom.
DATA: wa_travelag TYPE line_type_travelag.

DATA: itab TYPE TABLE OF line_type_itab.
CONSTANTS: mark VALUE 'X'.
