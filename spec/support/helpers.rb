def fixture(filename)
  File.read(File.expand_path("../../fixtures/html/#{filename}.html", __FILE__))
end
