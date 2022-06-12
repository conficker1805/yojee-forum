class ResetCounterQuery
  def self.call(parent_table, child_table)
    query = <<-SQL.squish
      UPDATE #{parent_table} SET #{child_table}_count = (
        SELECT count(1)
        FROM #{child_table}
        WHERE #{child_table}.#{parent_table.singularize}_id = #{parent_table}.id
      )
    SQL

    ActiveRecord::Base.connection.execute(query)
  end
end
