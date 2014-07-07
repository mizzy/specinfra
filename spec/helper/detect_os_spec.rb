require 'spec_helper'

describe SpecInfra::Helper::DetectOS do
  shared_context 'no ssh connection' do
    before do
      SpecInfra.stub_chain(:configuration, :ssh).and_return(nil)
    end
  end
  shared_context 'existing ssh connection' do |hostname|
    before do
      ssh_session.stub(:host).and_return(hostname)
      SpecInfra.stub_chain(:configuration, :ssh).and_return(ssh_session)
    end
  end
  shared_examples 'derive os from backend' do |os|
    before do
      backend.stub(:check_os).and_return(os)
    end

    it 'returns the os derived by the backend ' do
      expect(subject.os).to eq os
    end
  end
  shared_examples 'derive os from cached property' do |os|
    it 'returns the os derived by the property ' do
      expect(subject.os).to eq os
    end
  end

  let(:subject) { Object.new.extend SpecInfra::Helper::DetectOS }
  let(:backend) { double('backend') }
  let(:ssh_session) { double('ssh') }

  before do
    subject.stub(:backend).and_return(backend)
  end
  
  describe '#os' do
    context 'using the backend to retrieve the os' do
      context 'no cached values' do
        before do
          subject.property[:os_by_host] = nil
        end

        context 'with localhost' do
          include_context 'no ssh connection'
          after do
            expect(subject.property[:os_by_host]).to eq({'localhost' => 'test os'})
          end

          include_examples 'derive os from backend', 'test os'
        end
    
        context 'with ssh' do
          include_context 'existing ssh connection', 'test.host'
          after do
            expect(subject.property[:os_by_host]).to eq({'test.host' => 'test os'})
          end

          include_examples 'derive os from backend', 'test os'
        end
      end

      context 'existing cached values' do
        before do
          subject.property[:os_by_host] = {'test.host' => 'cached os'}
        end

        context 'with localhost' do
          include_context 'no ssh connection'
          after do
            expect(property[:os_by_host]).to eq({'test.host' => 'cached os', 'localhost' => 'test os'})
          end

          include_examples 'derive os from backend', 'test os'
        end

        context 'with ssh' do
          include_context 'existing ssh connection', 'test.another.host'
          after do
            expect(property[:os_by_host]).to eq({'test.host' => 'cached os', 'test.another.host' => 'test os'})
          end

          include_examples 'derive os from backend', 'test os'
        end
      end
    end

    context 'using cached values to retrieve the os' do
      before do
        subject.property[:os_by_host] = {'test.host' => 'test os', 'localhost' => 'local os'}
      end
      context 'with localhost' do
        include_context 'no ssh connection'

        include_examples 'derive os from cached property', 'local os'
      end

      context 'with ssh' do
        include_context 'existing ssh connection', 'test.host'

        include_examples 'derive os from cached property', 'test os'
      end
    end
  end
end