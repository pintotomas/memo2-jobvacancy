Sequel.migration do
  up do
    add_column :job_offers, :experience, Integer
  end

  down do
    drop_column :job_offers, :experience, Integer
  end
end
