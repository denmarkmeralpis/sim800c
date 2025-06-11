# frozen_string_literal: true

module Sim800c
  module Commands
    class SendMessage
      include Helpers

      def initialize(serial)
        @serial = serial
      end

      # Sends the message immediately using AT+CMGS
      def send_immediate(phone_number, message)
        at_cmd('AT+CMGF=1')
        @serial.read(100)

        at_cmd("AT+CMGS=\"#{phone_number}\"")
        @serial.read(100)

        at_cmd("#{message}#{26.chr}")
        response = read_response(wait_time: 1)
        response[-10, 10].include?("\r\nOK\r\n")
      end

      # Stores and sends the message using AT+CMGW and AT+CMSS
      def save_and_send(phone_number, message)
        at_cmd('AT+CMGF=1')
        @serial.read(100)

        at_cmd("AT+CMGW=\"#{phone_number}\"")
        @serial.read(100)

        at_cmd("#{message}#{26.chr}")
        response = read_response(wait_time: 1)
        index = response[/\+CMGW:\s*(\d+)/, 1]

        at_cmd("AT+CMSS=#{index}") if index
        response = read_response(wait_time: 1)
        response[-10, 10].include?("\r\nOK\r\n")
      end
    end
  end
end
