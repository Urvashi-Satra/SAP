
"Access Complex internal table.



CLASS zcl_us_g_access_internaltable DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_us_g_access_internaltable IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    "structure Definition - st_connection
    TYPES : BEGIN OF st_connection,
              carrier_id      TYPE /dmo/carrier_id,
              connection_id   TYPE /dmo/connection_id,
              airport_from_id TYPE /dmo/airport_from_id,
              airport_to_id   TYPE /dmo/airport_to_id,
              carrier_name    TYPE /dmo/carrier_name,

            END OF st_connection.

    "Sorted Internal Table
*----------------------------------------------------------------------------------------------------------
*
*                    TYPE SORTED TABLE OF st_connection
* Matlab ek internal table ban raha hai jo sorted hoga aur usme st_connection structure ke records honge.
*
*                    WITH NON-UNIQUE KEY carrier_id connection_id
*Key fields: carrier_id aur connection_id par sorting hogi.
* NON-UNIQUE: Matlab same key values ke multiple rows allowed hain (duplicates allowed).
*
*
*----------------------------------------------------------------------------------------------------------
    TYPES tt_connections TYPE SORTED TABLE OF st_connection WITH NON-UNIQUE KEY carrier_id connection_id.

    "Internal table of type tt_connections
    DATA connections TYPE tt_connections.

    "workarea of type connections
    DATA connection LIKE LINE OF connections.

*----------------------------------------------------------------------------------------------------------
*
*LIKE LINE OF connections का मतलब है:
*
*यह variable उसी type का होगा जैसा connections table की एक row होती है।
*यानी connection का structure भी st_connection जैसा होगा।
*----------------------------------------------------------------------------------------------------------

    "Structure definition
    TYPES: BEGIN OF st_carrier,
             carrier_id    TYPE /dmo/carrier_id,
             currency_code TYPE /dmo/currency_code,
           END OF st_carrier.

    "Internal table Declaration- carriers
    DATA carriers TYPE STANDARD TABLE OF st_carrier WITH NON-UNIQUE KEY carrier_id.

    "wORK AREA Declaration - CARRIER
    DATA carrier LIKE LINE OF carriers.

*----------------------------------------------------------------------------------------------------------

* Preparation: Fill internal tables with data

*
*connections
*यह आपका internal table है (type tt_connections), जो आपने पहले declare किया था।
*
*
*VALUE #(...)
*
*VALUE operator ABAP में constructor expression है।
*यह किसी table या structure को initialize करने के लिए use होता है।
*# का मतलब है type inference → compiler automatically समझ लेगा कि type क्या है (क्योंकि connections का type पहले से defined है)।
*
*
*
*( ... )
*
*यह एक row define कर रहा है।
*Row के अंदर आप fields को assign कर रहे हो:
*
*carrier_id = 'JL' → Japan Airlines का carrier ID।
*connection_id = '0408' → Flight connection ID।
*airport_from_id = 'FRA' → Frankfurt Airport।
*airport_to_id = 'NRT' → Narita Airport (Tokyo)।
*carrier_name = 'Japan Airlines' → Carrier name।
*
*
*
*
*
*Double brackets (( ... ))
*
*Outer brackets indicate कि यह एक table है जिसमें multiple rows हो सकती हैं।


**********************************************************************
    connections = VALUE #( ( carrier_id      = 'JL'
                                  connection_id   = '0408'
                                  airport_from_id = 'FRA'
                                  airport_to_id   = 'NRT'
                                  carrier_name    = 'Japan Airlines'
                                )
                                ( carrier_id      = 'AA'
                                  connection_id   = '0017'
                                  airport_from_id = 'MIA'
                                  airport_to_id   = 'HAV'
                                  carrier_name    = 'American Airlines'
                                )
                                ( carrier_id      = 'SQ'
                                  connection_id   = '0001'
                                  airport_from_id = 'SFO'
                                  airport_to_id   = 'SIN'
                                  carrier_name    = 'Singapore Airlines'
                                )
                                ( carrier_id      = 'UA'
                                  connection_id   = '0078'
                                  airport_from_id = 'SFO'
                                  airport_to_id   = 'SIN'
                                  carrier_name    = 'United Airlines'
                                )

     ).

    carriers = VALUE #(  (  carrier_id    = 'SQ'
                           currency_code = ' '
                        )
                        (  carrier_id    = 'JL'
                           currency_code = ' '
                        )
                        (  carrier_id    = 'AA'
                           currency_code = ' '
                        )
                        (  carrier_id    = 'UA'
                           currency_code = ' '
                        )
                     ).


