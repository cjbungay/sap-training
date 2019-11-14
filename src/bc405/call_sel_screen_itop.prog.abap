*----------------------------------------------------------------------*
*   INCLUDE CALL_SEL_SCREEN_ITOP                                       *
*----------------------------------------------------------------------*


 TYPES: BEGIN OF LINE_TYPE_SCUSTOM,
         ID LIKE SCUSTOM-ID,
         NAME LIKE SCUSTOM-NAME,
         FORM LIKE SCUSTOM-FORM,
         STREET LIKE SCUSTOM-STREET,
         POSTCODE LIKE SCUSTOM-POSTCODE,
         CITY LIKE SCUSTOM-CITY,
         CUSTTYPE LIKE SCUSTOM-CUSTTYPE,
        END OF LINE_TYPE_SCUSTOM.

 DATA: WA_SCUSTOM TYPE LINE_TYPE_SCUSTOM.
