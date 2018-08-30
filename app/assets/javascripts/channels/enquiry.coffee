App.enquiry = App.cable.subscriptions.create "EnquiryChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    if data['message'] then
    elm = '<div class="text-right"> <div class="sender">'+data['message']+'</div></div>' if data['sender'] == 1
    elm = '<div class="text-left"> <div class="recipient">'+data['message']+'</div></div>' if data['sender'] == 0
    $("#messages").find(".messages-"+ data['enquiry_id']).append(elm)
    $('.notification').attr('style', 'color: red')
    count = $('#notification-content li').find('<a href="/enquiries/'+ data['enquiry_id']+'/edit"> Enquiry'+ data['enquiry_id']+'</a>').length

    $('#notification-content').append('<li></li>').html('<a href="/enquiries/'+ data['enquiry_id']+'/edit"> Enquiry'+ data['enquiry_id']+'</a>') if count == 0
    element = document.getElementById("messages")
    element.scrollTop = element.scrollHeight


    if data['changes'] then
    for k,v of data['changes']
      $(".enquiry-"+ data['enquiry_id']+"-"+k).attr('value', v)


    # Called when there's incoming data on the websocket for this channel

  speak: (message) ->
    @perform 'speak', message: message

$(document).on 'keypress', '.new_message', (event) ->
  if event.keyCode is 13
    event.target.values = $(this).serializeArray()
    App.enquiry.speak event.target.values
    event.target.value = ' '
    event.preventDefault()
