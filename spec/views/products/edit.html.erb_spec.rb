require 'rails_helper'

RSpec.describe "products/edit", type: :view do
  before(:each) do
    @product = assign(:product, Product.create!(
      :price => "9.99",
      :title => "MyString",
      :number_of_reviews => 1,
      :best_seller_rank => 1,
      :inventory => 1
    ))
  end

  it "renders the edit product form" do
    render

    assert_select "form[action=?][method=?]", product_path(@product), "post" do

      assert_select "input[name=?]", "product[price]"

      assert_select "input[name=?]", "product[title]"

      assert_select "input[name=?]", "product[number_of_reviews]"

      assert_select "input[name=?]", "product[best_seller_rank]"

      assert_select "input[name=?]", "product[inventory]"
    end
  end
end
