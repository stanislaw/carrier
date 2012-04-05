module NavigationHelpers
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    when /the sign in page/
      new_user_session_path
 
    when /Carrier's (main|'inbox') page/
      messages_path

    when /Carrier's 'sent' page/
      sent_messages_path
    
    when /new message path/
      new_message_path

    when /this message page/
      message_path @message
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
