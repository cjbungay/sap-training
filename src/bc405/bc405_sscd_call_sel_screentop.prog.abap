*----------------------------------------------------------------------*
*   INCLUDE BC405_SSCD_CALL_SEL_SCREENITOP                             *
*----------------------------------------------------------------------*
REPORT  sapbc405_sscd_call_sel_screen LINE-SIZE 255 .

TYPES:  BEGIN OF line_type_custom,
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


DATA: wa_custom TYPE line_type_custom.
DATA: wa_agency TYPE line_type_travelag.

DATA: itab_custom TYPE TABLE OF line_type_custom,
      itab_agency TYPE TABLE OF line_type_travelag.


CONSTANTS: mark VALUE 'X',
           line_size TYPE i VALUE 255.
