ActiveSupport.on_load(:action_controller) do
  wrap_parameters format: [:json] if respond_to?(:wrap_parameters)
end

# To enable root element in JSON for ActiveRecord objects.
ActiveSupport.on_load(:active_record) do
  self.include_root_in_json = false
end
