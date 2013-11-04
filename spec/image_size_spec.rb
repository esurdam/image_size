$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'rspec'
require 'image_size'

describe ImageSize do
  [
    ['test.bmp',  :bmp,  50,  50],
    ['test.gif',  :gif, 668, 481],
    ['test.jpg', :jpeg, 320, 240],
    ['test.pbm',  :pbm,  85,  55],
    ['test.pcx',  :pcx,  70,  60],
    ['test.pgm',  :pgm,  90,  55],
    ['test.png',  :png, 640, 532],
    ['test.psd',  :psd,  20,  20],
    ['test.swf',  :swf, 450, 200],
    ['test.tif', :tiff,  64,  64],
    ['test.xbm',  :xbm,  16,  16],
    ['test.xpm',  :xpm,  32,  32],
    ['image_size_spec.rb', nil, nil, nil],
  ].each do |name, format, width, height|
    path = File.join(File.dirname(__FILE__), name)
    file_data = File.open(path, 'rb', &:read)

    it "should get format and dimensions for #{name} given IO" do
      File.open(path, 'rb') do |fh|
        is = ImageSize.new(fh)
        [is.format, is.width, is.height].should == [format, width, height]
        fh.read.should == file_data
      end
    end

    it "should get format and dimensions for #{name} given StringIO" do
      io = StringIO.new(file_data)
      is = ImageSize.new(io)
      [is.format, is.width, is.height].should == [format, width, height]
      io.read.should == file_data
    end

    it "should get format and dimensions for #{name} given file data" do
      is = ImageSize.new(file_data)
      [is.format, is.width, is.height].should == [format, width, height]
    end

    it "should get format and dimensions for #{name} given Tempfile" do
      Tempfile.open(name) do |tf|
        tf.binmode
        tf.write(file_data)
        tf.rewind
        is = ImageSize.new(tf)
        [is.format, is.width, is.height].should == [format, width, height]
        tf.read.should == file_data
      end
    end

    it "should get format and dimensions for #{name} given IO when run twice" do
      File.open(path, 'rb') do |fh|
        is = ImageSize.new(fh)
        [is.format, is.width, is.height].should == [format, width, height]
        is = ImageSize.new(fh)
        [is.format, is.width, is.height].should == [format, width, height]
      end
    end

    it "should get format and dimensions for #{name} as path" do
      is = ImageSize.path(path)
      [is.format, is.width, is.height].should == [format, width, height]
    end
  end

  it "should raise ArgumentError if argument is not valid" do
    lambda {
      ImageSize.new(Object)
    }.should raise_error(ArgumentError)
  end
end
