# frozen_string_literal: true

module Sim800c
  module Commands
    class SignalQuality
      include Helpers

      def initialize(serial)
        @serial = serial
      end

      def info
        rssi_level = rssi
        return { rssi: nil, bars: 0, strength: 'Unknown' } unless rssi_level

        {
          rssi: rssi_level,
          bars: bars(rssi_level),
          strength: strength(rssi_level)
        }
      end

      def rssi
        at_cmd('AT+CSQ')
        response = @serial.read(100)
        return unless response =~ /\+CSQ:\s*(\d+),/

        ::Regexp.last_match(1).to_i
      end

      private

      def strength(val)
        case val
        when 0..9 then 'Weak'
        when 10..14 then 'Moderate'
        when 15..19 then 'Good'
        when 20..24 then 'Strong'
        when 25..31 then 'Excellent'
        else 'Unknown'
        end
      end

      def bars(val)
        case val
        when 0..9 then 1
        when 10..14 then 2
        when 15..19 then 3
        when 20..24 then 4
        when 25..31 then 5
        else 0
        end
      end
    end
  end
end
