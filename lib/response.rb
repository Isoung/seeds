module Response
  def self.failure(err)
    {
      success: false,
      error: err
    }
  end

  def self.success(success, opts)
    response = {
      success: true,
      msg: success
    }

    return response unless opts.length >= 1
    opts.each do |key, value|
      response[key] = value unless response.key? key
    end
    response
  end

  def self.create_response(bool, msg, opts = {})
    return failure(msg) unless bool
    success(msg, opts)
  end
end
