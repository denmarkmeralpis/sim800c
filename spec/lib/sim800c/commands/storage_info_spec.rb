# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sim800c::Commands::StorageInfo do
  let(:serial) { double(Serial) }

  before do
    output = '+CPMS: "SM",2,30,"SM",2,30,"SM",2,30'

    allow(Serial).to receive(:new).and_return(serial)
    allow(serial).to receive(:write).and_return(serial)
    allow(serial).to receive(:read).and_return(output)
  end

  describe '#call' do
    let(:cmd) { described_class.new(serial) }

    it 'returns Array' do
      expect(cmd.call).to be_a(Array)
    end
  end
end
