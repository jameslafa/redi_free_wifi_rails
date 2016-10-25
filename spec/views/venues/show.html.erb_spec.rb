require 'rails_helper'

RSpec.describe "venues/show", type: :view do
  before(:each) do
    @venue = assign(:venue, Venue.create!(
      :name => "Name",
      :description => "MyText",
      :category => 2,
      :latitude => 3.5,
      :longitude => 4.5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3.5/)
    expect(rendered).to match(/4.5/)
  end
end
