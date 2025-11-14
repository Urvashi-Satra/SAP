CLASS lhc_zr_flight DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Conn
        RESULT result,
      checkSemanticKey FOR VALIDATE ON SAVE
        IMPORTING keys FOR Conn~checkSemanticKey.
ENDCLASS.

CLASS lhc_zr_flight IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD checkSemanticKey.
    DATA: read_keys   TYPE TABLE FOR READ IMPORT zr_flight,
          connections TYPE TABLE FOR READ RESULT zr_flight.

    Data reported_record Like line of reported-conn.
    Data failed_record Like line of failed-conn.

    read_keys = CORRESPONDING #( keys ).

    READ ENTITIES OF zr_flight IN LOCAL MODE
       ENTITY Conn
       FIELDS ( uuid CarrierID ConnectionID )
         WITH read_keys
       RESULT connections.

    LOOP AT connections INTO DATA(connection).

      SELECT FROM z99flight
      FIELDS uuid
      WHERE carrier_id = @connection-CarrierID
      AND connection_id = @connection-ConnectionID
      AND uuid <> @connection-uuid

      UNION
       SELECT FROM zconn_d
      FIELDS uuid
      WHERE carrierid = @connection-CarrierID
      AND connectionid = @connection-ConnectionID
      AND uuid <> @connection-uuid

      INTO TABLE @DATA(check_result).

    If check_result is not initial.

      Data(message) = me->new_message(
                       id = 'ZTEXT' "Message class name
                       number = '001' " Message number
                       severity = ms-error
                       v1 = connection-CarrierID
                       v2 = connection-ConnectionID
                    ).


 " Fill reported structure

      CLEAR reported_record.
      reported_record-%tky                       = connection-%tky.
      reported_record-%msg                       = message.
      reported_record-%element-CarrierID         = if_abap_behv=>mk-on.
      reported_record-%element-ConnectionID      = if_abap_behv=>mk-on.

      APPEND reported_record TO reported-conn.


     clear failed_record.
     failed_record-%tky = connection-%tky.

     Append failed_record to failed-conn.

    endif.
    ENDLOOP.


  ENDMETHOD.

ENDCLASS.
