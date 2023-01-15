class ContactMailer < ApplicationMailer

    def contact(user)
        @user = user
        mail(to: "sample@gmail.com", subject:"Inscription terminée")
    end

end
