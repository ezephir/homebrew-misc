class Twelf < Formula
  homepage "http://www.twelf.org"
  head "https://github.com/standardml/twelf.git"
  
  depends_on "gmp"
  depends_on "mlton" => :build
  
  def install
    ENV.deparallelize  
    
    system "make", "mlton"
    %w{bin emacs}.each do |name|
      prefix.install "#{name}"
    end
  end

  test do
    system "false"
  end
end