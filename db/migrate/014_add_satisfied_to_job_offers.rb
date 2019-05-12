Sequel.migration do
  up do
    add_column :job_offers, :satisfied, TrueClass, default: false
  end

  down do
    drop_column :job_offers, :satisfied
  end
end
