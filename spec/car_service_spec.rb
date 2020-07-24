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

    it 'When a client comes an hour before closing time ' do
      @day_end = Time.new(2020, 7, 20, 19, 00, 00) # this is a monday as well
      allow(Time).to receive(:now).and_return(@day_end)

      expect(@service.add_reservation).to eq Time.new(2020, 7, 21, 10, 00, 00) # tuesday morning
    end

    it 'When a third client comes at a busy time ' do
      @first_client_time = Time.new(2020, 7, 20, 15, 00, 00)
      @second_client_time = Time.new(2020, 7, 20, 15, 30, 00)
      @third_client_time = Time.new(2020, 7, 20, 15, 31, 00)

      # first client
      allow(Time).to receive(:now).and_return(@first_client_time)
      @service.add_reservation

      # second client
      allow(Time).to receive(:now).and_return(@second_client_time)
      @service.add_reservation

      # the third client should be programmed after the first client is processed, and not the second one
      allow(Time).to receive(:now).and_return(@third_client_time)
      expect(@service.add_reservation).to eq @first_client_time + 4 * 3600
    end

    it 'When too many clients come in the same time, they have to be delayed more than one day' do
      allow(Time).to receive(:now).and_return(@monday)

      20.times { @service.add_reservation }

      expect(@service.add_reservation).to eq Time.new(2020, 6, 3, 10, 00, 00) # 2 days later
    end
  end

  context 'During weekend' do
    before do
      @friday = Time.new(2020, 7, 24, 19, 00, 00)
      @saturday = Time.new(2020, 7, 25, 13, 30, 00)

      @service = Service.new
    end

    it 'When a client comes on a late Friday' do
      allow(Time).to receive(:now).and_return(@friday)

      expect(@service.add_reservation).to eq Time.new(2020, 7, 25, 11, 30, 00) # this is a Saturday
    end

    it 'When a client comes on a late Saturday ' do
      allow(Time).to receive(:now).and_return(@saturday)

      expect(@service.add_reservation).to eq Time.new(2020, 7, 27, 10, 00, 00) # this is a Monday
    end
  end
end