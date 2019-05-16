Sequel.migration do
  up do
    drop_column :job_offers, :experience
    add_column :job_offers, :experience, Integer, null: true
  end

  down do
    drop_column :job_offers, :experience
    add_column :job_offers, :experience, Integer
  end
end
