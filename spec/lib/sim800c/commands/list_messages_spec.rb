# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sim800c::Commands::ListMessages do
  let(:serial) { double(Serial) }
  let(:cmd) { described_class.new(serial) }

  before do
    allow(Serial).to receive(:new).and_return(serial)
    allow(serial).to receive(:write).and_return(serial)
  end

  describe '#all' do
    it 'returns an Arrray of Hash' do
      output = "AT+CMGL=\"ALL\"\r\r\n+CMGL: 1,\"REC READ\",\"SMART\",\"\",\"25/06/11,13:00:05+32\"\r\nHello world\r\n\r\nOK\r\n"
      allow(serial).to receive(:read).and_return(output)

      expect(cmd.all).to be_a(Array)
    end
  end

  describe '#unread' do
    it 'returns an Arrray of Hash' do
      output = "AT+CMGL=\"ALL\"\r\r\n+CMGL: 1,\"REC UNREAD\",\"SMART\",\"\",\"25/06/11,13:00:05+32\"\r\nHello world\r\n\r\nOK\r\n"
      allow(serial).to receive(:read).and_return(output)

      expect(cmd.unread).to be_a(Array)
    end
  end

  describe '#read' do
    it 'returns an Arrray of Hash' do
      output = "AT+CMGL=\"ALL\"\r\r\n+CMGL: 1,\"REC READ\",\"SMART\",\"\",\"25/06/11,13:00:05+32\"\r\nHello world\r\n\r\nOK\r\n"
      allow(serial).to receive(:read).and_return(output)

      expect(cmd.read).to be_a(Array)
    end
  end

  describe '#unsent' do
    it 'returns an Arrray of Hash' do
      output = "AT+CMGL=\"ALL\"\r\r\n+CMGL: 1,\"STO UNSENT\",\"SMART\",\"\",\"25/06/11,13:00:05+32\"\r\nHello world\r\n\r\nOK\r\n"
      allow(serial).to receive(:read).and_return(output)

      expect(cmd.unsent).to be_a(Array)
    end
  end

  describe '#sent' do
    it 'returns an Arrray of Hash' do
      output = "AT+CMGL=\"ALL\"\r\r\n+CMGL: 1,\"STO USENT\",\"SMART\",\"\",\"25/06/11,13:00:05+32\"\r\nHello world\r\n\r\nOK\r\n"
      allow(serial).to receive(:read).and_return(output)

      expect(cmd.sent).to be_a(Array)
    end
  end
end
