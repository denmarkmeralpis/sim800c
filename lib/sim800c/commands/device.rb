# frozen_string_literal: true

module Sim800c
  module Commands
    class Device
      include Helpers

      def initialize(serial)
        @serial = serial
      end

      def battery_info
        at_cmd('AT+CBC')
        parse_cbc_response(@serial.read(1024))
      end

      private

      def parse_cbc_response(response)
        if match = response.match(/\+CBC:\s*(\d+),(\d+),(\d+)/)
          bcs, bcl, voltage = match.captures.map(&:to_i)

          result = {
            charge_status: bcs, # 0 = not charging, 1 = charging
            battery_level: bcl,
            voltage_mv: voltage
          }

          result
        else
          'No valid +CBC line found.'
        end
      end
    end
  end
end
