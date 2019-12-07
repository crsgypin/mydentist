class AddLiffToClinic < ActiveRecord::Migration[5.1]
  def up
  	rename_column :clinics, :channel_secret, :line_channel_secret
  	rename_column :clinics, :channel_token, :line_channel_access_token
  	add_column :clinics, :line_account_id, :string, limit: 100, after: :description
  	add_column :clinics, :line_channel_id, :string, limit: 100, after: :line_account_id
    add_column :clinics, :line_liff_event_url, :string, limit: 100, after: :line_channel_access_token
    add_column :clinics, :line_liff_doctor_url, :string, limit: 100, after: :line_liff_event_url
    add_column :clinics, :line_liff_patient_url, :string, limit: 100, after: :line_liff_doctor_url
  end

  def down
  	rename_column :clinics, :line_channel_secret, :channel_secret
  	rename_column :clinics, :line_channel_access_token, :channel_token
  	remove_column :clinics, :line_account_id
  	remove_column :clinics, :line_channel_id
    remove_column :clinics, :line_liff_event_url
    remove_column :clinics, :line_liff_doctor_url
    remove_column :clinics, :line_liff_patient_url
  end
end
