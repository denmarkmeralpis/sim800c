# frozen_string_literal: true

module Sim800c
  module Commands
    class ListMessages
      include Helpers

      def initialize(serial)
        @serial = serial
      end

      def all
        perform_message_query('AT+CMGL="ALL"')
      end

      def unread
        perform_message_query('AT+CMGL="REC UNREAD"')
      end

      def read
        perform_message_query('AT+CMGL="REC READ"')
      end

      def unsent
        perform_message_query('AT+CMGL="STO UNSENT"')
      end

      def sent
        perform_message_query('AT+CMGL="STO SENT"')
      end

      private

      def perform_message_query(command)
        at_cmd('AT')
        @serial.read(100)

        at_cmd('AT+CMGF=1')
        @serial.read(100)

        at_cmd(command)
        response = read_response(wait_time: 1)
        parse_cmgl_response(response)
      end
    end
  end
end
