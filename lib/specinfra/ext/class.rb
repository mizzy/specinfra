class Class
  def subclasses
    result = []
    ObjectSpace.each_object(Class) do |k|
      result << k if k < self
    end
    result
  end
end
