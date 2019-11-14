*****           Implementation of object type CON04172             *****
INCLUDE <OBJECT>.
BEGIN_DATA OBJECT. " Do not change.. DATA is generated
* only private members may be inserted into structure private
DATA:
" begin of private,
"   to declare private attributes remove comments and
"   insert private attributes here ...
" end of private,
      KEY LIKE SWOTOBJID-OBJKEY.
END_DATA OBJECT. " Do not change.. DATA is generated

BEGIN_METHOD UPDATE CHANGING CONTAINER.
DATA:
      CONTACT LIKE BAPI0417_2-PARNR,
      CUSTOMER LIKE BAPI0417_2-KUNNR,
      TELEPHONE LIKE BAPI0417_2-TELF1,
      ENTERED LIKE BAPI0417_2-ERNAM,
      RETURN LIKE BAPIRET2.
  SWC_GET_ELEMENT CONTAINER 'Contact' CONTACT.
  SWC_GET_ELEMENT CONTAINER 'Customer' CUSTOMER.
  SWC_GET_ELEMENT CONTAINER 'Telephone' TELEPHONE.
  SWC_GET_ELEMENT CONTAINER 'Entered' ENTERED.
  CALL FUNCTION 'BAPI_CONTACT_UPDATE'
    EXPORTING
      ENTERED = ENTERED
      TELEPHONE = TELEPHONE
      CUSTOMER = CUSTOMER
      CONTACT = CONTACT
    IMPORTING
      RETURN = RETURN
    EXCEPTIONS
      OTHERS = 01.
  CASE SY-SUBRC.
    WHEN 0.            " OK
    WHEN OTHERS.       " to be implemented
  ENDCASE.
  SWC_SET_ELEMENT CONTAINER 'Return' RETURN.
END_METHOD.
