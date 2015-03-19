require 'spec_helper'

describe 'Users', js: true, type: :feature do
  let!(:user) do
    User.create(avatar: File.open("#{Rails.root}/spec/fixtures/avatar.jpg"))
  end

  let(:created_user) { User.last }

  def file_input
    find('input[type=file]', visible: false)
  end

  describe '#new + #create' do
    it 'functions properly' do
      visit new_user_path
      file_input.set "#{Rails.root}/spec/fixtures/avatar2.jpg"

      expect do
        click_button 'Submit'
        sleep 1
      end.to change { User.count }.by(1)

      expect(created_user.avatar.file.filename).to eq 'avatar2.jpg'
    end
  end

  describe '#edit + #update' do
    it 'uploads via AJAX' do
      user.update(remove_avatar: true)
      expect(user.avatar).to be_blank
      visit edit_user_path(user)

      # Initial visibility expectations
      expect(page).to_not have_selector 'input[type=file]'
      expect(page).to_not have_selector 'a', text: 'Remove'

      file_input.set "#{Rails.root}/spec/fixtures/avatar2.jpg"
      sleep 1
      expect(user.reload.avatar).to_not be_blank
      expect(user.avatar.file.filename).to eq 'avatar2.jpg'
    end

    it 'removes via AJAX' do
      expect(user.avatar).to_not be_blank
      visit edit_user_path(user)
      find('a', text: 'Remove').click
      expect(user.reload.avatar).to be_blank
    end

    it 'adds after removal' do
      visit edit_user_path(user)
      find('a', text: 'Remove').click
      expect(user.reload.avatar).to be_blank
      file_input.set "#{Rails.root}/spec/fixtures/avatar2.jpg"
      sleep 1
      expect(user.reload.avatar).to_not be_blank
      expect(user.avatar.file.filename).to eq 'avatar2.jpg'
    end
  end

  describe 'error messages' do
    before do
      user.update(remove_avatar: true)
    end

    it 'displays server-generated errors' do
      visit edit_user_path(user)
      file_input.set "#{Rails.root}/spec/fixtures/error.jpg"
      sleep 1
      expect(page).to have_text 'server-generated error message'

      # Error clears after an interval
      sleep 1.5
      expect(page).to_not have_text 'server-generated error message'

      expect(user.reload.avatar).to be_blank
    end

    it 'falls back to a generic error' do
      visit edit_user_path(user)
      file_input.set "#{Rails.root}/spec/fixtures/unknownerror.jpg"
      sleep 1
      expect(page).to have_text 'Whoops!'

      # Error clears after an interval
      sleep 1.5
      expect(page).to_not have_text 'Whoops!'

      expect(user.reload.avatar).to be_blank
    end
  end
end
