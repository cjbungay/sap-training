class CL_IM_IM_BAPI_BC417_EXPORT definition
  public
  final
  create public .

*"* public components of class CL_IM_IM_BAPI_BC417_EXPORT
*"* do not include other source files here!!!
public section.

  interfaces IF_EX_BADI_BC417_EXPORT .
protected section.
*"* protected components of class CL_IM_IM_BAPI_BC417_EXPORT
*"* do not include other source files here!!!
private section.
*"* private components of class CL_IM_IM_BAPI_BC417_EXPORT
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_IM_IM_BAPI_BC417_EXPORT IMPLEMENTATION.


method IF_EX_BADI_BC417_EXPORT~EXPORT_DATA.

 data: structure_name(30) value 'BAPI_TE_SKNA1',
       Hold_area(960),
       comma   value ','.

 data: customer_add type table of bapi_te_skna1,
       wa_extension_out type bapiparex,
       wa_customer_add type bapi_te_skna1.

       clear extension_out.

       select kunnr telf1 telfx mcod3
           from skna1
             into corresponding fields of table customer_add
                where land1 = country.

       move structure_name to wa_extension_out-structure.

       loop at customer_add into wa_customer_add.

       concatenate wa_customer_add-telf1 wa_customer_add-telfx
          wa_customer_add-mcdd3 into hold_area separated by comma.

       move hold_area to wa_extension_out+30.

       Append wa_extension_out to extension_out.

       endloop.

endmethod.
ENDCLASS.
