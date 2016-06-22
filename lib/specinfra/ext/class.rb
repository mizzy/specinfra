class Class
  def subclasses
    result = []
    ObjectSpace.each_object(Class) do |k|
      next unless k == k.ancestors.first #Skips if this is a singleton class
      result << k if k < self
    end
    result
  end
end
