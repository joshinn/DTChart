
Pod::Spec.new do |s|

  s.name         = "DTChart"
  s.version      = "0.1"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.summary      = "a simple chart for DTise"
  s.author       = { "joshin" => "xjcute@gmail.com" }
  s.homepage     = "https://github.com/joshinn/DTChart"
  s.description  = '为DTise定制的统计图表，第1版，支持柱状图和折线图。'
  s.requires_arc = true
  s.platform     = :ios, "8.0"
  s.frameworks   = 'UIKit', 'Foundation'

  s.source       = { :git => "https://github.com/joshinn/DTChart.git", :tag => s.version.to_s }
  s.source_files  = "DTChart", "DTChart/**/*.{h,m}"

end
