# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'VFCounter' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end 
  # Pods for VFCounter
  pod 'MKRingProgressView'
  pod 'Charts'
  pod 'lottie-ios'
  pod 'TouchAreaInsets'

  target 'VFCounterTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'VFCounterUITests' do
    # Pods for testing
  end

end
