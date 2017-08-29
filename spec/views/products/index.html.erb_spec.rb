require 'rails_helper'

RSpec.describe "products/index", type: :view do
  before(:each) do
    assign(:products, [
      Product.create!(
        :price => "9.99",
        :title => "Title",
        :number_of_reviews => 2,
        :best_seller_rank => 3,
        :inventory => 4
      ),
      Product.create!(
        :price => "9.99",
        :title => "Title",
        :number_of_reviews => 2,
        :best_seller_rank => 3,
        :inventory => 4
      )
    ])
  end

  it "renders a list of products" do
    render
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
