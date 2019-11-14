REPORT  bc427_iep_fm_template.

PARAMETERS: netprice  TYPE bc427_price,
            discount  TYPE i.

DATA: fullprice  TYPE bc427_price,
      discprice  TYPE bc427_price.


* Calling the enhanced function module
...


WRITE: / 'Full price :',     18 fullprice,
       / 'Discount price :', 18 discprice.
