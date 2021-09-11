# https://github.com/rails/rails/blob/main/activerecord/lib/active_record/inheritance.rb
def find_sti_class(type_name)
  # STIのためのtypeカラムの名前を取得
  type_name = base_class.type_for_attribute(inheritance_column).cast(type_name) 
  # STI 先のクラス名(サブクラス)を取得
  subclass = sti_class_for(type_name)
  # STI 先のクラス名(サブクラス)と一致しない場合はエラー
  unless subclass == self || descendants.include?(subclass)
    raise SubclassNotFound, "Invalid single-table inheritance type: #{subclass.name} is not a subclass of #{name}"
  end
  # STI先のクラス名(サブクラス)を返す
  subclass
end

# Returns the value to be stored in the inheritance column for STI.
def sti_name
  store_full_sti_class && store_full_class_name ? name : name.demodulize
end