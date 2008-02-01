require File.join(File.dirname(__FILE__), "..", "lib", "mms2r")
require File.join(File.dirname(__FILE__), "test_helper")
require 'test/unit'
require 'rubygems'
require 'mocha'
gem 'tmail', '>= 1.2.1'
require 'tmail'

class TestMmsAttNet < Test::Unit::TestCase
  include MMS2R::TestHelper

  def test_mms_att_net
    # mms.att.net service
    mail = TMail::Mail.parse(load_mail('att-image-01.mail').join)
    mms = MMS2R::Media.new(mail)

    assert_equal 1, mms.media.size
    assert_not_nil mms.media['image/jpeg']
    assert_equal 1, mms.media['image/jpeg'].size
    assert_not_nil mms.media['image/jpeg'].first
    assert_match(/Photo_12.jpg$/, mms.media['image/jpeg'][0])
    assert_file_size(mms.media['image/jpeg'][0], 337)
    mms.purge
  end

  def test_mms_att_net_subject
    # mms.att.net service

    mail = TMail::Mail.parse(load_mail('att-image-02.mail').join)
    mms = MMS2R::Media.new(mail)

    assert_equal "", mms.subject
    mms.purge
  end

  def test_txt_att_net
    # txt.att.net service
    mail = TMail::Mail.parse(load_mail('att-text-01.mail').join)
    mms = MMS2R::Media.new(mail)

    assert_equal 1, mms.media.size
    assert_not_nil(mms.media['text/plain'])
    assert_equal "Hello World", IO.read(mms.media['text/plain'][0])

    mms.purge
  end

  def test_cingularme_com
    # cingularme.com service
    mail = TMail::Mail.parse(load_mail('cingularme-text-01.mail').join)
    mms = MMS2R::Media.new(mail)

    assert_equal 1, mms.media.size
    assert_not_nil(mms.media['text/plain'])
    assert_equal "hello world", IO.read(mms.media['text/plain'][0])

    mms.purge
  end

  def test_mmode_com
    # mmode.com service
    mail = TMail::Mail.parse(load_mail('mmode-image-01.mail').join)
    mms = MMS2R::Media.new(mail)

    assert_equal 1, mms.media.size
    assert_not_nil mms.media['image/jpeg']
    assert_equal 1, mms.media['image/jpeg'].size
    assert_not_nil mms.media['image/jpeg'].first
    assert_match(/picture\(3\).jpg$/, mms.media['image/jpeg'][0])
    assert_file_size(mms.media['image/jpeg'][0], 337)
    mms.purge
  end

  def test_mms_mycingular_com
    # mms.mycingular.com service
    mail = TMail::Mail.parse(load_mail('mycingular-image-01.mail').join)
    mms = MMS2R::Media.new(mail)

    assert_equal 2, mms.media.size
    assert_not_nil mms.media['text/plain']
    assert_not_nil mms.media['text/plain'][0]
    assert_equal 1, mms.media['text/plain'].size
    assert_not_nil mms.media['image/jpeg']
    assert_not_nil mms.media['image/jpeg'][0]
    assert_equal 1, mms.media['image/jpeg'].size
    assert_not_nil mms.media['image/jpeg'].first
    assert_match(/04-18-07_1723.jpg$/, mms.media['image/jpeg'][0])
    assert_file_size(mms.media['image/jpeg'][0], 337)
    assert_equal "Water", IO.read(mms.media['text/plain'][0])
    mms.purge
  end
end