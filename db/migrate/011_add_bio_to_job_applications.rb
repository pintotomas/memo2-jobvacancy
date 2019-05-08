Sequel.migration do
  up do
    add_column :job_applications, :bio, String
  end

  down do
    drop_column :job_applications, :bio
  end
end
