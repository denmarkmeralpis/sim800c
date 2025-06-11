# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sim800c::Commands::SendMessage do
  let(:serial) { double(Serial) }
  let(:cmd) { described_class.new(serial) }

  before do
    allow(Serial).to receive(:new).and_return(serial)
    allow(serial).to receive(:write).and_return(serial)
  end

  describe '#send_immediate' do
    context 'when successful' do
      it 'returns true' do
        allow(serial).to receive(:read).and_return("\r\nOK\r\n")

        expect(cmd.send_immediate('+639123456789', 'Message Content')).to be(true)
      end
    end

    context 'when failure' do
      it 'returns false' do
        allow(serial).to receive(:read).and_return("\r\nERROR\r\n")

        expect(cmd.send_immediate('+639123456789', 'Message Content')).to be(false)
      end
    end
  end

  describe '#save_and_send' do
    context 'when successful' do
      it 'returns true' do
        allow(serial).to receive(:read).and_return("+CMGW: 1\r\nOK\r\n")

        expect(cmd.save_and_send('+639123456789', 'Message Content')).to be(true)
      end
    end

    context 'when failure' do
      it 'returns false' do
        allow(serial).to receive(:read).and_return("\r\nERROR\r\n")

        expect(cmd.save_and_send('+639123456789', 'Message Content')).to be(false)
      end
    end
  end
end
