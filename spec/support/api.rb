def describe_api klass, &block
  describe klass, api: true do
    define_method(:app) do
      klass
    end

    instance_eval(&block)
  end
end
