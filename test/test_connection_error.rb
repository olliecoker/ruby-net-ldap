require_relative 'test_helper'
require 'net/ldap/error'

class TestConnectionError < Test::Unit::TestCase
  def test_new_with_one_connection_refused
    errors = [[Errno::ECONNREFUSED.new('abc'), 'host', 7]]
    error = Net::LDAP::ConnectionError.new(errors)
    assert_equal error, Net::LDAP::ConnectionRefusedError.new('Connection refused - abc')
  end

  def test_new_with_one_ssl_error
    errors = [[OpenSSL::SSL::SSLError.new('abc'), 'host', 7]]
    error = Net::LDAP::ConnectionError.new(errors)
    assert_equal error.message, "Unable to connect to any given server: \n  OpenSSL::SSL::SSLError: abc (host:7)"
  end

  def test_new_with_multiple_errors
    errors = [[OpenSSL::SSL::SSLError.new('abc'), 'host', 7], [Errno::ECONNREFUSED.new('abc'), 'host', 7]]
    error = Net::LDAP::ConnectionError.new(errors)
    assert_equal error.message, "Unable to connect to any given server: \n  OpenSSL::SSL::SSLError: abc (host:7)\n  Errno::ECONNREFUSED: Connection refused - abc (host:7)"
  end
end
