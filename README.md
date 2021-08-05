# Master Crypt

[![CircleCI](https://circleci.com/gh/cianmce/master-crypt.svg?style=shield)](https://circleci.com/gh/cianmce/master-crypt)

Master Key is a gem for encrypting data with a [master keying](https://en.wikipedia.org/wiki/Master_keying) approach

This allows you to have a master key to decrypt the full set of data while also creating keys that can only decrypt a subset of data. These keys can then be safely distributed to relevant actors who will be only able to access their permitted data

You can encrypt data with as many keys as needed, all of which will be able to decrypt the data while only causing a small encrypted data size increase of 129 bytes for each extra key


## Installatio
### Installing RbNaCl
https://github.com/RubyCrypto/rbnacl#installation

#### OS X users
```sh
brew install libsodium
```

#### FreeBSD users
```sh
pkg install libsodium
```

#### APT users

```sh
apt install libsodium-dev
```

### Installing MasterCrypt
```sh
gem install master_crypt
```

## Usage
### Encrypting data with a master key
```ruby
require "master_crypt"

master_key = "Very secure & random master k3y"
other_secret_key = "Another very secure & random other k3y"
plaintext = "Secret data..."
master_crypt = MasterCrypt.new(master_key)

encrypted_data = master_crypt.master_key_encrypt(plaintext, [other_secret_key])
# encrypted_data can be decrypted with either the master_key or other_secret_key
```

### Decrypting data with a master key
```ruby
master_key = "Very secure & random master k3y"
encrypted_data = "...."
master_crypt = MasterCrypt.new(master_key)

plaintext = master_crypt.master_key_decrypt(encrypted_data)
```

### Encrypting data with an array of keys

```ruby
secret_keys = ["array", "of", "secret", "keys"]
encrypted_data = MasterCrypt.encrypt(plaintext, secret_keys)
```

### Decrypting data with a specific key

```ruby
MasterCrypt.decrypt(encrypted_data, secret_keys[0])
```

## Development
```sh
bundle install
```

### Run all specs + standardrb

```sh
bundle exec rake
```

### Run specs using guard

```sh
bundle exec guard
```
