# frozen_string_literal: true

RSpec.describe Aide::SingletonWithArgs do
  it 'can only instantiate once'

  it 'creates reader methods for args' do
    expect(1).to eq 1
  end
end
