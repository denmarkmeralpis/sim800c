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
        response = read_response(wait_time: 1)
        return_or_raise_error!(response)
      end
    end
  end
end
