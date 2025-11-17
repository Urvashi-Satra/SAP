
"Filling Complex internal table.



CLASS zcl_us_g_fill_internaltable DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_US_G_FILL_INTERNALTABLE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    " Structure Definition
    TYPES: BEGIN OF st_connection,
             carrier_id      TYPE /dmo/carrier_id,
             connection_id   TYPE /dmo/connection_id,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             carrier_name    TYPE /dmo/carrier_name,
           END OF st_connection.

    "Internal Table Type
    TYPES: tt_connections TYPE STANDARD TABLE OF st_connection WITH NON-UNIQUE KEY carrier_id  connection_id.

    "internal table instance.
    DATA connections TYPE tt_connections.

     TYPES: BEGIN OF st_carrier,
             carrier_id    TYPE /dmo/carrier_id,
             carrier_name  TYPE /dmo/carrier_name,
             currency_code TYPE /dmo/currency_code,
           END OF st_carrier.

    TYPES tt_carriers TYPE STANDARD TABLE OF st_carrier
                          WITH NON-UNIQUE KEY carrier_id.

    DATA carriers TYPE tt_carriers.


* Example 1: APPEND with structured data object (work area)
**********************************************************************

    "Data connection TYPE st_connection.

    "Declare the work area with like line of.
    DATA connection LIKE LINE OF connections .

*    connection-carrier_id = 'NN'.
*    connection-connection_id = '1234'.
*    connection-airport_from_id = 'ABC'.
*    connection-airport_to_id = 'XYZ'.
*    connection-carrier_name = 'Airlines'.

    " Use VALUE #( ) instead assignment to individual components
    connection = VALUE #( carrier_id = 'NN'
                          connection_id = '1234'
                          airport_from_id = 'ABC'
                          airport_to_id = 'XYZ'
                          carrier_name = 'Airlines'
     ) .

    APPEND connection TO connections .

    out->write(  `--------------------------------` ).
    out->write(  `Example 1: APPEND with Work Area` ).
    out->write(  connections ).

* Example 2: APPEND with VALUE #( ) expression
**********************************************************************

    APPEND VALUE #( carrier_id       = 'NN'
                    connection_id    = '1234'
                    airport_from_id  = 'ABC'
                    airport_to_id    = 'XYZ'
                    carrier_name     = 'My Airline'
                  )
       TO connections.

    out->write(  `----------------------------` ).
    out->write(  `Example 2: Append with VALUE` ).
    out->write(  connections ).


* Example 3: Filling an Internal Table with Several Rows
**********************************************************************

    carriers = VALUE #(  (  carrier_id = 'AA' carrier_name = 'American Airlines' )
                         (  carrier_id = 'JL' carrier_name = 'Japan Airlines'    )
                         (  carrier_id = 'SQ' carrier_name = 'Singapore Airlines')
                      ).

    out->write(  `-----------------------------------------` ).
    out->write(  `Example 3: Fill Internal Table with VALUE` ).
    out->write(  carriers ).


* Example 4: Filling one Internal Table from Another
**********************************************************************

    connections = CORRESPONDING #( carriers ).

    out->write(  `--------------------------------------------` ).
    out->write(  `Example 4: CORRESPONDING for Internal Tables` ).
    out->write(  data = carriers
                 name = `Source Table CARRIERS:`).
    out->write(  data = connections
                 name = `Target Table CONNECTIONS:`).
  ENDMETHOD.
ENDCLASS.
