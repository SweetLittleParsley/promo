require 'spec_helper'
require 'promo/promocode'
require 'promo/usage'

RSpec.describe Promo::Usage do
  describe '#validate' do
    it "doesn't mind if used code is in different case" do
      promocode = Promo::Promocode.generate

      expect(promocode.code).to eq promocode.code.downcase
      expect { Promo::Usage.validate(code: promocode.code.upcase) }
        .not_to raise_error
    end

    it "also works fine if the stored code is upcased" do
      promocode = Promo::Promocode.generate
      promocode.update(code: 'BLAH')
      expect { Promo::Usage.validate(code: 'BLAH') }.not_to raise_error
    end
  end
end
