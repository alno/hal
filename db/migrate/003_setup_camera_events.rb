Sequel.migration do

  change do
    create_table :camera_events do
      column :id, 'bigserial', primary_key: true
      column :event, 'text'

      column :camera, 'int', null: false

      column :frame, 'integer'

      column :file_name, 'text', null: false
      column :file_type, 'integer'

      column :time, 'timestamp'

      index :event
    end
  end

end
