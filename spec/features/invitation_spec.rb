require 'spec_helper'

describe "inviting a team member / user" do
  sign_in_owner

  it 'owner can fillout the form to invite a team member' do
    reset_email!
    click_link "Account Settings"
    within "#new_user" do
      fill_in "user_email", :with => "invite@helpful.io"
      click_on "Send"
    end
    
    expect(email_count).to eq 1
  end
end

describe "a new teammember can join via the invitation" do
  let(:user){ create(:user_with_account) }
  let(:new_user){ create(:user) }

  before do
    account = user.primary_owned_account
    account.memberships.create(role: 'owner', user: new_user)
    new_user.invite!
  end

  it 'allows the new_user to signup' do
    visit accept_user_invitation_url(:invitation_token => new_user.raw_invitation_token)
    fill_in "user_first_name", :with => "Jess"
    fill_in "user_last_name", :with => "Brown"
    fill_in "person_username", :with => "jess"
    fill_in "user_email", :with => "helper@helpful.io"
    fill_in "user_password", :with => "xxx123423423xxx"
    fill_in "user_password_confirmation", :with => "xxx123423423xxx"
    click_on "Create my account"
    expect(page.current_path).to match("inbox")
    expect(page).to have_selector(".alert", "You are now signed in")
  end
end
