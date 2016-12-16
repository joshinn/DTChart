
Pod::Spec.new do |s|

  s.name         = "DTChart"
  s.version      = "0.2"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.summary      = "a simple chart for DTise"
  s.author       = { "joshin" => "xjcute@gmail.com" }
  s.homepage     = "https://github.com/joshinn/DTChart"
  s.description  = <<-DESC
                    A simple char customized for DTise.
                    If you like the style of chart, you can import it, and use it as sample.
                    DESC
  s.requires_arc = true
  s.platform     = :ios, "8.0"
  s.frameworks   = 'UIKit', 'Foundation'

  s.source       = { :git => "https://github.com/joshinn/DTChart.git", :tag => s.version.to_s }
  s.source_files  = "DTChart", "DTChart/**/*.{h,m}"
  s.prefix_header_file = 'DTChart/DTChart-Prefix.pch'

end
