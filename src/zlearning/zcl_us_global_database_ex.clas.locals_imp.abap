*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_connection DEFINITION .

  PUBLIC SECTION.

    DATA : carrier_id    TYPE /dmo/carrier_id ,    "scope instance
           connection_id TYPE /dmo/connection_id. "scope instance

    CLASS-DATA con_counter TYPE i READ-ONLY. " Static variable


    METHODS set_attributes
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id  DEFAULT 'LH'
        i_connection_id TYPE /dmo/connection_id
      RAISING
        cx_abap_invalid_value .

    METHODS get_attributes
      EXPORTING
        e_carrier_id    TYPE /dmo/carrier_id
        e_connection_id TYPE /dmo/connection_id.


    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
      RAISING
        cx_abap_invalid_value.
    "Functional methods
    METHODS get_output RETURNING VALUE(r_output) TYPE string_table.


  PROTECTED SECTION.
  PRIVATE SECTION.
*    DATA : carrier_id    TYPE /dmo/carrier_id ,    "scope instance
*           connection_id TYPE /dmo/connection_id. "scope instance

    DATA airport_from_id TYPE /dmo/airport_from_id.

    DATA airport_to_id   TYPE /dmo/airport_to_id.

ENDCLASS.

CLASS lcl_connection IMPLEMENTATION.

  METHOD constructor.
    IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.


    SELECT SINGLE
          FROM /dmo/connection
        FIELDS airport_from_id, airport_to_id
         WHERE carrier_id    = @i_carrier_id
           AND connection_id = @i_connection_id
          INTO ( @airport_from_id, @airport_to_id ).

    IF sy-subrc = 0 .
       carrier_id = i_carrier_id.
       connection_id = i_connection_id.
      con_counter = con_counter + 1 .
      Else.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.
  ENDMETHOD.



  METHOD get_attributes.
    e_carrier_id = carrier_id.
    e_connection_id = connection_id .

  ENDMETHOD.

  METHOD set_attributes.

    IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.
    carrier_id = i_carrier_id.
    connection_id = i_connection_id.
    con_counter = con_counter + 1 .

  ENDMETHOD.

  METHOD get_output.
    APPEND |--------| TO r_output.
    APPEND | carrier id : { carrier_id }| TO r_output.
    APPEND | connection id : { connection_id }| TO r_output.
    APPEND | Departure : { airport_from_id }| TO r_output.
    APPEND | Destination : { airport_to_id }| TO r_output.
  ENDMETHOD.

ENDCLASS.
