# encoding: utf-8

require 'sequel'
require 'carrierwave'

module CarrierWave
  module Sequel
    include CarrierWave::Mount

    def mount_uploader(column, uploader, options={}, &block)
      raise "You need to use Sequel 3.0 or higher. Please upgrade." unless ::Sequel::Model.respond_to?(:plugin)
      super

      mod = Module.new
      include mod
      mod.class_eval <<-RUBY, __FILE__, __LINE__+1
        def #{column}=(new_file)
          if !(new_file.blank? && send(:#{column}).blank?)
            modified!
          end
          super
        end

        def remove_#{column}!
          modified!
          super
        end

        def remove_#{column}=(value)
          modified!
          super
        end

        # Reset cached mounter on record reload
        def reload(*)
          @_mounters = nil
          super
        end

        def remote_#{column}_url=(url)
          modified!
          super
        end

        def remote_#{column}_urls=(url)
          modified!
          super
        end
      RUBY

      alias_method :read_uploader, :[]
      alias_method :write_uploader, :[]=

      include CarrierWave::Sequel::Hooks
    end

  end # Sequel
end # CarrierWave

# Instance hook methods for the Sequel 3.x
module CarrierWave::Sequel::Hooks
  def after_save
    return false if super == false
    self.class.uploaders.each_key {|column| self.send("store_#{column}!") }
  end

  def before_save
    return false if super == false
    self.class.uploaders.each_key {|column| self.send("write_#{column}_identifier") }
  end

  def before_destroy
    return false if super == false
    self.class.uploaders.each_key {|column| self.send("remove_#{column}!") }
  end
end

Sequel::Model.send(:extend, CarrierWave::Sequel)
