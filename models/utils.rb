class Hash
  def symkeys
    Hash[self.map{|(k,v)| [k.to_sym,v]}]
  end
end