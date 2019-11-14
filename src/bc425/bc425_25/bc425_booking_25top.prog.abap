*&---------------------------------------------------------------------*
*& Include BC425_BOOKING_00TOP                                         *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  SAPBC425_BOOKING_00           .

data:
* Work Area and Internal Table for Bookings:
      wa_book     type          sdyn_book,
      itab_book   type table of sdyn_book,

* Position of vertical line:
      pos type i value 45,

* Reference variable for instance of BAdI service class:
      exit_book type ref to if_ex_badi_book25.

* Selection Screen
selection-screen: begin of block flight with frame title text-aaa.
select-options: so_car for wa_book-carrid,
                so_con for wa_book-connid,
                so_fld for wa_book-fldate.
selection-screen: end of block flight.
