require 'rails_helper'

RSpec.describe do
  describe '1.Active Strageを使用していること' do
    before do
      visit new_user_path
      fill_in 'user_name', with: 'user_name'
      fill_in 'user_email', with: 'user@gmail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      attach_file 'user[profile_image]', "#{Rails.root}/spec/fixtures/images/スクリーンショット 2021-01-08 18.33.25のコピー.png"
      find('input[type="submit"]').click
    end
    let!(:user){User.take}
    it '画像がActive Strageに保存されていること' do
      expect(user.profile_image.class).to eq ActiveStorage::Attached::One
    end
  end
  describe '2.関連付けに使用するカラム名に`profile_image`が使用されていること' do
    before do
      visit new_user_path
      fill_in 'user_name', with: 'user_name'
      fill_in 'user_email', with: 'user@gmail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      attach_file 'user[profile_image]', "#{Rails.root}/spec/fixtures/images/スクリーンショット 2021-01-08 18.33.25のコピー.png"
      find('input[type="submit"]').click
    end
    let!(:user){User.take}
    it 'has_one_attached :profile_imageが定義されていること' do
      expect(user.profile_image).to be_attached
    end
  end
  describe '3.プロフィール画像を選択してユーザ登録した際、詳細画面に遷移させ、プロフィール画像を表示されること' do
    before do
      visit new_user_path
      fill_in 'user_name', with: 'user_name'
      fill_in 'user_email', with: 'user@gmail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      attach_file 'user[profile_image]', "#{Rails.root}/spec/fixtures/images/スクリーンショット 2021-01-08 18.33.25のコピー.png"
      find('input[type="submit"]').click
    end
    let!(:user){User.take}
    it 'プロフィール画像を選択してユーザ登録した際、詳細画面に遷移すること' do
      expect(current_path).to eq user_path(user.id)
    end
    it 'プロフィール画像を選択してユーザ登録した際、プロフィール画像を表示されること' do
      # 画像の全体パスだと投稿時刻によって変化するため、変化しない一部比較しテスト
      expect(page.find('img')['src']).to have_content '202021-01-08%2018.33.25%E3%81%AE%E3%82%B3%E3%83%94%E3%83%BC.png'
    end
  end
  describe '4.プロフィール画像を選択せずにユーザ登録した際、エラーを発生させずに詳細画面に遷移させること' do
    before do
      visit new_user_path
      fill_in 'user_name', with: 'user_name'
      fill_in 'user_email', with: 'user@gmail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      find('input[type="submit"]').click
    end
    let!(:user){User.take}
    it 'プロフィール画像を選択せずにユーザ登録した際、詳細画面に遷移すること' do
      expect(current_path).to eq user_path(user.id)
    end
  end
  describe '5.ユーザ登録した際、Action Mailerを使ってそのユーザにメールを送信すること' do
    it 'ユーザ登録したユーザにメールが送信される' do
      visit new_user_path
      fill_in 'user_name', with: 'user_name'
      fill_in 'user_email', with: 'user@gmail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      attach_file 'user[profile_image]', "#{Rails.root}/spec/fixtures/images/スクリーンショット 2021-01-08 18.33.25のコピー.png"
      perform_enqueued_jobs do
        find('input[type="submit"]').click
      end
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq ['user@gmail.com']
    end
  end
  describe "6.手順2で指定したメール文章が送信されていること" do
    it "送信されるメール情報が意図通りであること" do
      visit new_user_path
      fill_in 'user_name', with: 'user_name'
      fill_in 'user_email', with: 'user@gmail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      attach_file 'user[profile_image]', "#{Rails.root}/spec/fixtures/images/スクリーンショット 2021-01-08 18.33.25のコピー.png"
      perform_enqueued_jobs do
        find('input[type="submit"]').click
      end
      email = ActionMailer::Base.deliveries.last
      expect(email.from).to eq ["admin@example.com"]
      expect(email.subject).to eq "登録完了"
      expect(email.decoded).to include "user_name"
      expect(email.decoded).to include "ユーザ登録が完了しました。"
    end
  end
  describe '7.Acitve Jobを実装し、`deliever_later`メソッドを使って非同期でメールを送信すること' do
    it 'ユーザ登録時にキューが追加されること' do
      visit new_user_path
      fill_in 'user_name', with: 'user_name'
      fill_in 'user_email', with: 'user@gmail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      attach_file 'user[profile_image]', "#{Rails.root}/spec/fixtures/images/スクリーンショット 2021-01-08 18.33.25のコピー.png"
      expect { find('input[type="submit"]').click }.to change { enqueued_jobs.size }.by(2)
    end
  end
end
