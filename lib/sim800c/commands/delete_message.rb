# frozen_string_literal: true

module Sim800c
  module Commands
    class DeleteMessage
      include Helpers

      def initialize(serial)
        @serial = serial
      end

      def by_index(index)
        perform_delete!("AT+CMGD=#{index}")
      end

      def all
        perform_delete!('AT+CMGD=1,4')
      end

      def all_read
        perform_delete!('AT+CMGD=1,1')
      end

      def all_read_and_sent
        perform_delete!('AT+CMGD=1,2')
      end

      def all_read_sent_and_unsent
        all
      end

      private

      def perform_delete!(cmd)
        at_cmd(cmd)
        response = read_cmg_response
        return_or_raise_error!(response)
      end

      def read_cmg_response
        response = String.new

        loop do
          chunk = @serial.read(1024)
          response << chunk
          break if chunk.include?('OK') || chunk.include?('ERROR')

          sleep(0.3)
        end

        response
      end
    end
  end
end
