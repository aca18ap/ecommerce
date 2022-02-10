class UserDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def unlock_button?
    if unlock_token.nil?
      ''
    else
      h.link_to 'Unlock', h.unlock_user_path(id),
                method: :patch, class: 'btn btn-xs',
                data: { confirm: 'Are you sure you want to unlock this account?' }
    end
  end

end
