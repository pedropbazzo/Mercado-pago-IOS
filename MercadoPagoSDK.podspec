Pod::Spec.new do |s|
  s.name             = "MercadoPagoSDK"
  s.version          = "4.7.6"
  s.summary          = "MercadoPagoSDK"
  s.homepage         = "https://www.mercadopago.com"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = "Mercado Pago"
  s.source           = { :git => "https://github.com/mercadopago/px-ios.git", :tag => s.version.to_s }
  s.swift_version = '4.2'
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.default_subspec = 'Default'

  s.subspec 'Default' do |default|
    default.resources = ['MercadoPagoSDK/MercadoPagoSDK/*.xcassets','MercadoPagoSDK/MercadoPagoSDK/*/*.xcassets', 'MercadoPagoSDK/MercadoPagoSDK/*.ttf', 'MercadoPagoSDK/MercadoPagoSDK/**/**.{xib,strings}', 'MercadoPagoSDK/MercadoPagoSDK/Translations/**/**.{plist,strings}', 'MercadoPagoSDK/MercadoPagoSDK/Plist/*.plist', 'MercadoPagoSDK/MercadoPagoSDK/*.lproj']
    default.source_files = ['MercadoPagoSDK/MercadoPagoSDK/**/**/**.{h,m,swift}']
    default.dependency 'MLUI', '~> 5.0'
  end

  #s.test_spec do |test_spec|
    #test_spec.source_files = 'MercadoPagoSDK/MercadoPagoSDKTests/*'
    #test_spec.frameworks = 'XCTest'
  #end

end
