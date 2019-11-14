*&---------------------------------------------------------------------*
*&  Include           SAPBC401_VEHT_B                                  *
*&---------------------------------------------------------------------*

*---------------------------------------------------------------------*
*       CLASS lcl_travel_agency DEFINITION
*---------------------------------------------------------------------*
*CLASS lcl_travel_agency DEFINITION.
*
*  PUBLIC SECTION.
*    "-------------------
*    METHODS:      constructor IMPORTING im_name TYPE string.
*    METHODS       add_partner ...
*    METHODS       display_agency_partners.
*
*  PRIVATE SECTION.
*    "-------------------
*    DATA: name TYPE string.
*    DATA  partner_list TYPE ...
*
*ENDCLASS.                    "lcl_travel_agency DEFINITION
*
*---------------------------------------------------------------------*
*       CLASS lcl_travel_agency IMPLEMENTATION
*---------------------------------------------------------------------*
*CLASS lcl_travel_agency IMPLEMENTATION.
*
* METHOD display_agency_partners.
*   DATA: r_partner TYPE
*   WRITE: icon_dependents AS ICON, name.
*   WRITE: ' Here are the partners of the travel agency: '.
*   ULINE.
*   ULINE.
*
*ENDMETHOD.                    "display_agency_partners
*
*METHOD  constructor.
*  name = im_name.
*ENDMETHOD.                    "constructor
*
*METHOD  add_partner.
*
*ENDMETHOD.                    "add_partner
*
*ENDCLASS.                    "lcl_travel_agency IMPLEMENTATION
