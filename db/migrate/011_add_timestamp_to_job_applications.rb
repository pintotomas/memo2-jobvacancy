Sequel.migration do
  up do
    add_column :job_applications, :created_on, Date
    add_column :job_applications, :updated_on, Date
  end

  down do
    drop_column :job_applications, :created_on
    drop_column :job_applications, :updated_on
  end
end
