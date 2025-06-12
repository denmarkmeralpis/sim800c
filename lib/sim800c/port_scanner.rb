# frozen_string_literal: true

module Sim800c
  class PortScanner
    def self.find_port
      each_candidate do |port|
        serial = Serial.new(port, 9_600)
        serial.write("AT\r")
        sleep 0.3
        response = serial.read(64).to_s
        next unless response.include?('OK')

        serial.write("ATI\r")
        sleep 0.3
        info = serial.read(128).to_s
        serial.close

        return port if info =~ /SIM[-_ ]?800C/i
      rescue StandardError
        false
      ensure
        serial&.close
      end
    end

    def self.each_candidate(&block)
      ports =
        case RUBY_PLATFORM
        when /linux/
          Dir.glob('/dev/ttyUSB*') + Dir.glob('/dev/ttyACM*')
        when /darwin/
          Dir.glob('/dev/tty.usbmodem*') + Dir.glob('/dev/tty.usbserial*')
        when /mswin|mingw/
          (1..20).map { |i| "COM#{i}" }
        else
          []
        end

      ports.each(&block).first
    end
  end
end
