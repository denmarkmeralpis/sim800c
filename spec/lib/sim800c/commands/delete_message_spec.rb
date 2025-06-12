# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sim800c::Commands::DeleteMessage do
  let(:serial) { double(Serial) }
  let(:cmd) { described_class.new(serial) }

  before do
    allow(Serial).to receive(:new).and_return(serial)
    allow(serial).to receive(:write).and_return(serial)
  end

  describe '#by_index' do
    context 'when response is OK' do
      it 'returns true' do
        output = "AT+CMGD=1\r\nOK\r\n"
        allow(serial).to receive(:read).and_return(output)

        expect(cmd.by_index(1)).to be(true)
      end
    end

    context 'when response is ERROR: 302' do
      it 'raises OperationNotAllowed error' do
        output = "AT+CMGD=1\r\r\nERROR: 302\r\n"
        allow(serial).to receive(:read).and_return(output)

        expect { cmd.by_index(1) }.to raise_error(Sim800c::OperationNotAllowed)
      end
    end

    context 'when response is ERROR: 512' do
      it 'raises SimNotFound error' do
        output = "AT+CMGD=1\r\r\nERROR: 512\r\n"
        allow(serial).to receive(:read).and_return(output)

        expect { cmd.by_index(1) }.to raise_error(Sim800c::SimNotFound)
      end
    end

    context 'when response is ERROR: 321' do
      it 'raises InvalidIndex error' do
        output = "AT+CMGD=1\r\r\nERROR: 321\r\n"
        allow(serial).to receive(:read).and_return(output)

        expect { cmd.by_index(1) }.to raise_error(Sim800c::InvalidIndex)
      end
    end

    context 'when response is unknown' do
      it 'raises Error error' do
        output = "AT+CMGD=1\r\r\nERROR\r\n"
        allow(serial).to receive(:read).and_return(output)

        expect { cmd.by_index(1) }.to raise_error(Sim800c::Error)
      end
    end
  end

  describe '#all' do
    it 'returns true' do
      output = "AT+CMGD=1,4\r\r\nOK\r\n"
      allow(serial).to receive(:read).and_return(output)

      expect(cmd.all).to be(true)
    end
  end

  describe '#all_read' do
    it 'returns true' do
      output = "AT+CMGD=1,1\r\r\nOK\r\n"
      allow(serial).to receive(:read).and_return(output)

      expect(cmd.all_read).to be(true)
    end
  end

  describe '#all_read_and_sent' do
    it 'returns true' do
      output = "AT+CMGD=1,2\r\r\nOK\r\n"
      allow(serial).to receive(:read).and_return(output)

      expect(cmd.all_read_and_sent).to be(true)
    end
  end

  describe '#all_read_sent_and_unsent' do
    it 'returns true' do
      output = "AT+CMGD=1,4\r\r\nOK\r\n"
      allow(serial).to receive(:read).and_return(output)

      expect(cmd.all_read_sent_and_unsent).to be(true)
    end
  end
end
