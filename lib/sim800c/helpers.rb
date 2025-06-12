# frozen_string_literal: true

module Sim800c
  module Helpers
    def at_cmd(cmd, wait_time: 0.2)
      @serial.write("#{cmd}\r")
      sleep(wait_time)
    end

    def read_response(wait_time: 0.2, bytes: 1024)
      response = String.new

      loop do
        chunk = @serial.read(bytes)
        response << chunk
        break if chunk.include?("\r\nOK\r\n") || chunk.include?("\r\nERROR\r\n")

        sleep(wait_time)
      end

      response
    end

    def parse_cmgl_response(response) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      messages = []
      lines = response.split("\r\n").reject(&:empty?)

      i = 0
      while i < lines.length
        if lines[i].start_with?('+CMGL:')
          header = lines[i]
          message_lines = []

          # Collect message body lines until next +CMGL or end
          i += 1
          while i < lines.length && !lines[i].start_with?('+CMGL:')
            message_lines << lines[i]
            i += 1
          end

          # Parse the header
          if header =~ /^\+CMGL:\s*(\d+),"(.*?)","(.*?)",".*?","(.*?)"$/
            index = ::Regexp.last_match(1).to_i
            status = ::Regexp.last_match(2)
            sender = ::Regexp.last_match(3)
            datetime = ::Regexp.last_match(4)

            date, time = datetime.split(',', 2)
            message = message_lines.join("\n").strip

            messages << {
              index: index,
              status: status,
              sender: sender,
              date: date,
              time: time,
              message: message,
              unread: (status == 'REC UNREAD')
            }
          end
        else
          i += 1
        end
      end

      messages
    end

    def return_or_raise_error!(response)
      return true if response.include?("\r\nOK\r\n")

      if response.include?("\r\nERROR: 302")
        raise OperationNotAllowed, 'Operation not allowed'
      elsif response.include?("\r\nERROR: 512")
        raise SimNotFound, 'SIM failure or not inserted'
      elsif response.include?("\r\nERROR: 321")
        raise InvalidIndex, 'Index not found'
      else
        raise Error, response
      end
    end
  end
end
