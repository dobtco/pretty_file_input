require 'spec_helper'

describe 'Users', js: true, type: :feature do
  let!(:user) do
    User.create(avatar: File.open("#{Rails.root}/../fixtures/avatar.jpg"))
  end

  let(:created_user) { User.last }

  describe '#new + #create' do
    it 'functions properly' do
      visit new_user_path
      attach_file 'user[avatar]', "#{Rails.root}/../fixtures/avatar2.jpg"

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
      find('input[type=file]').set "#{Rails.root}/../fixtures/avatar2.jpg"
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
      find('input[type=file]').set "#{Rails.root}/../fixtures/avatar2.jpg"
      sleep 1
      expect(user.reload.avatar).to_not be_blank
      expect(user.avatar.file.filename).to eq 'avatar2.jpg'
    end
  end
end
