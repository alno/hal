Sequel.migration do

  change do
    create_table :gauge_values do
      column :gauge, 'text', null: false
      column :time, 'timestamp', null: false

      column :value, 'real', null: false

      primary_key [ :gauge, :time ]
    end
  end

end
