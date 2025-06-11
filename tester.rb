def parse_cmgl_response(response)
  messages = []
  lines = response.split("\r\n").reject(&:empty?)

  i = 0
  while i < lines.length
    if lines[i].start_with?("+CMGL:")
      header = lines[i]
      message_lines = []

      # Collect message body lines until next +CMGL or end
      i += 1
      while i < lines.length && !lines[i].start_with?("+CMGL:")
        message_lines << lines[i]
        i += 1
      end

      # Parse the header
      if header =~ /^\+CMGL:\s*(\d+),"(.*?)","(.*?)",".*?","(.*?)"$/
        index = $1.to_i
        status = $2
        sender = $3
        datetime = $4

        date, time = datetime.split(',', 2)
        message = message_lines.join("\n").strip

        messages << {
          index: index,
          status: status,
          sender: sender,
          date: date,
          time: time,
          message: message
        }
      end
    else
      i += 1
    end
  end

  messages
end

# raw_response = "AT+CMGL=\"ALL\"\r\r\r\n+CMGL: 1,\"REC READ\",\"+639177710296\",\"\",\"25/06/01,16:07:08+32\"\r\nTest\r\n\r\n+CMGL: 2,\"REC READ\",\"SMART\",\"\",\"25/05/31,18:26:34+32\"\r\n Prepaid load and don't miss the buzzer-beaters, dunks, and drama this Playoffs season!\r\n\r\n+CMGL: 3,\"REC READ\",\"+639177710296\",\"\",\"25/06/01,15:58:55+32\"\r\nHello?\r\n\r\n+CMGL: 4,\"REC READ\",\"+639177710296\",\"\",\"25/06/01,16:03:07+32\"\r\nDhjsjss\r\n\r\n+CMGL: 5,\"REC READ\",\"+639177710296\",\"\",\"25/06/01,16:03:08+32\"\r\nBdhshhs\r\n\r\n+CMGL: 6,\"REC READ\",\"+639177710296\",\"\",\"25/06/01,16:08:24+32\"\r\nYcucuf\r\n\r\n+CMGL: 7,\"REC READ\",\"SMART\",\"\",\"25/06/07,11:46:57+32\"\r\nGet FREE 5 GB to power your streaming, surfing, and scrolling this long weekend!\n\nLoad POWER ALL 149 via GCash to get a total of 21 GB\r\n\r\n+CMGL: 8,\"REC READ\",\"SMART\",\"\",\"25/06/07,11:46:58+32\"\r\n (16 GB + FREE 5 GB) for all sites and apps + UNLI Tikok or UNLI FB + UNLI calls & texts valid for 7 days.\n\nPromo valid until June 8, \r\n\r\n+CMGL: 9,\"REC READ\",\"SMART\",\"\",\"25/06/07,11:46:57+32\"\r\n2025 only. Hurry, load via GCash now!\r\n\r\n+CMGL: 10,\"REC READ\",\"SMART\",\"\",\"25/06/08,14:08:57+32\"\r\nWith Smart's MOVIE 5, watch \"Tiktik: The Aswang Chronicles\" on WATCHAPP -- NO APP and NO SUBSCRIPTION needed!\n\nVisit the WATCHAPP webs\r\n\r\n+CMGL: 11,\"REC READ\",\"SMART\",\"\",\"25/06/08,14:08:58+32\"\r\nite and for only P5, enjoy the movie kasama na ang data! Load now!\r\n\r\n+CMGL: 12,\"REC READ\",\"SMART\",\"\",\"25/06/08,15:59:18+32\"\r\nYour regular load has been fully consumed. Add Regular Load NOW to continue enjoying our promos and services.                                                  \r\n\r\n+CMGL: 13,\"REC READ\",\"SMART\",\"\",\"25/06/08,15:59:18+32\"\r\n Stay always connected! Check your balance regularly and stay up-to-date with the latest offers via the Smart App!\r\n\r\n+CMGL: 14,\"REC READ\",\"SMART\",\"\",\"25/06/08,16:13:52+32\"\r\n08Jun 16:13: ALL ACCESS+ 99 loaded to 639627821544 from XXXXXXXX7428. Ref:EVCF81OK9USZ. Use Smart App for the best promos & deals!\r\n\r\n+CMGL: 15,\"REC READ\",\"SMART\",\"\",\"25/06/08,16:13:52+32\"\r\nStay always connected! Check your balance regularly and stay up-to-date with the latest offers via the Smart App!\r\n\r\n+CMGL: 16,\"REC READ\",\"SMART\",\"\",\"25/06/08,16:13:52+32\"\r\nAwesome! You can now enjoy 5 GB + UNLI CALLS & TEXTS for 15 days with ALL ACCESS+ 99.\r\n\r\n+CMGL: 17,\"REC READ\",\"SMART\",\"\",\"25/06/08,16:14:42+32\"\r\nNO APP and NO SUBSCRIPTION needed! Stream movies and series in https://watchapp.ph using Smart's MOVIE 5. Load via Smart App NOW!\r\n\r\n+CMGL: 18,\"REC READ\",\"+639177710296\",\"\",\"25/06/08,17:29:13+32\"\r\nLhckdyke\nTn\nSg\nN\nEth\nWt\nH\nWth\nW\nTh\nWth\r\n\r\nOK\r\n"

# parsed_messages = parse_cmgl_response(raw_response)
# puts parsed_messages

require 'rubyserial'

serial = Serial.new('/dev/tty.usbserial-110', 9600)
serial.write("AT+CMGF=1\r")
serial.write("AT+CMGL=\"ALL\"\r")

response = ''
loop do
  chunk = serial.read(1024)
  response << chunk
  break if response.include?("\r\nOK\r\n") || response.include?("\r\nERROR\r\n")
  response
end
puts response





# require 'rubyserial'

# port = Serial.new('/dev/cu.usbserial-110', 9600) # update to your device

# # Send AT commands
# port.write("AT\r")
# sleep(0.5)
# puts port.read(1000)

# port.write("AT+CMGF=1\r")       # Set text mode
# sleep(0.5)
# puts port.read(1000)

# port.write("AT+CMGL=\"ALL\"\r") # List all messages
# # sleep(2)                        # wait for response

# response = ""

# loop do
#   chunk = port.read(1000)
#   response << chunk
#   break if response.include?("\r\nOK\r\n") || response.include?("\r\nERROR\r\n")
#   sleep 0.2
# end

# puts response

# port.close