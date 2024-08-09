json.user do
  Rails.logger.info("Rendering sign_in.json.jbuilder")  # ログを追加
  binding.pry  # デバッグポイント
  json.id @user.id
  json.name @user.name
  json.email @user.email
end