# frozen_string_literal: true
class RemoveAccountEmails < ActiveRecord::Migration
  def change
    drop_table :core_account_emails
  end
end
