# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sim800c::Commands::SignalQuality do
  let(:serial) { double(Serial) }
  let(:cmd) { described_class.new(serial) }

  before do
    allow(Serial).to receive(:new).and_return(serial)
    allow(serial).to receive(:write).and_return(serial)
  end

  describe '#info' do
    it 'returns a Hash' do
      output = "AT+CSQ\r\r\n+CSQ: 15,0\r\n\r\nOK\r\n"
      allow(serial).to receive(:read).and_return(output)

      expect(cmd.info).to be_a(Hash)
    end
  end

  describe '#rssi' do
    before do
      output = "AT+CSQ\r\r\n+CSQ: 15,0\r\n\r\nOK\r\n"
      allow(serial).to receive(:read).and_return(output)
    end

    it 'returns an Integer value' do
      expect(cmd.rssi).to be_a(Integer)
    end

    it 'returns 15 value' do
      expect(cmd.rssi).to eq(15)
    end
  end
end
