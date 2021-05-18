# frozen_string_literal: true

require('criteria_store')

RSpec.describe CriteriaStore do
  subject(:criteria_store) { described_class.new(example_criteria) }

  let(:latest_entry) do
    {
      'updated_at' => '2021-03-08T17:09:00+00:00',
      'criteria' => [
        'you are aged 55 or over',
        'you are at high risk from coronavirus (clinically extremely vulnerable)',
        'you are an eligible frontline health or social care worker',
        'you have a condition that puts you at higher risk (clinically vulnerable)',
        'you have a learning disability',
        'you are a main carer for someone at high risk from coronavirus'
      ]
    }
  end
  let(:example_criteria) do
    [
      {
        'updated_at' => '2021-03-03T17:25:00+00:00',
        'criteria' => [
          'you are aged 60 or over',
          'you are at high risk from coronavirus (clinically extremely vulnerable)',
          'you are an eligible frontline health or social care worker',
          'you have a condition that puts you at higher risk (clinically vulnerable)',
          'you are a main carer for someone at high risk from coronavirus'
        ]
      },
      latest_entry
    ]
  end

  describe '#latest' do
    it 'returns the most recently captured criteria' do
      expect(criteria_store.latest).to eq latest_entry
    end
  end

  describe '#criteria' do
    it 'returns all the criteria' do
      expect(criteria_store.criteria).to eq example_criteria
    end
  end

  describe '#add' do
    let(:updated_at) { '2021-04-30T06:52:00+01:00' }

    context 'when the criteria is not a duplicate' do
      let(:new_criteria) do
        [
          'you are aged 40 or over',
          'you are at high risk from coronavirus (clinically extremely vulnerable)',
          'you are an eligible frontline health or social care worker',
          'you have a condition that puts you at higher risk (clinically vulnerable)',
          'you have a learning disability',
          'you are a main carer for someone at high risk from coronavirus',
          'you are in a higher risk profession'
        ]
      end

      it 'stores the updated_at timestamp' do
        criteria_store.add(new_criteria, updated_at)
        expect(criteria_store.latest['updated_at']).to eq updated_at
      end

      it 'stores the criteria' do
        criteria_store.add(new_criteria, updated_at)
        expect(criteria_store.latest['criteria']).to match_array(new_criteria)
      end
    end

    context 'when the criteria is a duplicate' do
      let(:duplicate_criteria) do
        [
          'you are aged 55 or over',
          'you are at high risk from coronavirus (clinically extremely vulnerable)',
          'you are an eligible frontline health or social care worker',
          'you have a condition that puts you at higher risk (clinically vulnerable)',
          'you have a learning disability',
          'you are a main carer for someone at high risk from coronavirus'
        ]
      end

      it 'raises an error' do
        expect do
          criteria_store.add(duplicate_criteria, updated_at)
        end.to raise_error(CriteriaStore::DuplicateCriteriaError)
      end
    end
  end
end
