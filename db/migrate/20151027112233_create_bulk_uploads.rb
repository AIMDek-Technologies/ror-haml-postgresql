class CreateBulkUploads < ActiveRecord::Migration
  def change
    create_table :bulk_uploads do |t|
      t.datetime :upload_date
      t.integer :time_taken
      t.integer :total_records
      t.integer :success_count
      t.integer :failure_count
      t.string :file_name
      t.string :error_file_path
      t.integer :user_id

      t.timestamps
    end
  end
end
