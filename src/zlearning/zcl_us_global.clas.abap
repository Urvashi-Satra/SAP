CLASS zcl_us_global DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_us_global IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    CONSTANTS c_carrier_id TYPE /dmo/carrier_id       VALUE 'LH'.
    CONSTANTS c_connection_id TYPE /dmo/connection_id VALUE '0400'.

    DATA connection TYPE REF TO lcl_connection .
    DATA connections TYPE TABLE OF REF TO lcl_connection.
    "  connection = NEW #(  ).   "Creating instance of class.

    "with constructor creating instance
    TRY .
        connection = NEW #( i_carrier_id = 'LH'  i_connection_id = '1024' ) .
      CATCH cx_abap_invalid_value.
    ENDTRY.

* Call Method and Handle Exception
**********************************************************************
    out->write(  |i_carrier_id    = '{ c_carrier_id }' | ).
    out->write(  |i_connection_id = '{ c_connection_id }'| ).

* First Instance
**********************************************************************
    TRY.
        connection = NEW #(
                            i_carrier_id    = 'LH'
                            i_connection_id = '0400'
                          ).

*        connection->set_attributes(
*          EXPORTING
*            i_carrier_id    = 'LH'
*            i_connection_id = '0400'
*        ).

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `Method call failed` ).
    ENDTRY.
* Second instance
**********************************************************************
    TRY.
        connection = NEW #(
                            i_carrier_id    = 'AA'
                            i_connection_id = '0017'
                          ).
        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `Method call failed` ).
    ENDTRY.

* Third instance
**********************************************************************
    TRY.
        connection = NEW #(
                            i_carrier_id    = 'SQ'
                            i_connection_id = '0001'
                          ).
        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `Method call failed` ).
    ENDTRY.


* Calling Functional Method
**********************************************************************
    " in a value assignment (with inline declaration for result)
*    DATA(result) = connection->get_output(  ).  " Connection is class instance created for lcl_connection
*
*    IF connection->get_output(  ) IS NOT INITIAL .
*
*      LOOP AT connection->get_output(  ) INTO DATA(line).
*
*      ENDLOOP.
*
*      "  to supply input parameter of another method
*      out->write( data = connection->get_output( )   " This gives the last data of instance.
*                  name = `  ` ).
*    ENDIF.


    IF connection IS BOUND.
      DATA(result) = connection->get_output( ).

      IF result IS NOT INITIAL.
        LOOP AT result INTO DATA(line).
          " process line
        ENDLOOP.

        out->write( data = result name = `  ` ).
      ENDIF.
    ELSE.
      out->write( `Connection object is not initialized.` ).
    ENDIF.

* Output
**********************************************************************

    LOOP AT connections INTO connection.

      "    out->write( connection->get_output( ) ).  " This gives all the data of instance.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
