# frozen_string_literal: true

namespace :one_off do
  desc "Remove front-end user accounts"
  task remove_frontend_users: :environment do
    User.destroy_all
  end
end
