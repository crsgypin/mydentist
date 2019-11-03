class ChangeDateToVacation < ActiveRecord::Migration[5.1]
  def up
  	rename_column :clinic_vacations, :date, :start_date
  	add_column :clinic_vacations, :end_date, :date, after: :start_date
  	add_column :clinics, :phone2, :string, limit: 100, after: :phone
  end

  def down
  	rename_column :clinic_vacations, :start_date, :date
  	remove_column :clinic_vacations, :end_date
  	remove_column :clinics, :phone2
  end
end
