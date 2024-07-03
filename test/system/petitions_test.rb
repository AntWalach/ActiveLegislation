require "application_system_test_case"

class PetitionsTest < ApplicationSystemTestCase
  setup do
    @petition = petitions(:one)
  end

  test "visiting the index" do
    visit petitions_url
    assert_selector "h1", text: "Petitions"
  end

  test "should create petition" do
    visit petitions_url
    click_on "New petition"

    fill_in "Description", with: @petition.description
    fill_in "Title", with: @petition.title
    fill_in "User", with: @petition.user_id
    click_on "Create Petition"

    assert_text "Petition was successfully created"
    click_on "Back"
  end

  test "should update Petition" do
    visit petition_url(@petition)
    click_on "Edit this petition", match: :first

    fill_in "Description", with: @petition.description
    fill_in "Title", with: @petition.title
    fill_in "User", with: @petition.user_id
    click_on "Update Petition"

    assert_text "Petition was successfully updated"
    click_on "Back"
  end

  test "should destroy Petition" do
    visit petition_url(@petition)
    click_on "Destroy this petition", match: :first

    assert_text "Petition was successfully destroyed"
  end
end
