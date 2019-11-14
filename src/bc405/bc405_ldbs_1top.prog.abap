*&-----------------------------------------------
*& Include BC405_LDBS_1TOP
*&
*&-----------------------------------------------

REPORT   sapbc405_ldbs_1 LINE-SIZE 83.

* Used nodes of logical database F1S
NODES: spfli, sflight, sbook.

* Variables
DATA: free_seats LIKE sflight-seatsocc.
