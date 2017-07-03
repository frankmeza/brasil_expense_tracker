# auth_controller

AuthCtrl = Brasil.new do
  on post, 'login' do
    set_response_as_json
    input = req.body.read
    body = JSON.parse(input)

    if login User, body['login'], body['password']
      user = User.fetch(body['login'])
      user_data = { username: user.username, email: user.email }

      token = encode_data(user_data)
      auth_token = { token: token }
      res.write auth_token.to_json
    else
      set_response_status 401
      res.write Message.error('invalid_credentials').to_json
    end
  end

  on get, 'logout' do
    set_response_as_json
    logout User
    logged_out = { logged_out: true }
    res.write logged_out.to_json
  end
end

Brasil.define do
  run AuthCtrl
end
