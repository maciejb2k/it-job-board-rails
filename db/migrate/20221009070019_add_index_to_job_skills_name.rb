class AddIndexToJobSkillsName < ActiveRecord::Migration[7.0]
  def change
    add_index :job_skills, :name
  end
end
