# frozen_string_literal: true

module Sim800c
  module Commands
    class StorageInfo
      include Helpers

      def initialize(serial)
        @serial = serial
      end

      def call
        at_cmd('AT+CPMS?')
        response = @serial.read(1024)
        parse_cpms_response(response)
      end

      private

      def parse_cpms_response(response)
        matches = response.scan(/"(\w+)",(\d+),(\d+)/)
        matches.each_with_index.map do |(mem, used, total), i|
          {
            storage_type: %w[read_write write_only receive_only][i],
            memory: mem,
            used: used.to_i,
            total: total.to_i
          }
        end
      end
    end
  end
end
