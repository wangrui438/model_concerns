require 'spec_helper'

describe "Protectable" do

  it 'should Protectable' do
    with_mocked_tables do |m|
      m.create_table do |t|
        t.model_name :FooProtectable

        t.layout do |l|
        end
      end

      class FooProtectable < ActiveRecord::Base
        include ModelConcerns::Protectable
      end

      expect(FooProtectable.new.fake_id).to be_nil
      expect(FooProtectable.xor_key).to eq(Digest::MD5.hexdigest(FooProtectable.name))
      expect(FooProtectable.protectable?).to eq(true)

      p FooProtectable.xor_key
      1000.times do
        model = FooProtectable.create
        p model.fake_id
        expect(model.fake_id).not_to be_nil
        expect(model.id).to eq(FooProtectable.find_id_by_fake_id(model.fake_id))
        expect(model.id).to eq(FooProtectable.find_by_fake_id(model.fake_id).id)
      end

      model = FooProtectable.create
      model2 = FooProtectable.create
      expect(model2.fake_id).not_to eq(model.fake_id)
    end
  end
end