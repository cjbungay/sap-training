*&------------------------------------------------
*& Include BC405_LDBS_2TOP
*&
*&------------------------------------------------

REPORT   sapbc405_ldbs_2 LINE-SIZE 83.

* Used nodes of logical database F1S
NODES: spfli, sflight, sbook.

* Additional selections
SELECTION-SCREEN BEGIN OF BLOCK order WITH FRAME.
SELECT-OPTIONS: so_cust FOR sbook-customid.
SELECTION-SCREEN END OF BLOCK order.

* Variables
DATA: free_seats LIKE sflight-seatsocc.

* Constants
CONSTANTS: line_size LIKE sy-linsz VALUE 83.
