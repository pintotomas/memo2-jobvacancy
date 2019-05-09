Sequel.migration do
  up do
    add_column :job_offers, :validity_time, String
  end

  down do
    drop_column :job_offers, :validity_time
  end
end
