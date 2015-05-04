# -*- encoding : utf-8 -*-
ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'

require 'rubygems'
#require 'test/unit'
require 'minitest/autorun'
#require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/environment.rb'))
require 'active_support'
require 'active_support/test_case'
require 'active_support/logger'

# method source from http://guides.rubyonrails.org/plugins.html
def load_schema
  config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
  ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")

  db_adapter = ENV['DB']

  # no db passed, try one of these fine config-free DBs before bombing.
  db_adapter ||=
    begin
      require 'rubygems'
      require 'sqlite'
      'sqlite'
    rescue MissingSourceFile
      begin
        require 'sqlite3'
        'sqlite3'
      rescue MissingSourceFile
      end
    end

  if db_adapter.nil?
    raise "No DB Adapter selected. Pass the DB= option to pick one, or install Sqlite or Sqlite3."
  end

  ActiveRecord::Base.establish_connection(config[db_adapter])
  load(File.dirname(__FILE__) + "/schema.rb")
end

# validation code taken from http://htmltest.googlecode.com/svn/trunk/html_test/lib/validator.rb
def valid_isdoc?(body)
  schema = File.join(File.dirname(__FILE__), "..", "schema", "isdoc-invoice-dsig-6.0.1.xsd")
  error_file = create_tmp_file("xmllint_error")
  doc_file = command = nil
  doc_file = create_tmp_file("xmllint", body)
  #command = "xmllint --schema #{schema} --noout #{doc_file}"
  command = "xmllint --schema #{schema} #{doc_file}"
  system(command)
  status = $?.exitstatus
  if status == 0
    true
  else
    failure_doc = File.join(Dir::tmpdir, "xmllint_last_response.xml")
    FileUtils.cp doc_file, failure_doc
    puts ("command='#{command}'. ISDOC document at '#{failure_doc}'. " +
      IO.read(error_file))
  end
end

private
def create_tmp_file(name, contents = "")
  tmp_file = Tempfile.new(name)
  tmp_file.puts(contents)
  tmp_file.close
  tmp_file.path
end

def assert_file_equals(isdoc_file, fixture_file)
  diff_file = create_tmp_file("diff_file")
  command = "diff #{isdoc_file} #{fixture_file} >> #{diff_file}"
  system(command)
  diff = File.read(diff_file)
  assert_equal "\n", diff, diff
end
