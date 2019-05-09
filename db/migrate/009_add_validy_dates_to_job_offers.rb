Sequel.migration do
  up do
    add_column :job_offers, :validity_date, Date
    add_column :job_offers, :validity_time, Date
  end

  down do
    drop_column :job_offers, :validity_date
    drop_column :job_offers, :validity_time
  end
end
