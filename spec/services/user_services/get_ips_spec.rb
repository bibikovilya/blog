describe UserServices::GetIps do
  describe '.call' do
    let(:user1) { create :user, login: 'first' }
    let(:user2) { create :user, login: 'second' }
    let(:user3) { create :user, login: 'third' }
    let!(:user4) { create :user, login: 'fourth' }

    before do
      create :post, user: user1, ip: '128.0.0.11/32'
      create :post, user: user1, ip: '128.0.0.12/32'

      create :post, user: user2, ip: '128.0.0.11/32'
      create :post, user: user2, ip: '128.0.0.22/32'
      create :post, user: user2, ip: '128.0.0.23/32'

      create :post, user: user3, ip: '128.0.0.11/32'
      create :post, user: user3, ip: '128.0.0.31/32'
      create :post, user: user3, ip: '128.0.0.12/32'
      create :post, user: user3, ip: '128.0.0.23/32'
    end

    subject { UserServices::GetIps.call }

    it 'should return logins by ip' do
      expect(logins_by_ip(subject, '128.0.0.11/32')).to eq ['first', 'second', 'third']
      expect(logins_by_ip(subject, '128.0.0.12/32')).to eq ['first', 'third']
      expect(logins_by_ip(subject, '128.0.0.22/32')).to eq ['second']
      expect(logins_by_ip(subject, '128.0.0.23/32')).to eq ['second', 'third']
      expect(logins_by_ip(subject, '128.0.0.31/32')).to eq ['third']
    end
  end
end
