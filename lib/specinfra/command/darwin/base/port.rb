class Specinfra::Command::Darwin::Base::Port < Specinfra::Command::Base::Port
  def check_is_listening(port)
    regexp = ":#{port} "
    "lsof -nP -iTCP -sTCP:LISTEN | grep -- #{escape(regexp)}"
  end
end
