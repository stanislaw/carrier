# encoding: utf-8

class Array
  def without(*keys)
     cpy = self.dup
     keys.each { |key| cpy.delete(key) }
     cpy
  end

  def without_array(keys_array)
    cpy = self.dup
    keys_array.each { |key| cpy.delete(key) }
    cpy
  end
end

