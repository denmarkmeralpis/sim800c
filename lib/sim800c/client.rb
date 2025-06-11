require_relative 'helpers'
require_relative 'commands/send_message'
require_relative 'commands/list_messages'
require_relative 'commands/signal_quality'
require_relative 'commands/delete_message'
require_relative 'commands/storage_info'
require_relative 'commands/device'

module Sim800c
  class Client
    include Helpers

    def initialize(port_path, baud: 9600)
      require 'rubyserial'
      @serial = Serial.new(port_path, baud)
    end

    # Sends message immediately (does not store sent messages)
    def send_message(phone_number, message)
      Commands::SendMessage.new(@serial).send_immediate(phone_number, message)
    end

    # Store and send (AT+CMGW = store, AT+CMSS = send)
    def save_and_send_message(phone_number, message)
      Commands::SendMessage.new(@serial).save_and_send(phone_number, message)
    end

    # Methods: .all, .unread, .read, .unsent, .sent (Hash)
    def list_messages
      Commands::ListMessages.new(@serial)
    end

    # Methods: .info (Hash), .rssi (Integer)
    def signal_quality
      Commands::SignalQuality.new(@serial)
    end

    # Methods: .by_index, .all_read, .all_read_and_sent, .all_read_sent_and_unsent
    def delete_message
      Commands::DeleteMessage.new(@serial)
    end

    # Checks storage info
    def storage_info
      Commands::StorageInfo.new(@serial).call
    end

    # Methods: .battery_info
    def device
      Commands::Device.new(@serial)
    end
  end
end
