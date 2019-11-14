*----------------------------------------------------------------------*
*   INCLUDE SAPBC420_SEQI_DEBI_LEGACYSTRUC                             *
*----------------------------------------------------------------------*
 DATA: BEGIN OF REC_LEGACY,
         KUNNR(4),                      "Customer Number
         NAME1(30),                     "Customer Name
         SORTL(20),                     "Sort Field
         CUSTTYPE(4),                   "Old Customer Type
         STRAS(40),                     "Street and House Number
         ORT01(30),                     "City
         PSTLZ(10),                     "Postal code
         LAND1(2),                      "Country Key
         SPRAS(1),                      "Language Key
         TELF1(16),                     "Telephone Number
         STCEG(20),                     "VAT Registration Number
      end of rec_legacy.
