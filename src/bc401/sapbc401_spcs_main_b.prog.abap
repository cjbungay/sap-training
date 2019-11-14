*&---------------------------------------------------------------------*
*& Report  SAPBC401_SPCS_MAIN_B                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&    Practice with singleton & friends                                *
*&---------------------------------------------------------------------*

REPORT  sapbc401_spcs_main_b.

DATA: r_single TYPE REF TO cl_singleton,
      r_agency TYPE REF TO cl_agency,
      rec TYPE spfli.


START-OF-SELECTION.
*########################

  CREATE OBJECT r_agency EXPORTING im_name = 'Agency'.

  r_agency->get_connection( EXPORTING im_carrid = 'LH'
                                      im_connid = '0400'
                            IMPORTING ex_connection = rec ).

  WRITE: / rec-carrid, rec-connid, rec-cityfrom, rec-cityto.
