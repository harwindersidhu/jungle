require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    before(:each) do
      @product = Product.new do |p|
        p.name = "Test"
        p.price_cents = 8.99
        p.quantity = 2
        p.category = Category.new(name: "Testing")
      end
    end

    it "valid when all fields are present" do
      @product.save
      expect(@product.valid?).to be true
    end

    it "error if name is nil" do
      @product.name = nil
      @product.save
      expect(@product.errors.full_messages).to include("Name can't be blank")
    end

    it "error if price is nil" do
      @product.price_cents = nil
      @product.save
      expect(@product.errors.full_messages).to include("Price is not a number")
    end

    it "error if quantity is nil" do
      @product.quantity = nil
      @product.save
      expect(@product.errors.full_messages).to include("Quantity can't be blank")
    end

    it "error if category is nil" do
      @product.category = nil
      @product.save
      expect(@product.errors.full_messages).to include("Category must exist")
    end
  end
end
