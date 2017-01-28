class Class
  def subclasses
    result = []
    ObjectSpace.each_object(Class) do |k|
      next unless k < self
      next if k.respond_to?(:singleton_class?) && k.singleton_class?
      result << k
    end
    result
  end
end
