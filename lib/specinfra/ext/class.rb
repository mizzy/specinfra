class Class
  def subclasses
    result = []
    ObjectSpace.each_object(Class) do |k|
      next if k.singleton_class?
      result << k if k < self
    end
    result
  end
end
