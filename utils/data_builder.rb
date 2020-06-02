module DataBuilder

  def accesor_builder k, v
    if (respond_to?("#{k}") && k.to_s.include?("="))
      send(k, v)
    else
      #First will create a new instance variable, value if it wasn't a Hash or Hash type instead.
      self.instance_variable_set("@#{k}", v)
      #Secondly will define a get instance method for the given value
      self.class.send(:define_method, "#{k}", proc {self.instance_variable_get("@#{k}")})
      #Finally will define a set instance method for the given value. Notice the proc block
      # to be called every time the set method is called.
      self.class.send(:define_method, "#{k}=", proc {|v| self.instance_variable_set("@#{k}", v)})
    end
  end

  #Goes through a complext Hash nest and gets the value of a passed key.
  def nested_hash_value(obj, key)
    #First wil check whether the object has the key? method, which will mean it's a Hash and also if the Hash the method parameter key
    if obj.respond_to?(:key?) && obj.key?(key)
      #Here will just return the value for a given key
      obj[key]
      #If it's not a Hash will check if it's a Array instead, checking out whether it responds to a Array.each method or not.
    elsif obj.respond_to?(:each)
      r = nil
      #The asterisk in this context is called the "splat" operator.
      #This means you can pass multiple parameters in its place and the block will see them as an array.
      #For every Array found it make a recursive call to itself passing the last element of the array and the Key it's looking for.
      obj.find {|*a| r = nested_hash_value(a.last, key)}
      r
    end
  end
end
