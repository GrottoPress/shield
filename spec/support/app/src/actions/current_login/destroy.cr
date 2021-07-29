class CurrentLogin::Destroy < BrowserAction
  include Shield::CurrentLogin::Destroy

  delete "/log-out" do
    run_operation
  end

  def do_run_operation_succeeded(operation, login)
    response.headers["X-Current-Login"] = "0"
    previous_def
  end

  def remote_ip? : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
