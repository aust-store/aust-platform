require "geography/brazilian_states"

describe Geography::BrazilianStates do
  describe "#states_codes" do
    it "returns only the codes of the states" do
      states = %w[AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RS RN RO RR SC SP SE TO]
      expect(described_class.states_codes).to eq states
    end
  end
end
