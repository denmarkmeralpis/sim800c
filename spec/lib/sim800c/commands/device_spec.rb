# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sim800c::Commands::Device do
  let(:serial) { double(Serial) }
  let(:cmd) { described_class.new(serial) }

  before do
    allow(Serial).to receive(:new).and_return(serial)
    allow(serial).to receive(:write).and_return(serial)
  end

  describe '#battery_info' do
    context 'when +CBC line found' do
      it 'returns Hash' do
        output = "AT+CBC\r\r\n+CBC: 0,100,4378\r\n\r\nOK\r\n"
        allow(serial).to receive(:read).and_return(output)

        expect(cmd.battery_info).to be_a(Hash)
      end
    end

    context 'when +CBC line not found' do
      it 'returns "No valid +CBC line found." message' do
        output = "AT+\n\r\nERROR\r\n"
        allow(serial).to receive(:read).and_return(output)

        expect(cmd.battery_info).to eq('No valid +CBC line found.')
      end
    end
  end
end
