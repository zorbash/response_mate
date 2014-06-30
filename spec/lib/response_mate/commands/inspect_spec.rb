# coding: utf-8

require 'spec_helper'

describe ResponseMate::Commands::Inspect do
  include_context 'stubbed_requests'

  describe '#run' do
    context 'when not in interactive mode' do
      before do
        ResponseMate::Commands::Inspect.new(['user_issues'], {}).run
      end

      it 'koko' do

      end
    end

    context 'when in interactive mode' do

    end
  end
end
