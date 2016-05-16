Pod::Spec.new do |s|
	s.name 				= 'CQZPurchaseManager'
  	s.version			= '0.5.0'
  	s.summary 			= 'PurchaseManager'
  	s.homepage 			= 'https://github.com/anthonyqz/CQZPurchaseManager'
  	s.author 			= { "Christian Quicano" => "anthony.qz@ecorenetworks.com" }
  	s.source 			= {:git => 'https://github.com/anthonyqz/CQZPurchaseManager', :tag => s.version}
  	s.ios.deployment_target 	= '8.0'
  	s.requires_arc 			= true
	s.frameworks             	= "Foundation", "StoreKit"
	s.source_files			= 'project/CQZPurchaseManager/*.swift'
end