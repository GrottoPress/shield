Spec.before_each do
  WebMock.reset
  WebMock.allow_net_connect = true
end
