# frozen_string_literal: true

RSpec.describe Aide::Enumerable::Recursor do
  it 'has all passing tests; it\'s perfect' do
    x = described_class.new [
      1,
      2,
      3,
      described_class.new([
        9,
        8,
        7,
        described_class.new({ oh: :snap,
                              two: %i[things] })
      ])
    ]

    expect(x.each_with_object([]) { |e, arr| arr << e }).to eq([
      1,
      2,
      3,
      9,
      8,
      7,
      %i[oh snap],
      [:two, [:things] ] # :things is not flat as it wasn't wrapped
    ])
  end
end
