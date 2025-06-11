# Sim800c

**Sim800c** is a Ruby gem that provides a clean interface to the SIM800C GSM/GPRS module using AT commands over a serial connection. Easily send SMS, manage inbox/outbox, query signal strength, check battery info, and more.

---

## ✨ Features

- 📤 Send SMS (immediate or stored)
- 📩 Read, list, and delete messages
- 📶 Monitor signal quality (RSSI)
- 🔋 Check battery status and voltage
- 💾 Get SIM storage usage info

---

## Installation

```ruby
gem 'sim800c'
```

then run:

```
bundle install
```

Or install it directly:

```
gem install sim800c
```

## Overview

```ruby
require 'sim800c'

port_path = Sim800c.find_port # /dev/ttyUSB0
client = Sim800c::Client.new(port_path, baud: 9600)

# Send SMS
client.send_message("+639123456789", "Hello from SIM800C!")

# Store and then send SMS
client.save_and_send_message("+639123456789", "Stored first, sent later")

# List of all messages
puts client.list_messages.all

# Check signal quality
puts client.signal_quality.info

# Get battery info
puts client.device.battery_info

# Delete message by index
client.delete_message.by_index(1)

# ...and more
```

## Usage

### Message Listing
```ruby
messages = client.list_messages

messages.all    # => All messages
messages.unread # => => Only unread messages
messages.read   # => Sent messages
messages.unsent # => Unsent messages
messages.sent   # => Sent messages
```

### Message Deletion

```ruby
deleter = client.delete_message

deleter.by_index(1)              # => delete specific message by index
deleter.all                      # => delete all messages
deleter.all_read                 # => delete all read messages
deleter.all_read_and_sent        # => delete all read and sent messages
deleter.all_read_sent_and_unsent # => same with .all

```

### Signal Quality

```ruby
signal = client.signal_quality

signal.info   # => { rssi: 25, bars: 5, strength: 'Excellent' }
signal.rssi   # => 25
```

### Device / Battery Info

```ruby
device = client.device

device.battery_info
# => {
#      charge_status: 0,
#      battery_level: 100,
#      voltage_mv: 4367,
#      charge_status_label: "Not charging"
#    }
```

### Storage Info

```ruby
client.storage_info
# => [{
#       storage_type: "read_write",
#       memory: "SM",
#       used: 2,
#       total: 30
#    }]
```

### TODOs:
- Add HTTP/TCP support
- Enable incoming SMS handling (AT+CNMI)
- Command retries with timeout/backoff

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/denmarkmeralpis/sim800c. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/denmarkmeralpis/sim800c/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sim800c project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/denmarkmeralpis/sim800c/blob/main/CODE_OF_CONDUCT.md).