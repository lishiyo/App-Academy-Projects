module SessionsHelper
	
	def remember(user)
		user.remember # generate remember_token and set in database
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	def forget(user)
		user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
	end
	
end