* Example 1: Table Expression with Key Access
**********************************************************************
    out->write(  `--------------------------------------------` ).
    out->write(  `Example 1: Table Expressions with Key Access` ).

    "This will return all the data of connections with name as Internal Table connections.
    out->write(  data = connections
                 name = `Internal Table CONNECTIONS: ` ).

    "With key fields.
*----------------------------------------------------------------------------------
* 1. connections[ ... ]
*
*यह table expression है।
*connections आपका internal table है (sorted table of st_connection).
*[ carrier_id = 'SQ' connection_id = '0001' ]
*
*इसका मतलब है: उस row को fetch करो जहाँ carrier_id = 'SQ' और connection_id = '0001'।
*
*
*क्योंकि यह sorted table है और आपने key define की है (carrier_id, connection_id), ABAP binary search करेगा → बहुत fast lookup।
*
*✅ 2. connection = ...
*
*Result को connection work area में assign कर दिया गया।
*अगर matching row नहीं मिली तो runtime error होगा (जब तक आप OPTIONAL keyword use नहीं करते)।
*
*-----------------------------------------------------------------------------------------------------------------------------------


    " with key fields
    connection = connections[ carrier_id    = 'SQ'
                              connection_id = '0001' ].

    out->write(  data = connection
                 name = `------------------CARRIER_ID = 'SQ' AND CONNECTION_ID = '001':` ).


    " with non-key fields
    connection = connections[ airport_from_id = 'SFO'
                              airport_to_id   = 'SIN' ].
    out->write(  data = connection
                 name = `-------------------AIRPORT_FROM_ID = 'SFO' AND AIRPORT_TO_ID = 'SIN':` ).



* Example 2: LOOP with key access
**********************************************************************

    out->write(  `---------------------------------------------------------------------------` ).
    out->write(  `Example 2: LOOP with Key Access` ).

    LOOP AT connections INTO connection
                       WHERE airport_from_id <> 'MIA'.

      "do something with the content of connection
      out->write( data = connection
                  name = |This is row number { sy-tabix }: | ).

    ENDLOOP.


* Example 3: MODIFY TABLE (key access)
**********************************************************************
    out->write(  `-----------------------------------` ).
    out->write(  `Example 3: MODIFY TABLE (key access` ).

    out->write( data = carriers
                name = `------------------------------------------------Table Carriers before modify table: `
              ).

    "fetch data of carriers with giving condition on carrier_id = jl and store in workarea.
    carrier = carriers[ carrier_id = 'JL' ].
    carrier-currency_code = 'jpy'.

    "Modify table
    MODIFY TABLE carriers FROM carrier.

    out->write(  data = carriers
           name = `Table CARRRIERS after MODIFY TABLE:`).


* Example 4: MODIFY (index access)
**********************************************************************
    out->write(  `--------------------------------` ).
    out->write(  `Example 4: MODIFY (index access)` ).

    carrier-carrier_id    = 'LH'.
    carrier-currency_code = 'EUR'.
    MODIFY carriers FROM carrier INDEX 1.

    out->write(  data = carriers
                 name = `Table CARRRIERS after MODIFY:`).


* Example 5: MODIFY in a LOOP
**********************************************************************
    out->write(  `----------------------------` ).
    out->write(  `Example 5: MODIFY  in a LOOP` ).

    LOOP AT carriers INTO carrier
                    WHERE currency_code IS INITIAL.

      carrier-currency_code = 'USD'.
      MODIFY carriers FROM carrier.

    ENDLOOP.

      out->write(  data = carriers
                 name = `Table CARRRIERS after the LOOP:`).

  ENDMETHOD.
ENDCLASS.
