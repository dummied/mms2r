#--
# Copyright (c) 2007-2010 by Mike Mondragon (mikemondragon@gmail.com)
#
# Please see the LICENSE file for licensing information.
#++

module MMS2R

  ##
  # A hash of MMS2R processors keyed by MMS carrier domain.

  CARRIERS = {}

  ##
  # Registers a class as a processor for a MMS domain.  Should only be
  # used in special cases such as MMS2R::Media::Sprint for 'pm.sprint.com'

  def self.register(domain, processor_class)
    MMS2R::CARRIERS[domain] = processor_class
  end

  ##
  # A hash of file extensions for common mime-types

  EXT = {
    'text/plain' => 'text',
    'text/plain' => 'txt',
    'text/html' => 'html',
    'image/png' => 'png',
    'image/gif' => 'gif',
    'image/jpeg' => 'jpeg',
    'image/jpeg' => 'jpg',
    'video/quicktime' => 'mov',
    'video/3gpp2' => '3g2'
  }

  class MMS2R::Media

    ##
    # MMS2R library version

    VERSION = '3.3.1'

  end

  # Simple convenience function to make it a one-liner:
  # MMS2R.parse raw_mail or MMS2R.parse File.load(raw_mail)
  # Combined w/ the method_missing delegation, this should behave as an enhanced Mail object, more or less.
  def self.parse raw_mail
    mail = Mail.new raw_mail
    MMS2R::Media.new(mail) end

end

unless Object.respond_to?(:blank?)
  class Object
    def blank?
      if respond_to?(:empty?) && respond_to?(:strip)
        empty? or strip.empty?
      elsif respond_to?(:empty?)
        empty?
      else
        !self
      end
    end
  end
end

%W{ mail fileutils pathname tmpdir yaml uuidtools iconv exifr }.each do |g|
  begin
    gem 'mail', '= 2.2.13' if g == 'mail'
    require g
  rescue LoadError
    require 'rubygems'
    require g
  end
end

require File.join(File.dirname(__FILE__), 'mail_ext')
require File.join(File.dirname(__FILE__), 'mms2r', 'media')
require File.join(File.dirname(__FILE__), 'mms2r', 'media', 'sprint')
MMS2R.register('pm.sprint.com', MMS2R::Media::Sprint)
