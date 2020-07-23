require_relative '../service'


describe Service do
  context "During week time " do
    before do
      @monday = Time.new(2020, 6, 1, 10, 00, 00)
      allow(Time).to receive(:now).and_return(@monday)

      @service = Service.new
    end

    it 'When two clients come at the same time' do
      expect(@service.add_reservation).to eq Time.now + 2 * 3600
      expect(@service.add_reservation).to eq Time.now + 2 * 3600
    end
  end
end