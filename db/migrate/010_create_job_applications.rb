Sequel.migration do
  up do
    create_table(:job_applications) do
      primary_key :id
      foreign_key :job_offer_id, :job_offers, on_delete: 'cascade'
      String :email
    end
  end

  down do
    drop_table(:job_applications)
  end
end
