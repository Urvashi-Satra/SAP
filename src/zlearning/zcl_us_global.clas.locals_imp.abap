*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_connection DEFINITION .

  PUBLIC SECTION.

    DATA : carrier_id    TYPE /dmo/carrier_id ,    "scope instance
           connection_id TYPE /dmo/connection_id. "scope instance

    CLASS-DATA con_counter TYPE i . " Static variable


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



  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_connection IMPLEMENTATION.



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

ENDCLASS.
