Sequel.migration do

  change do
    create_table :state_changes do
      column :node, 'text', null: false
      column :time, 'timestamp', null: false

      column :value, 'json', null: false

      primary_key [:node, :time]
    end
  end

end
