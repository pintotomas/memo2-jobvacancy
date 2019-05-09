Sequel.migration do
  up do
    drop_column :job_offers, :validity_time
  end

  down do
    add_column :job_offers, :validity_time, Date
  end
end
