require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|

  s.name         = "react-native-sq-core-motion"
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']
  s.author       = package['author']
  s.homepage     = package['homepage']
  s.license = { :type => 'MIT', :text => <<-LICENSE
                     MIT License
                     Permission is hereby granted, free of charge, to any person obtaining a copy
                     of this software and associated documentation files (the "Software"), to deal
                     in the Software without restriction, including without limitation the rights
                     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
                     copies of the Software, and to permit persons to whom the Software is
                     furnished to do so, subject to the following conditions:
                     The above copyright notice and this permission notice shall be included in all
                     copies or substantial portions of the Software.
                     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
                     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
                     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
                     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
                     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
                     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
                     SOFTWARE.
                     LICENSE
                   }


  s.platform = :ios, '15.0'

  s.source = { :git => "https://github.com/sequenia/react-native-sq-core-motion.git", :tag => "#{s.version}" }

  s.preserve_paths = 'LICENSE'
  s.ios.deployment_target = '15.0'
  s.source_files = "ios/**/*.{h,m,swift}"

  s.dependency 'React'

end
