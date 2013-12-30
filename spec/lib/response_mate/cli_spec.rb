# coding: utf-8

require 'spec_helper'

describe ResponseMate::CLI do
  describe '.package_name' do
    it 'names the tool response_mate' do
      content = capture(:stdout) { ResponseMate::CLI.start %w[help] }
      expect(content).to match(/response_mate commands:/m)
    end
  end

  let(:command) { double(run: 'yay') }

  describe '#record' do
    before do
      allow(ResponseMate::Commands::Record).to receive(:new).and_return(command)
    end

    it 'initializes ResponseMate::Commands::Record' do
      expect(ResponseMate::Commands::Record).to receive(:new)
      capture(:stdout) { ResponseMate::CLI.start %w[record] }
    end

    it 'runs the command passing any given options, arguments' do
      expect(command).to receive(:run)
      capture(:stdout) { ResponseMate::CLI.start %w[record] }
    end
  end

  describe'#inspect' do
    before do
      allow(ResponseMate::Commands::Inspect).to receive(:new).and_return(command)
    end

    it 'initializes ResponseMate::Commands::Inspect' do
      expect(ResponseMate::Commands::Inspect).to receive(:new)
      capture(:stdout) { ResponseMate::CLI.start %w[inspect] }
    end

    it 'runs the command passing any given options, arguments' do
      expect(command).to receive(:run)
      capture(:stdout) { ResponseMate::CLI.start %w[inspect] }
    end
  end

  describe '#setup' do
    before do
      allow(ResponseMate::Commands::Setup).to receive(:new).and_return(command)
    end

    it 'initializes ResponseMate::Commands::setup' do
      expect(ResponseMate::Commands::Setup).to receive(:new)
      capture(:stdout) { ResponseMate::CLI.start %w[setup] }
    end

    it 'runs the command passing any given options, arguments' do
      expect(command).to receive(:run)
      capture(:stdout) { ResponseMate::CLI.start %w[setup] }
    end
  end

  describe '#clear' do
    before do
      allow(ResponseMate::Commands::Clear).to receive(:new).and_return(command)
    end

    it 'initializes ResponseMate::Commands::Clear' do
      expect(ResponseMate::Commands::Clear).to receive(:new)
      capture(:stdout) { ResponseMate::CLI.start %w[clear] }
    end

    it 'runs the command passing any given options, arguments' do
      expect(command).to receive(:run)
      capture(:stdout) { ResponseMate::CLI.start %w[clear] }
    end
  end

  describe '#list' do
    before do
      allow(ResponseMate::Commands::List).to receive(:new).and_return(command)
    end

    it 'initializes ResponseMate::Commands::List' do
      expect(ResponseMate::Commands::List).to receive(:new)
      capture(:stdout) { ResponseMate::CLI.start %w[list] }
    end

    it 'runs the command passing any given options, arguments' do
      expect(command).to receive(:run)
      capture(:stdout) { ResponseMate::CLI.start %w[list] }
    end
  end

  describe '#export' do
    before do
      allow(ResponseMate::Commands::Export).to receive(:new).and_return(command)
    end

    it 'initializes ResponseMate::Commands::Export' do
      expect(ResponseMate::Commands::Export).to receive(:new)
      capture(:stdout) { ResponseMate::CLI.start %w[export] }
    end

    it 'runs the command passing any given options, arguments' do
      expect(command).to receive(:run)
      capture(:stdout) { ResponseMate::CLI.start %w[export] }
    end
  end
end
