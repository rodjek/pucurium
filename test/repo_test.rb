require File.expand_path "../test_helper", __FILE__
require 'base64'

context "Docurium Header Parsing" do
  setup do
    @path = File.dirname(__FILE__) + '/fixtures/git2'
    @doc  = Docurium.new(@path)
    @doc.set_function_filter('git_')
    @doc.parse_headers
    @data = @doc.data
  end

  test "can parse header files" do
    keys = @data.keys.map { |k| k.to_s }.sort
    assert_equal ['files', 'functions', 'groups'], keys
    assert_equal 149, @data[:functions].size
  end

  test "can parse normal functions" do
    func = @data[:functions]['git_blob_rawcontent']
    assert_equal 'const void *',     func[:return]
    assert_equal 73,        func[:line]
    assert_equal 'blob.h',  func[:file]
    assert_equal 'blob',        func[:args][0][:name]
    assert_equal 'git_blob *',  func[:args][0][:type]
  end

  test "can parse defined functions" do
    func = @data[:functions]['git_tree_lookup']
    assert_equal 'int',     func[:return]
    assert_equal 42,        func[:line]
    assert_equal 'tree.h',  func[:file]
    assert_equal 'id',            func[:args][2][:name]
    assert_equal 'const git_oid *',  func[:args][2][:type]
  end

  test "can parse function cast args" do
    func = @data[:functions]['git_reference_listcb']
    assert_equal 'int',             func[:return]
    assert_equal 301,               func[:line]
    assert_equal 'refs.h',          func[:file]
    assert_equal 'repo',              func[:args][0][:name]
    assert_equal 'git_repository *',  func[:args][0][:type]
    assert_equal 'list_flags',      func[:args][1][:name]
    assert_equal 'unsigned int',    func[:args][1][:type]
    assert_equal 'callback',        func[:args][2][:name]
    assert_equal 'int(*)(const char *, void *)', func[:args][2][:type]
  end

  test "can group functions" do
    assert_equal 14, @data[:groups].size
    group, funcs = @data[:groups].first
    assert_equal 'blob', group
    assert_equal 6, funcs.size
    group, funcs = @data[:groups].last
    assert_equal 'misc', group
  end

  test "can parse data structures" do
  end

end