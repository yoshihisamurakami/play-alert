class ContactsController < ApplicationController
  def index
    @contact = Contact.new
  end
  
  def confirm
    @contact = Contact.new(contact_params)
  end
  
  def sent
    @contact = Contact.new(contact_params)
    StageMailer.contact(@contact).deliver_now
  end
  
  private
  def contact_params
    params.require(:contact).permit(
        :name, :body
      )
  end
end